{%- from tpldir + "/map.jinja" import name_computer with context %}
{%- from tpldir + "/map.jinja" import ddns with context %}

{%- for state_name, state in name_computer.items() %}
{{ state_name }}: {{ state | json }}
{%- else %}
Print name-computer help:
  test.show_notification:
    - text: |
        The name-computer formula reads the computername from these keys:

          grain: `name-computer:computername`
          pillar: `name-computer:lookup:computername`

        The grain overrides the pillar key. However, neither of these keys
        are set, or they otherwise evaluate to False, so the formula did not
        attempt to set the computername.
{%- endfor %}

{%- if ddns %}
Install dnspython:
  pip.installed:
    - name: dnspython
    - reload_modules: True

Create DNS forward record:
  ddns.present:
    - data: {{ ddns.ip_address }}
    - name: {{ ddns.host_name }}.{{ ddns.host_zone }}.
    - nameserver: {{ ddns.nameserver }}
    - rdtype: A
    - replace: True
    - require:
      - pip: Install dnspython
    - ttl: 7200
    - zone: {{ ddns.host_zone }}

Create DNS reverse record:
  ddns.present:
    - data: {{ ddns.host_name }}.{{ ddns.host_zone }}.
    - name: {{ ddns.reverse_ip_address }}.in-addr.arpa.
    - nameserver: {{ ddns.nameserver }}
    - rdtype: PTR
    - replace: True
    - require:
      - pip: Install dnspython
    - ttl: 7200
    - zone: {{ ddns.reverse_ip_zone }}.in-addr.arpa.
{%- endif %}
