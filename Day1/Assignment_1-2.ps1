param (
    [Switch]$example
)
$day = $PSScriptRoot.Substring($PSScriptRoot.Length-1,1)
If ($example -eq $true) {$file = "example"} else {$file = "input" }
[int[]]$measurements = Get-content -Path "$PSScriptRoot\$($file)_$day.txt"


$result = 0
$subresult = @()
$i = 0

######
# Part 2
# Creating an array with the sum of the first three, second three etc....
######
do {
    $subresult += ($measurements[$i..($i+2)] | Measure-Object -Sum).Sum
    $i++
} while ( $i -lt ($measurements.count - 2) )

######
# Part 1
# Doing the same as assignment 1
######
$j = 1
do {
    if ($subresult[$j] -gt $subresult[$j-1]) {
        $result++
    }
    $j++
} while ( $j -lt $subresult.count )

$result

