select
    row_number() over(order by country_id) as sk_country,
    country_id,
    country_name,
    continent,
    income_group,
    true as is_current
from (

    select distinct
        country_id,
        country_name,
        continent,
        income_group
    from {{ ref('stg_countries') }}

)