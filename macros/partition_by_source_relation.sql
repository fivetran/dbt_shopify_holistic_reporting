{%- macro partition_by_source_relation(has_other_partitions='yes', alias=None, source='shopify') -%}
{{ adapter.dispatch('partition_by_source_relation', 'shopify_holistic_reporting') (has_other_partitions, alias, source) }}
{%- endmacro %}

{% macro default__partition_by_source_relation(has_other_partitions='yes', alias=None, source='shopify') -%}
    {% set prefix = '' if alias is none else alias ~ '.' %}

    {# Prioritizes union_schemas -> union_databases -> [] #}
    {%- if source == 'shopify' -%}
        {% set union_variable = var('shopify_union_schemas', var('shopify_union_databases', [])) %}
    {%- elif source == 'klaviyo' -%}
        {% set union_variable = var('klaviyo_union_schemas', var('klaviyo_union_databases', [])) %}
    {%- else -%}
        {% set union_variable = [] %}
    {%- endif -%}

    {%- if has_other_partitions == 'no' -%}
        {{ 'partition by ' ~ prefix ~ 'source_relation' if union_variable|length > 1 }}
    {%- else -%}
        {{ ', ' ~ prefix ~ 'source_relation' if union_variable|length > 1 }}
    {%- endif -%}
{%- endmacro -%}
