select
    row_number() over(order by year) as sk_date,
    year
from (
    select distinct year
    from {{ ref('stg_observations') }}
)