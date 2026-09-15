# 🌍 GDP Analytics Data Engineering Project

## 📌 Project Overview

The GDP Analytics Project is an end-to-end Data Engineering solution built using Snowflake, dbt, and Streamlit.

The project ingests GDP-related datasets from multiple sources, transforms them into a dimensional data model, creates analytical views, tracks historical changes using dbt snapshots, and provides interactive visualizations through a Streamlit dashboard.

---

## 🎯 Business Objective

To provide a centralized analytics platform for GDP-related indicators across multiple countries and years, enabling users to:

- Analyze GDP trends
- Compare countries
- Track economic indicators
- Generate analytical insights
- Visualize GDP growth patterns

---

## 🏗️ Architecture

Source Files (CSV)
↓
RAW Layer
↓
DW Layer (Dimensions + Fact)
↓
dbt Models
↓
dbt Tests
↓
dbt Snapshots (SCD Type 2)
↓
Semantic Views
↓
Streamlit Dashboard

---

## 🛠️ Technologies Used

### Data Warehouse
- Snowflake

### Data Transformation
- dbt (Data Build Tool)

### Programming Language
- Python

### Visualization
- Streamlit
- Plotly

### Source Data
- CSV Files

### Version Control
- Git
- GitHub

---

## 📂 Project Structure

```text
gdp_analytics/
│
├── models/
├── snapshots/
│   └── country_snapshot.sql
│
├── tests/
├── macros/
│
├── sql/
│   ├── 01_create_schemas.sql
│   ├── 02_create_tables.sql
│   ├── 03_load_data.sql
│   ├── 04_dimensions.sql
│   ├── 05_fact_table.sql
│   ├── 06_data_validation.sql
│   └── 07_semantic_views.sql
│
├── streamlit_app.py
├── config.py
├── dbt_project.yml
├── packages.yml
├── requirements.txt
└── README.md
```

---

## 📊 Source Datasets

The project uses GDP-related datasets containing:

### Country Data
- Country Name
- Country Code
- Region / Continent

### Indicator Data
- Indicator Name
- Indicator Code

### Economic Observations
- Country
- Indicator
- Year
- Value

---

## 🗄️ Snowflake Data Model

### RAW Schema

Stores source data exactly as received.

Tables:

- RAW_COUNTRY
- RAW_INDICATOR
- RAW_OBSERVATIONS

---

### DW Schema

Dimensional model following Star Schema design.

#### Dimension Tables

##### DIM_COUNTRY

Stores country information.

Columns:

- SK_COUNTRY
- COUNTRY_NAME
- COUNTRY_CODE
- CONTINENT

---

##### DIM_INDICATOR

Stores indicator details.

Columns:

- SK_INDICATOR
- INDICATOR_NAME
- INDICATOR_CODE

---

##### DIM_DATE

Stores year information.

Columns:

- SK_DATE
- YEAR

---

#### Fact Table

##### FACT_ECON_OBSERVATION

Stores GDP measurements.

Columns:

- SK_COUNTRY
- SK_INDICATOR
- SK_DATE
- VALUE

---

## 🔄 dbt Implementation

### dbt Models

Used for transforming RAW data into analytical structures.

Commands used:

```bash
dbt debug
dbt run
dbt test
```

### dbt Tests

Implemented tests:

- Unique Key Test
- Not Null Test
- Relationship Test

Command:

```bash
dbt test
```

---

## 📸 dbt Snapshot

Implemented Slowly Changing Dimension (SCD Type 2) using snapshots.

Snapshot File:

```text
snapshots/country_snapshot.sql
```

Command:

```bash
dbt snapshot
```

Purpose:

- Track historical changes
- Maintain version history
- Preserve old records

---

## 📈 Semantic Views

### V_GDP_COUNTRY_YEAR

Provides GDP data by country and year.

---

### V_REGION_TRENDS

Provides continent-wise GDP trends.

---

### V_GDP_GROWTH

Calculates GDP growth using window functions.

---

## 📋 Data Validation

Validation checks performed:

### Record Count Validation

```sql
SELECT COUNT(*)
FROM RAW.RAW_OBSERVATIONS;
```

```sql
SELECT COUNT(*)
FROM DW.FACT_ECON_OBSERVATION;
```

### Year Validation

```sql
SELECT
MIN(YEAR),
MAX(YEAR)
FROM RAW.RAW_OBSERVATIONS;
```

### Country Validation

```sql
SELECT
COUNTRY_NAME,
COUNT(*)
FROM SEM.V_GDP_COUNTRY_YEAR
GROUP BY COUNTRY_NAME;
```

---

## 📊 Streamlit Dashboard

The dashboard provides:

### KPI Cards

- Total Countries
- Total Indicators
- Total Records
- Latest Year
- Maximum GDP
- Average GDP

### Interactive Filters

- Country Filter
- Indicator Filter

### Visualizations

#### GDP Trend Chart

Shows GDP changes over time.

#### GDP by Country

Country-wise GDP comparison.

#### Country Comparison Trend

Compare multiple countries across years.

#### Top Countries Ranking

Highest GDP countries.

#### GDP Share Pie Chart

Country contribution analysis.

#### GDP Distribution Histogram

Distribution of GDP values.

#### Average GDP by Indicator

Indicator-wise analysis.

#### Correlation Heatmap

Indicator relationship analysis.

#### Data Preview

Filtered data display.

#### Download CSV

Export filtered results.

---

## ▶️ How to Run

### Step 1

Clone repository

```bash
git clone <repository_url>
```

### Step 2

Navigate to project

```bash
cd gdp_analytics
```

### Step 3

Install dependencies

```bash
pip install -r requirements.txt
```

### Step 4

Validate dbt connection

```bash
dbt debug
```

### Step 5

Run dbt models

```bash
dbt run
```

### Step 6

Run tests

```bash
dbt test
```

### Step 7

Run snapshots

```bash
dbt snapshot
```

### Step 8

Generate documentation

```bash
dbt docs generate
```

### Step 9

Launch dashboard

```bash
streamlit run streamlit_app.py
```

---

## ✅ Project Outcomes

- Built an end-to-end Data Engineering pipeline.
- Implemented Snowflake Data Warehouse.
- Designed Star Schema architecture.
- Developed dbt transformation models.
- Implemented SCD Type 2 snapshots.
- Created semantic reporting views.
- Built an interactive Streamlit dashboard.
- Enabled analytical reporting and GDP trend analysis.

---

## 👨‍💻 Author

**Manasa Pamisetty**

B.Tech Computer Science & Engineering

Data Engineering | Data Analytics | AI/ML Enthusiast
