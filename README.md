Role Name
=========

Installs Ferm Firewall management and configures rules. (http://ferm.foo-projects.org/)

Requirements
------------

Define rules for each chain if desired...Custom chains can be added as the example ALLOWED-LOGGING...each rule needs a weight  
assigned to each rule. The weight defines the filename and dictates the loading order of rules.. weight=000 is highest and loads first  
a weight=999 would be the lowest priority and loads last.

Role Variables
--------------

````
---
# defaults file for ansible-ferm
ferm_custom_chains:
  - chain: ALLOWED-LOGGING
  - chain: ALLOWED-NO-LOGGING
ferm_table_filters:
  - chain: ALLOWED-LOGGING
    logging: true
    logging_prefix: IPTables-Allowed
    rules:
      - name: allow_any_any
        proto: any
        dport: any
        target: ACCEPT
        weight: '500'
  - chain: FORWARD
    policy: DROP
    connection_tracking:
      - state: INVALID
        policy: DROP
      - state: ESTABLISHED
        policy: ACCEPT
      - state: RELATED
        policy: ACCEPT
    rules: []
  - chain: INPUT  #define rules to be applied in-bound...name's should be unique (files generated by weight/name)
    policy: DROP
    allow_local_connections: true  #defines if local loopback connections should be allowed.
    connection_tracking:
      - state: INVALID
        policy: DROP
      - state: ESTABLISHED
        policy: ACCEPT
      - state: RELATED
        policy: ACCEPT
    rules:
      - name: allow_http_in
        proto: tcp
        dport: 80
        target: ACCEPT
        jump: ALLOWED-LOGGING
        weight: '500'
      - name: allow_https_in
        proto: tcp
        dport: 443
        target: ACCEPT
        jump: ALLOWED-LOGGING
        weight: '500'
      - name: allow_ipsec_in
        proto: udp
        dport: 500
        target: ACCEPT
        weight: '500'
      - name: allow_ipsec_in
        proto: esp
        target: ACCEPT
        weight: '500'
      - name: allow_ipsec_in
        proto: ah
        target: ACCEPT
        weight: '500'
      - name: allow_ping_in
        proto: icmp
        source: 0.0.0.0/0
        destination: 0.0.0.0/0
        target: ACCEPT
        weight: '500'  #defines the default rule weight for rules that do not specify it. (000=highest,999=lowest)
      - name: allow_ssh_in
        proto: tcp
        source: 0.0.0.0/0
        destination: 0.0.0.0/0
        dport: 22
        target: ACCEPT
        jump: ALLOWED-LOGGING  #defines a jump rule to set as target...defined in ferm_custom_chains
        weight: '500'
  - chain: OUTPUT
    policy: ACCEPT
    connection_tracking:
      - state: INVALID
        policy: DROP
      - state: ESTABLISHED
        policy: ACCEPT
      - state: RELATED
        policy: ACCEPT
    rules: []
````

Dependencies
------------

None

Example Playbook
----------------

#### GitHub
````
---
- name: configures ferm firewall services
  hosts: all
  become: true
  vars:
  roles:
    - role: ansible-ferm
  tasks:
````
#### Galaxy
````
---
- name: configures ferm firewall services
  hosts: all
  become: true
  vars:
  roles:
    - role: mrlesmithjr.ferm
  tasks:
````

License
-------

BSD

Author Information
------------------

Larry Smith Jr.
- @mrlesmithjr
- http://everythingshouldbevirtual.com
- mrlesmithjr [at] gmail.com
