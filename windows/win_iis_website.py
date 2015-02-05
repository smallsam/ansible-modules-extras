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
module: win_iis_site
short_description: Manages IIS Websites
description:
     - Manages IIS Websites
options:
  name:
    description:
      - Name of the site to create, remove or modify.
    required: true
  port:
    required: false
    description:
      - The port to use for the site
  ipaddress:
    required: false
    description:
      - The IP address of the site
  hostheader:
    required: false
    description:
      - The host header to use for the site
  physical_path:
    required: false
    description:
      - The physical path to use for the site. The specified folder must already exist.
  application_pool:
    required: false
    description:
      - The application pool for the site
  ssl:
    required: false
    description:
      - Enable SSL binding for the site
    default: no
    choices: [ "yes", "no" ]
  state:
    description:
      - When C(present), creates the site.  When C(absent),
        removes the website if it exists.  When C(query),
        retrieves the website details without making any changes.
        When C(started), if site exists and is stopped it will start website.
        When C(stopped), if site exists and is started it will stop website.
        When C(enabled), if site exists, it will enable serverAutoStart on website
        When C(disabled), if site exists, it will disable serverAutoStart on website
    required: false
    choices:
      - present
      - absent
      - query
      - started
      - stopped
      - enabled
      - disabled
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
$ ansible -i hosts -m win_iis_website -a "name=test1 port=888 hostheader=testing.example.com physical_path=c:\testing application_pool=test"
'''
