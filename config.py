import snowflake.connector

def get_connection():
    conn = snowflake.connector.connect(
        user="YOUR USER NAME",
        password="PASSWORD",
        account="lm25289.ap-southeast-7.aws",
        warehouse="GDP_WH",
        database="GDP_ANALYTICS",
        schema="SEM",
        role="ACCOUNTADMIN"
    )
    return conn

