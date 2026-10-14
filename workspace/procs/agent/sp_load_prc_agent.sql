-- OBJECT: ETL.SP_LOAD_PRC_AGENT (intentionally broken exercise starter)
-- PURPOSE: Exercise 03 debugging input; NOT ready for deployment; LAB-101
-- RUN: Review and repair with the requirements and history reference before deploying
CREATE OR REPLACE PROCEDURE ETL.SP_LOAD_PRC_AGENT(P_VALUATION_DATE VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$
var valuationDate = p_valuation_date;
snowflake.execute({sqlText: 'DELETE FROM PROCESSING.PRC_AGENT'});
snowflake.execute({sqlText:
    'INSERT INTO PROCESSING.PRC_AGENT SELECT *, ' + valuationDate +
    ', CURRENT_USER(), CURRENT_TIMESTAMP() FROM HISTORY.HIST_AGENT'
});
return 'done';
$$;