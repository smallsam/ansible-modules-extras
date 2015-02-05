#!powershell
# This file is part of Ansible
#
# Copyright 2014, Sam Richards
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

# WANT_JSON
# POWERSHELL_COMMON

########

import-module WebAdministration

$iis = "IIS://$env:COMPUTERNAME"

########

$params = Parse-Args $args;

$result = New-Object psobject @{
    changed = $false
};

If (-not $params.name.GetType) {
    Fail-Json $result "missing required arguments: name"
}

$name = Get-Attr $params "name"
$port = (Get-Attr $params "port") -as [INT]
$ipaddress = Get-Attr $params "ipaddress" '*'
$hostheader = Get-Attr $params "hostheader"
$physical_path = Get-Attr $params "physical_path"
$application_pool = Get-Attr $params "application_pool"

If ($params.state) {
    $state = $params.state.ToString().ToLower()
    If (($state -ne 'present') -and ($state -ne 'absent') -and ($state -ne 'query') -and ($state -ne 'started') -and ($state -ne 'stopped') -and ($state -ne 'disabled') -and ($state -ne 'enabled')) {
        Fail-Json $result "state is '$state'; must be 'present', 'absent' or 'query' or 'started' or 'stopped' or 'disabled' or 'enabled'"
    }
}
ElseIf (!$params.state) {
    $state = "present"
}

$ssl_enabled = Get-Attr $params "ssl"
If ($ssl_enabled -ne $null) {
    $ssl_enabled = $ssl_enabled | ConvertTo-Bool
}

$autostart = Get-Attr $params "autostart" "yes"

# Get-Website is broken on 2008


$website_obj = Get-Item "IIS:\Sites\$name" -ErrorAction SilentlyContinue


If ($state -eq 'present') {
    # Add website
    try {
        If (!$website_obj.GetType) {
            $website_obj = New-WebSite -Name $name -Port $port -IPAddress $ipaddress -HostHeader $hostheader -PhysicalPath $physical_path -Ssl:$ssl_enabled -ApplicationPool $application_pool
            $result.changed = $true
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}
ElseIf ($state -eq 'absent') {
    # Remove website
    try {
        If ($website_obj.GetType) {
            Remove-Website -Name $name
            $result.changed = $true
            $website_obj = $null
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}
ElseIf ($state -eq 'started') {
    # Start website
    try {
        If ($website_obj.GetType) {
            if ($website_obj.State -ne "Started") {
                Start-Website -Name $name
                $result.changed = $true
            }
            Else {
                $result.msg = 'Already Started'
            }
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}
ElseIf ($state -eq 'stopped') {
    # Stop website
    try {
        If ($website_obj.GetType) {
            If ($website_obj.State -ne "Stopped") {
                Stop-Website -Name $name
                $result.changed = $true
            }
            Else {
                $result.msg = 'Already Stopped'
            }
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}
ElseIf ($state -eq 'disabled') {
    # Disable Web site
    try {
        If ($website_obj.GetType) {
            If ((Get-ItemProperty "IIS:\Sites\$name" serverAutoStart).value) {
                Set-ItemProperty "IIS:\Sites\$name" serverAutoStart $false
                $result.changed = $true
            }
            Else {
                $result.msg = 'Already Disabled'
            }
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}
ElseIf ($state -eq 'enabled') {
    # Enable Web site
    try {
        If ($website_obj.GetType) {
            If ((Get-ItemProperty "IIS:\Sites\$name" serverAutoStart).value) {
                $result.msg = 'Already Enabled'
            }
            Else {
                Set-ItemProperty "IIS:\Sites\$name" serverAutoStart $true
                $result.changed = $true
                
            }
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}

$website_obj = Get-Item "IIS:\Sites\$name" -ErrorAction SilentlyContinue

try {
    If ($website_obj.GetType) {
        Set-Attr $result "name" $website_obj.Name
        Set-Attr $result "id" $website_obj.Id
        Set-Attr $result "state" $website_obj.State.ToLower()
        Set-Attr $result "physicalpath" $website_obj.PhysicalPath
    }
    Else {
        Set-Attr $result "name" $name
        Set-Attr $result "msg" "Website '$name' was not found"
        Set-Attr $result "state" "absent"
    }
}
catch {
    Fail-Json $result $_.Exception.Message
}

Exit-Json $result