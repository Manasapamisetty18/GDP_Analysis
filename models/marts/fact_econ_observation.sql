select
    c.sk_country,
    i.sk_indicator,
    d.sk_date,
    o.value,
    o.source_system,
    o.vintage_date
from {{ ref('stg_observations') }} o
join {{ ref('dim_country') }} c
    on o.country_id = c.country_id
join {{ ref('dim_indicator') }} i
    on o.indicator_id = i.indicator_id
join {{ ref('dim_date') }} d
    on o.year = d.year