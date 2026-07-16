{# DuckDB-compatible json_parse override.
   DuckDB's json_extract_path_text only accepts 2 arguments (column + single path),
   so we use json_extract_string with a JSONPath expression instead. #}
{% macro duckdb__json_parse(string, string_path) %}

  json_extract_string({{ string }}, '${%- for s in string_path -%}{% if s is number %}[{{ s }}]{% else %}.{{ s }}{% endif %}{%- endfor -%}')

{% endmacro %}
