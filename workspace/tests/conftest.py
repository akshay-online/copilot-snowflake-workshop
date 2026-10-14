"""Integration helpers that operate only inside a disposable workshop clone."""

import os
import re
import uuid

import pytest


def checked_name(value):
    if not re.fullmatch(r"[A-Z_][A-Z0-9_]*(\.[A-Z_][A-Z0-9_]*)?", value):
        raise ValueError("Expected an uppercase SQL identifier")
    return value


class WorkshopSession:
    def __init__(self, connection, dict_cursor):
        self.connection = connection
        self.dict_cursor = dict_cursor

    def execute(self, sql, params=None):
        with self.connection.cursor() as cursor:
            cursor.execute(sql, params)
            return cursor.rowcount

    def query(self, sql, params=None):
        with self.connection.cursor(self.dict_cursor) as cursor:
            cursor.execute(sql, params)
            return cursor.fetchall()

    def scalar(self, sql, params=None):
        with self.connection.cursor() as cursor:
            cursor.execute(sql, params)
            row = cursor.fetchone()
            return row[0] if row else None

    def call(self, procedure, *args):
        checked_name(procedure)
        placeholders = ", ".join(["%s"] * len(args))
        return self.scalar(f"CALL {procedure}({placeholders})", args)

    def truncate(self, *tables):
        for table in tables:
            self.execute("TRUNCATE TABLE IDENTIFIER(%s)", (checked_name(table),))

    def insert_rows(self, table, rows):
        if not rows:
            return
        columns = [checked_name(column) for column in rows[0]]
        placeholders = ", ".join(["%s"] * len(columns))
        sql = f"INSERT INTO IDENTIFIER(%s) ({', '.join(columns)}) VALUES ({placeholders})"
        for row in rows:
            self.execute(sql, (checked_name(table), *(row[column] for column in columns)))

    def latest_audit(self, procedure):
        rows = self.query(
            "SELECT STATUS, ROW_COUNT, MESSAGE FROM ETL.LOAD_AUDIT "
            "WHERE PROC_NAME = %s ORDER BY AUDIT_ID DESC LIMIT 1",
            (procedure,),
        )
        return rows[0] if rows else None


@pytest.fixture(scope="session")
def sf():
    required = (
        "SNOWFLAKE_ACCOUNT", "SNOWFLAKE_USER", "SNOWFLAKE_ROLE",
        "SNOWFLAKE_WAREHOUSE", "SNOWFLAKE_SOURCE_DATABASE",
    )
    missing = [name for name in required if not os.getenv(name)]
    if missing:
        pytest.skip("Missing workshop environment variables: " + ", ".join(missing))

    source = os.environ["SNOWFLAKE_SOURCE_DATABASE"].upper()
    if not re.fullmatch(r"COPILOT_LAB_[A-Z0-9_]+", source):
        pytest.fail("Source database must be your allocated COPILOT_LAB_<name> sandbox")
    connector = pytest.importorskip("snowflake.connector")
    connection = connector.connect(
        account=os.environ["SNOWFLAKE_ACCOUNT"],
        user=os.environ["SNOWFLAKE_USER"],
        role=os.environ["SNOWFLAKE_ROLE"],
        warehouse=os.environ["SNOWFLAKE_WAREHOUSE"],
        authenticator="externalbrowser",
        session_parameters={"QUERY_TAG": "copilot-participant-workshop"},
    )
    clone = f"{source}_TEST_{uuid.uuid4().hex[:12].upper()}"
    clone_created = False
    session = WorkshopSession(connection, connector.DictCursor)
    try:
        session.execute("CREATE DATABASE IDENTIFIER(%s) CLONE IDENTIFIER(%s)", (clone, source))
        clone_created = True
        session.execute("USE DATABASE IDENTIFIER(%s)", (clone,))
        yield session
    finally:
        try:
            if clone_created:
                session.execute("DROP DATABASE IDENTIFIER(%s)", (clone,))
        finally:
            connection.close()