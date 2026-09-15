-- =====================================================
-- File: 08_snowpipes.sql
-- Purpose: Create Snowpipes for Automated Data Loading
-- =====================================================

USE DATABASE GDP_ANALYTICS;
USE SCHEMA RAW;

-- =====================================================
-- Create File Format
-- =====================================================

CREATE OR REPLACE FILE FORMAT CSV_FMT
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- =====================================================
-- Country Pipe
-- =====================================================

CREATE OR REPLACE PIPE COUNTRY_PIPE
AS
COPY INTO RAW.RAW_COUNTRIES
FROM @GDP_STAGE
PATTERN='.*gdp_countries.*\.csv'
FILE_FORMAT=(FORMAT_NAME='CSV_FMT');

-- =====================================================
-- Indicator Pipe
-- =====================================================

CREATE OR REPLACE PIPE INDICATOR_PIPE
AS
COPY INTO RAW.RAW_INDICATORS
FROM @GDP_STAGE
PATTERN='.*gdp_indicators.*\.csv'
FILE_FORMAT=(FORMAT_NAME='CSV_FMT');

-- =====================================================
-- Observation Pipe
-- =====================================================

CREATE OR REPLACE PIPE OBSERVATION_PIPE
AS
COPY INTO RAW.RAW_OBSERVATIONS
FROM @GDP_STAGE
PATTERN='.*gdp_observations.*\.csv'
FILE_FORMAT=(FORMAT_NAME='CSV_FMT');

-- =====================================================
-- FX Rate Pipe
-- =====================================================

CREATE OR REPLACE PIPE FX_RATE_PIPE
AS
COPY INTO RAW.RAW_FX_RATES
FROM @GDP_STAGE
PATTERN='.*gdp_fx_rates.*\.csv'
FILE_FORMAT=(FORMAT_NAME='CSV_FMT');


-- Validate Pipes


SHOW PIPES;


-- Refresh Pipes (Load Existing Files)


ALTER PIPE COUNTRY_PIPE REFRESH;
ALTER PIPE INDICATOR_PIPE REFRESH;
ALTER PIPE OBSERVATION_PIPE REFRESH;
ALTER PIPE FX_RATE_PIPE REFRESH;


-- Validation Queries


SELECT COUNT(*) FROM RAW.RAW_COUNTRIES;
SELECT COUNT(*) FROM RAW.RAW_INDICATORS;
SELECT COUNT(*) FROM RAW.RAW_OBSERVATIONS;
SELECT COUNT(*) FROM RAW.RAW_FX_RATES;