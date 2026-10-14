-- OBJECT: STAGING.AGENT_STAGE
-- PURPOSE: Upload the two synthetic monthly files for LAB-101
-- RUN: SnowSQL/CLI from the workspace folder, with your sandbox selected; not Snowsight
PUT file://data/202609/agent.csv @STAGING.AGENT_STAGE/202609 AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file://data/202610/agent.csv @STAGING.AGENT_STAGE/202610 AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
LIST @STAGING.AGENT_STAGE;