param (
    [Switch]$example
)
$day = $PSScriptRoot.Substring($PSScriptRoot.Length-1,1)
If ($example -eq $true) {$file = "example"} else {$file = "input" }
[int[]]$measurements = Get-content -Path "$PSScriptRoot\$($file)_$day.txt"

$answer = 0

$i = 1
do {
    if ($measurements[$i] -gt $measurements[$i-1]) {
        $answer++
    }
    $i++
} while ( $i -lt $measurements.count )

$answer