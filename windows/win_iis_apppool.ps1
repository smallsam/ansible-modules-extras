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

If ($params.state) {
    $state = $params.state.ToString().ToLower()
    If (($state -ne 'present') -and ($state -ne 'absent') -and ($state -ne 'query') -and ($state -ne 'started') -and ($state -ne 'stopped') -and ($state -ne 'restarted') -and ($state -ne 'disabled') -and ($state -ne 'enabled')) {
        Fail-Json $result "state is '$state'; must be 'present', 'absent', 'query', 'started', 'stopped', 'restarted', 'enabled' or 'disabled'"
    }
}
ElseIf (!$params.state) {
    $state = "present"
}

$webapppool_state_obj = Get-WebAppPoolState -Name $name

If ($state -eq 'present') {
    # Add app pool
    try {
        If (!$webapppool_state_obj.GetType) {
            New-WebAppPool -Name $name
            $result.changed = $true
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}
ElseIf ($state -eq 'absent') {
    # Remove App Pool
    try {
        If ($webapppool_state_obj.GetType) {
            Remove-WebAppPool -Name $name
            $result.changed = $true
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}
ElseIf ($state -eq 'started') {
    # Start App Pool
    try {
        If ($webapppool_state_obj.GetType) {
            if ($webapppool_state_obj.State -ne "Started") {
                Start-WebAppPool -Name $name
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
    # Stop App Pool
    try {
        If ($webapppool_state_obj.GetType) {
            If ($webapppool_state_obj.State -ne "Stopped") {
                Stop-WebAppPool -Name $name
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
ElseIf ($state -eq 'restarted') {
    # Recycle App Pool
    try {
        If ($webapppool_state_obj.GetType) {
            Restart-WebAppPool -Name $name
            $result.changed = $true
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}
ElseIf ($state -eq 'disabled') {
    # Disable App Pool
    try {
        If ($webapppool_state_obj.GetType) {
            If ((Get-ItemProperty "IIS:\AppPools\$name" autoStart).value) {
                Set-ItemProperty "IIS:\AppPools\$name" autoStart $false
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
    # Enable App Pool
    try {
        If ($webapppool_state_obj.GetType) {
            If ((Get-ItemProperty "IIS:\AppPools\$name" autoStart).value) {
                $result.msg = 'Already Enabled'
            }
            Else {
                Set-ItemProperty "IIS:\AppPools\$name" autoStart $true
                $result.changed = $true
                
            }
        }
    }
    catch {
        Fail-Json $result $_.Exception.Message
    }
}

If ($state -ne 'absent') {
    $webapppool_state_obj = Get-WebAppPoolState -Name $name
}

try {
    If ($state -eq 'absent') {
        Set-Attr $result "name" $name
        Set-Attr $result "state" "absent"
    }
    ElseIf ($webapppool_state_obj.GetType) {
        Set-Attr $result "name" $name
        Set-Attr $result "state" $webapppool_state_obj.value.ToLower()
    }
    Else {
        Set-Attr $result "name" $name
        Set-Attr $result "msg" "App Pool '$name' was not found"
        Set-Attr $result "state" "absent"
    }
}
catch {
    Fail-Json $result $_.Exception.Message
}

Exit-Json $result
