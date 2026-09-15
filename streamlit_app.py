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
# COUNTRY COMPARISON TREND
# ==========================

st.subheader("Country Comparison Trend")

compare_indicator = st.selectbox(
    "Select Indicator for Comparison",
    sorted(df["INDICATOR_NAME"].unique()),
    key="compare_indicator"
)

comparison_df = df[
    df["INDICATOR_NAME"] == compare_indicator
]

selected_countries = st.multiselect(
    "Choose Countries",
    sorted(comparison_df["COUNTRY_NAME"].unique()),
    default=sorted(comparison_df["COUNTRY_NAME"].unique())[:3]
)

comparison_df = comparison_df[
    comparison_df["COUNTRY_NAME"].isin(selected_countries)
]

if not comparison_df.empty:

    fig_compare = px.line(
        comparison_df,
        x="YEAR",
        y="VALUE",
        color="COUNTRY_NAME",
        markers=True,
        title=f"{compare_indicator} Comparison Across Countries"
    )

    fig_compare.update_layout(
        xaxis_title="Year",
        yaxis_title="Value"
    )

    st.plotly_chart(
        fig_compare,
        use_container_width=True
    )

else:
    st.warning(
        "No data available for selected countries."
    )

# ==========================
# TOP COUNTRIES RANKING
# ==========================

st.subheader("Top Countries by Latest GDP Value")

latest_year = df["YEAR"].max()

top_df = df[
    (df["YEAR"] == latest_year) &
    (df["INDICATOR_NAME"] == compare_indicator)
]

fig_top = px.bar(
    top_df.sort_values(
        "VALUE",
        ascending=False
    ),
    x="COUNTRY_NAME",
    y="VALUE",
    color="COUNTRY_NAME",
    title=f"Top Countries ({latest_year})"
)

st.plotly_chart(
    fig_top,
    use_container_width=True
)

# ==========================
# GDP SHARE PIE CHART
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
    values="VALUE",
    title="GDP Share by Country"
)

st.plotly_chart(
    fig4,
    use_container_width=True
)

# ==========================
# GDP DISTRIBUTION
# ==========================

st.subheader("GDP Value Distribution")

fig_hist = px.histogram(
    df,
    x="VALUE",
    nbins=20,
    title="Distribution of GDP Values"
)

st.plotly_chart(
    fig_hist,
    use_container_width=True
)

# ==========================
# AVERAGE GDP BY INDICATOR
# ==========================

st.subheader("Average GDP by Indicator")

indicator_avg = (
    df.groupby("INDICATOR_NAME")["VALUE"]
      .mean()
      .reset_index()
)

fig_indicator = px.bar(
    indicator_avg,
    x="INDICATOR_NAME",
    y="VALUE",
    color="INDICATOR_NAME"
)

st.plotly_chart(
    fig_indicator,
    use_container_width=True
)

# ==========================
# CORRELATION HEATMAP
# ==========================

st.subheader("Indicator Correlation Heatmap")

pivot_df = df.pivot_table(
    index=["COUNTRY_NAME", "YEAR"],
    columns="INDICATOR_NAME",
    values="VALUE",
    aggfunc="mean"
)

corr = pivot_df.corr()

fig_heat = px.imshow(
    corr,
    text_auto=True,
    aspect="auto"
)

st.plotly_chart(
    fig_heat,
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
# DOWNLOAD BUTTON
# ==========================

csv = filtered_df.to_csv(index=False)

st.download_button(
    label="Download Filtered Data",
    data=csv,
    file_name="gdp_filtered_data.csv",
    mime="text/csv"
)

# ==========================
# CLOSE CONNECTION
# ==========================

conn.close()