import streamlit as st
import pandas as pd
import plotly.express as px
from config import get_connection

# ==========================
# PAGE CONFIG
# ==========================

st.set_page_config(
    page_title="GDP Analytics Dashboard",
    layout="wide"
)

st.title("🌍 GDP Analytics Dashboard")

# ==========================
# SNOWFLAKE CONNECTION
# ==========================

conn = get_connection()

query = """
SELECT *
FROM SEM.V_GDP_COUNTRY_YEAR
"""

df = pd.read_sql(query, conn)

# ==========================
# KPI CARDS
# ==========================

col1, col2, col3, col4 = st.columns(4)

col1.metric(
    "Countries",
    df["COUNTRY_NAME"].nunique()
)

col2.metric(
    "Indicators",
    df["INDICATOR_NAME"].nunique()
)

col3.metric(
    "Records",
    len(df)
)

col4.metric(
    "Latest Year",
    int(df["YEAR"].max())
)

col5, col6 = st.columns(2)

col5.metric(
    "Max GDP",
    round(df["VALUE"].max(), 2)
)

col6.metric(
    "Average GDP",
    round(df["VALUE"].mean(), 2)
)

# ==========================
# FILTERS
# ==========================

col7, col8 = st.columns(2)

with col7:
    country = st.selectbox(
        "Select Country",
        sorted(df["COUNTRY_NAME"].unique())
    )

with col8:
    indicator = st.selectbox(
        "Select Indicator",
        sorted(df["INDICATOR_NAME"].unique())
    )

filtered_df = df[
    (df["COUNTRY_NAME"] == country) &
    (df["INDICATOR_NAME"] == indicator)
]

# ==========================
# GDP TREND CHART
# ==========================

st.subheader(f"{indicator} Trend - {country}")

if len(filtered_df) < 2:

    st.warning(
        "Only one data point available. A trend line requires multiple years of data."
    )

    fig = px.scatter(
        filtered_df,
        x="YEAR",
        y="VALUE",
        size="VALUE",
        hover_data=["COUNTRY_NAME"]
    )

else:

    fig = px.line(
        filtered_df,
        x="YEAR",
        y="VALUE",
        markers=True
    )

st.plotly_chart(
    fig,
    use_container_width=True
)

# ==========================
# GDP BY COUNTRY
# ==========================

st.subheader("GDP by Country")

country_summary = (
    df.groupby("COUNTRY_NAME")["VALUE"]
      .sum()
      .reset_index()
)

fig2 = px.bar(
    country_summary,
    x="COUNTRY_NAME",
    y="VALUE",
    color="COUNTRY_NAME",
    title="GDP by Country"
)

st.plotly_chart(
    fig2,
    use_container_width=True
)

# ==========================
# COUNTRY COMPARISON
# ==========================

st.subheader("Country Comparison (Latest Year)")

latest_year = df["YEAR"].max()

comparison_df = df[
    (df["YEAR"] == latest_year) &
    (df["INDICATOR_NAME"] == indicator)
]

fig3 = px.bar(
    comparison_df,
    x="COUNTRY_NAME",
    y="VALUE",
    color="COUNTRY_NAME",
    title=f"{indicator} - {latest_year}"
)

st.plotly_chart(
    fig3,
    use_container_width=True
)

# ==========================
# PIE CHART
# ==========================

st.subheader("GDP Share by Country")

pie_df = (
    df.groupby("COUNTRY_NAME")["VALUE"]
      .sum()
      .reset_index()
)

fig4 = px.pie(
    pie_df,
    names="COUNTRY_NAME",
    values="VALUE"
)

st.plotly_chart(
    fig4,
    use_container_width=True
)

# ==========================
# DATA PREVIEW
# ==========================

st.subheader("Data Preview")

st.dataframe(
    filtered_df,
    use_container_width=True
)

# ==========================
# CLOSE CONNECTION
# ==========================

conn.close()