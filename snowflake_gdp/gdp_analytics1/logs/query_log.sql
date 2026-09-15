-- created_at: 2026-09-15T15:42:26.485673900+00:00
-- finished_at: 2026-09-15T15:42:26.659159300+00:00
-- elapsed: 173ms
-- outcome: success
-- dialect: snowflake
-- node_id: not available
-- query_id: 01c7170e-000d-fcaf-0001-e4e2001c508a
-- desc: execute adapter call
show terse schemas in database GDP_ANALYTICS
    limit 10000
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:26.781082800+00:00
-- finished_at: 2026-09-15T15:42:26.936871500+00:00
-- elapsed: 155ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc51-0001-e4e2001b256e
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "GDP_ANALYTICS"."SNAPSHOTS" LIMIT 10000;
-- created_at: 2026-09-15T15:42:26.954348400+00:00
-- finished_at: 2026-09-15T15:42:27.081367300+00:00
-- elapsed: 127ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc5e-0001-e4e2001c6066
-- desc: execute adapter call
select * from (
        select country_name, continent, income_group from (
                



select distinct
    country_id,
    country_name,
    continent,
    income_group
from RAW.RAW_COUNTRIES


            ) subq
    ) as __dbt_sbq
    where false
    limit 0
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:27.093844300+00:00
-- finished_at: 2026-09-15T15:42:27.196172100+00:00
-- elapsed: 102ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc5e-0001-e4e2001c606a
-- desc: execute adapter call
describe table "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT"
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:27.219917500+00:00
-- finished_at: 2026-09-15T15:42:27.437877100+00:00
-- elapsed: 217ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc95-0001-e4e2001c40ba
-- desc: execute adapter call
describe table "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT"
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:27.452709500+00:00
-- finished_at: 2026-09-15T15:42:28.508451600+00:00
-- elapsed: 1.1s
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc8b-0001-e4e2001c34f6
-- desc: execute adapter call
create or replace temporary table "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT__dbt_tmp"
as (
    
    
    with snapshot_query as (

        



select distinct
    country_id,
    country_name,
    continent,
    income_group
from RAW.RAW_COUNTRIES



    ),

    snapshotted_data as (

        select *, 
    
        country_id as dbt_unique_key
    

        from "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT"
        where
            
                dbt_valid_to is null
            

    ),

    insertions_source_data as (

        select *, 
    
        country_id as dbt_unique_key
    
,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_updated_at,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_valid_from,
            
  
  coalesce(nullif(to_timestamp_ntz(convert_timezone('UTC', current_timestamp())), to_timestamp_ntz(convert_timezone('UTC', current_timestamp()))), null)
  as dbt_valid_to
,
            md5(coalesce(cast(country_id as varchar ), '')
         || '|' || coalesce(cast(to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as varchar ), '')
        ) as dbt_scd_id

        from snapshot_query
    ),

    updates_source_data as (

        select *, 
    
        country_id as dbt_unique_key
    
,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_updated_at,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_valid_from,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_valid_to

        from snapshot_query
    ),

    insertions as (

        select
            'insert' as dbt_change_type,
            source_data.*

        from insertions_source_data as source_data
        left outer join snapshotted_data
            on 
    
        snapshotted_data.dbt_unique_key = source_data.dbt_unique_key
    

            where 
    
        snapshotted_data.dbt_unique_key is null
    

            or (
    
        snapshotted_data.dbt_unique_key is not null
    
 and (
               (snapshotted_data."COUNTRY_NAME" != source_data."COUNTRY_NAME"
        or
        (
            ((snapshotted_data."COUNTRY_NAME" is null) and not (source_data."COUNTRY_NAME" is null))
            or
            ((not snapshotted_data."COUNTRY_NAME" is null) and (source_data."COUNTRY_NAME" is null))
        ) or snapshotted_data."CONTINENT" != source_data."CONTINENT"
        or
        (
            ((snapshotted_data."CONTINENT" is null) and not (source_data."CONTINENT" is null))
            or
            ((not snapshotted_data."CONTINENT" is null) and (source_data."CONTINENT" is null))
        ) or snapshotted_data."INCOME_GROUP" != source_data."INCOME_GROUP"
        or
        (
            ((snapshotted_data."INCOME_GROUP" is null) and not (source_data."INCOME_GROUP" is null))
            or
            ((not snapshotted_data."INCOME_GROUP" is null) and (source_data."INCOME_GROUP" is null))
        ))
            )

        )

    ),

    updates as (

        select
            'update' as dbt_change_type,
            source_data.*,
            snapshotted_data.dbt_scd_id

        from updates_source_data as source_data
        join snapshotted_data
            on 
    
        snapshotted_data.dbt_unique_key = source_data.dbt_unique_key
    

        where (
            (snapshotted_data."COUNTRY_NAME" != source_data."COUNTRY_NAME"
        or
        (
            ((snapshotted_data."COUNTRY_NAME" is null) and not (source_data."COUNTRY_NAME" is null))
            or
            ((not snapshotted_data."COUNTRY_NAME" is null) and (source_data."COUNTRY_NAME" is null))
        ) or snapshotted_data."CONTINENT" != source_data."CONTINENT"
        or
        (
            ((snapshotted_data."CONTINENT" is null) and not (source_data."CONTINENT" is null))
            or
            ((not snapshotted_data."CONTINENT" is null) and (source_data."CONTINENT" is null))
        ) or snapshotted_data."INCOME_GROUP" != source_data."INCOME_GROUP"
        or
        (
            ((snapshotted_data."INCOME_GROUP" is null) and not (source_data."INCOME_GROUP" is null))
            or
            ((not snapshotted_data."INCOME_GROUP" is null) and (source_data."INCOME_GROUP" is null))
        ))
        )
    )

    select * from insertions
    union all
    select * from updates

    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:28.515496600+00:00
-- finished_at: 2026-09-15T15:42:28.632142100+00:00
-- elapsed: 116ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc5e-0001-e4e2001c606e
-- desc: execute adapter call
describe table "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT__dbt_tmp"
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:28.636390500+00:00
-- finished_at: 2026-09-15T15:42:28.740882800+00:00
-- elapsed: 104ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc51-0001-e4e2001b2576
-- desc: execute adapter call
describe table "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT"
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:28.781120900+00:00
-- finished_at: 2026-09-15T15:42:28.904795100+00:00
-- elapsed: 123ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc8b-0001-e4e2001c34fa
-- desc: execute adapter call
describe table "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT__dbt_tmp"
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:28.908384200+00:00
-- finished_at: 2026-09-15T15:42:29.004044600+00:00
-- elapsed: 95ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc5e-0001-e4e2001c6072
-- desc: execute adapter call
describe table "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT"
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:29.009568400+00:00
-- finished_at: 2026-09-15T15:42:29.131994500+00:00
-- elapsed: 122ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc95-0001-e4e2001c40be
-- desc: execute adapter call
describe table "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT__dbt_tmp"
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:29.159571700+00:00
-- finished_at: 2026-09-15T15:42:29.397304400+00:00
-- elapsed: 237ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fc8b-0001-e4e2001c34fe
-- desc: get_column_schema_from_query adapter call
select * from (
        
    
    with snapshot_query as (

        



select distinct
    country_id,
    country_name,
    continent,
    income_group
from RAW.RAW_COUNTRIES



    ),

    snapshotted_data as (

        select *, 
    
        country_id as dbt_unique_key
    

        from "GDP_ANALYTICS"."SNAPSHOTS"."COUNTRY_SNAPSHOT"
        where
            
                dbt_valid_to is null
            

    ),

    insertions_source_data as (

        select *, 
    
        country_id as dbt_unique_key
    
,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_updated_at,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_valid_from,
            
  
  coalesce(nullif(to_timestamp_ntz(convert_timezone('UTC', current_timestamp())), to_timestamp_ntz(convert_timezone('UTC', current_timestamp()))), null)
  as dbt_valid_to
,
            md5(coalesce(cast(country_id as varchar ), '')
         || '|' || coalesce(cast(to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as varchar ), '')
        ) as dbt_scd_id

        from snapshot_query
    ),

    updates_source_data as (

        select *, 
    
        country_id as dbt_unique_key
    
,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_updated_at,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_valid_from,
            to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_valid_to

        from snapshot_query
    ),

    insertions as (

        select
            'insert' as dbt_change_type,
            source_data.*

        from insertions_source_data as source_data
        left outer join snapshotted_data
            on 
    
        snapshotted_data.dbt_unique_key = source_data.dbt_unique_key
    

            where 
    
        snapshotted_data.dbt_unique_key is null
    

            or (
    
        snapshotted_data.dbt_unique_key is not null
    
 and (
               (snapshotted_data."COUNTRY_NAME" != source_data."COUNTRY_NAME"
        or
        (
            ((snapshotted_data."COUNTRY_NAME" is null) and not (source_data."COUNTRY_NAME" is null))
            or
            ((not snapshotted_data."COUNTRY_NAME" is null) and (source_data."COUNTRY_NAME" is null))
        ) or snapshotted_data."CONTINENT" != source_data."CONTINENT"
        or
        (
            ((snapshotted_data."CONTINENT" is null) and not (source_data."CONTINENT" is null))
            or
            ((not snapshotted_data."CONTINENT" is null) and (source_data."CONTINENT" is null))
        ) or snapshotted_data."INCOME_GROUP" != source_data."INCOME_GROUP"
        or
        (
            ((snapshotted_data."INCOME_GROUP" is null) and not (source_data."INCOME_GROUP" is null))
            or
            ((not snapshotted_data."INCOME_GROUP" is null) and (source_data."INCOME_GROUP" is null))
        ))
            )

        )

    ),

    updates as (

        select
            'update' as dbt_change_type,
            source_data.*,
            snapshotted_data.dbt_scd_id

        from updates_source_data as source_data
        join snapshotted_data
            on 
    
        snapshotted_data.dbt_unique_key = source_data.dbt_unique_key
    

        where (
            (snapshotted_data."COUNTRY_NAME" != source_data."COUNTRY_NAME"
        or
        (
            ((snapshotted_data."COUNTRY_NAME" is null) and not (source_data."COUNTRY_NAME" is null))
            or
            ((not snapshotted_data."COUNTRY_NAME" is null) and (source_data."COUNTRY_NAME" is null))
        ) or snapshotted_data."CONTINENT" != source_data."CONTINENT"
        or
        (
            ((snapshotted_data."CONTINENT" is null) and not (source_data."CONTINENT" is null))
            or
            ((not snapshotted_data."CONTINENT" is null) and (source_data."CONTINENT" is null))
        ) or snapshotted_data."INCOME_GROUP" != source_data."INCOME_GROUP"
        or
        (
            ((snapshotted_data."INCOME_GROUP" is null) and not (source_data."INCOME_GROUP" is null))
            or
            ((not snapshotted_data."INCOME_GROUP" is null) and (source_data."INCOME_GROUP" is null))
        ))
        )
    )

    select * from insertions
    union all
    select * from updates

    ) as __dbt_sbq
    where false
    limit 0
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
-- created_at: 2026-09-15T15:42:29.405820100+00:00
-- finished_at: 2026-09-15T15:42:29.515595400+00:00
-- elapsed: 109ms
-- outcome: success
-- dialect: snowflake
-- node_id: snapshot.gdp_analytics.country_snapshot
-- query_id: 01c7170e-000d-fcaf-0001-e4e2001c5092
-- desc: get_column_schema_from_query adapter call
select * from (
        select to_timestamp_ntz(convert_timezone('UTC', current_timestamp())) as dbt_snapshot_time
    ) as __dbt_sbq
    where false
    limit 0
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "snapshot.gdp_analytics.country_snapshot", "profile_name": "gdp_analytics", "target_name": "dev"} */;
