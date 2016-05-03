{%- from tpldir + "/map.jinja" import name_computer with context %}

{%- if name_computer %}
Set Computer Name:
  {{ name_computer.state_name }}:
    {{ name_computer.state_opts }}
{%- endif %}
