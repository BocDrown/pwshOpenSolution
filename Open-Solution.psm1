function Open-Solution {
param(
<#
.SYNOPSIS

Opens the Visual Studio solution file in the current or any underlying folder. Presents selection in case of multiple solution files.

.DESCRIPTION

The Open-Solution function recursively searches for a Visual Studio solution file and opens it. If multiple solution files are found the user has to choose which file to open.
#>    
[Parameter(Mandatory=$true)]
    [string] $callingPath
    )

    # Get all sln files below the callingPath recursively
    $solutions = Get-ChildItem -Recurse -Path $callingPath\*.sln
    
    # No sln files found
    if ($solutions.Length -lt 1) {
        Write-Output "No solutions found in $callingPath"
        return
    }
    # Multiple sln files found
    elseif ($solutions.Length -gt 1) {
        $counter = 0

        # Prompt user with choice
        Write-Output "Multiple solutions found. Please select solution to open:"
        $solutions | ForEach-Object { 
            Write-Output "$((++$counter)): $($_.FullName.Replace($callingPath,''))"
        }
        
        # Read user input
        $userInput = Read-Host "Select a solution by number or return to quit"
        if($userInput -eq "") {
            return
        }
        else {
            $userIdx = $userInput -as [int]
        }
        
        # Invoke user selection
        if ( ($userIdx -ne "") -and ($userIdx -ge 1) -and ($userIdx -le $solutions.Length) ) {
             $userSelection = $solutions | Select-Object -Index ($userIdx-1)
             & $userSelection.FullName
        }
    }
    # Easy solution, only one sln file found
    else {
        & $solutions.FullName
    }
}

Export-ModuleMember -Function Open-Solution