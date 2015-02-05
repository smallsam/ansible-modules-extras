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
module: win_iis_apppool
short_description: Manages IIS Application Pools
description:
     - Manages IIS Application Pools
options:
  name:
    description:
      - Name of the application pool to create, remove or modify
    required: true
  state:
    description:
      - When C(present), creates the application pool.  When C(absent),
        removes the application pool if it exists.  When C(query),
        retrieves the application pool details without making any changes.
        When C(started), if app pool exists and is stopped it will start it.
        When C(stopped), if app pool exists and is started it will stop it.
        When C(restarted), if app pool exists, it will recycle it
        When C(enabled), if app pool exists, it will enable autoStart on it
        When C(disabled), if app pool exists, it will disable autoStart on it
    required: false
    choices:
      - present
      - absent
      - query
      - started
      - stopped
      - restarted
      - disabled
      - enabled
    default: present
  autostart:
    required: false
    description:
      - Enable autostart for website
    default: yes
    choices: [ "yes", "no" ]
author: Sam Richards
'''

EXAMPLES = '''
# Ad-hoc example
$ ansible -i hosts -m win_iis_apppool -a "name=test state=restarted"

'''
