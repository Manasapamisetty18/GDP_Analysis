{% snapshot country_snapshot %}

{{
    config(
      target_database='GDP_ANALYTICS',
      target_schema='SNAPSHOTS',
      unique_key='country_id',
      strategy='check',
      check_cols=[
          'country_name',
          'continent',
          'income_group'
      ]
    )
}}

select distinct
    country_id,
    country_name,
    continent,
    income_group
from RAW.RAW_COUNTRIES

{% endsnapshot %}