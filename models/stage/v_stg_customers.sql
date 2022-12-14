{%- set yaml_metadata -%}
source_model: 'v_raw_customers'
derived_columns:
  CUSTOMER_KEY: 'CUSTOMER_NUMBER'
  RECORD_SOURCE: '!SALESFORCE'
  EFFECTIVE_FROM: 'LASTMODIFIEDDATE'
hashed_columns:
  CUSTOMER_HK: 'CUSTOMER_KEY'
  CUSTOMER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'CUSTOMER_NUMBER'
      - 'CUSTOMER_ID'
      - 'FIRST_NAME'
      - 'LAST_NAME'
      - 'CRUD_FLAG'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict['source_model'] %}

{% set derived_columns = metadata_dict['derived_columns'] %}

{% set hashed_columns = metadata_dict['hashed_columns'] %}

WITH staging AS (
{{ dbtvault.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=none) }}
)

SELECT *,
       '{{ var('load_date') }}' AS LOAD_DATE
FROM staging
