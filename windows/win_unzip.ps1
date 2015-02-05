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



#Load the assembly
#This requires .NET 4.5 but to get here (with ansible) we require Powershell 4.0 which also requires .NET 4.5
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null

########

$params = Parse-Args $args;

$result = New-Object psobject @{
    changed = $false
};

If (-not $params.src.GetType -or -not $params.dest.GetType) {
    Fail-Json $result "missing required arguments: src, dest"
}

$src = Get-Attr $params "src"
$dest = Get-Attr $params "dest"


try {
    
    #Unzip the file
    [System.IO.Compression.ZipFile]::ExtractToDirectory($src, $dest)
    $result.changed = $true
    
}
catch {
    Fail-Json $result $_.Exception.Message
}

Exit-Json $result
