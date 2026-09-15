select
    row_number() over(order by indicator_id) as sk_indicator,
    indicator_id,
    indicator_code,
    indicator_name,
    unit,
    frequency,
    description,
    source_system,
    status
from {{ ref('stg_indicators') }}