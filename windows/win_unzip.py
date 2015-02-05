#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2015, Sam Richards 
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name


DOCUMENTATION = '''
---
module: win_unzip
short_description: Extracts zip files
description:
     - Extracts zip files
options:
  src:
    required: true
    description:
      - zip file to extract
  dest:
    required: true
    description:
      - destination folder
author: Sam Richards
'''

EXAMPLES = '''
# Ad-hoc example
$ ansible -i hosts -m win_user -a "name=bob password=Password12345 groups=Users" all
$ ansible -i hosts -m win_user -a "name=bob state=absent" all

# Playbook example
---
- name: Add a user
  hosts: all
  gather_facts: false
  tasks:
    - name: Add User
      win_user:
        name: ansible
        password: "@ns1bl3"
        groups: ["Users"]
'''
