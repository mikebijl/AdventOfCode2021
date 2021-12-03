param (
    [Switch]$example
)
$day = $PSScriptRoot.Substring($PSScriptRoot.Length-1,1)
If ($example -eq $true) {$file = "example"} else {$file = "input" }
$diagnostics = Get-Content "$PSScriptRoot\$($file)_$day.txt"

$i = 0
$oxygen = $diagnostics
do {
    $stats = $oxygen.Substring($i,1) | Measure-Object -AllStats

    # Oxygen generator rating
    If ($stats.Sum -ge ($stats.count / 2)) {
        $oxygen = $oxygen | Where-Object {$_.Substring($i,1) -eq "1"}
    } elseif ($stats.Sum -lt ($stats.count / 2)) {
        $oxygen = $oxygen | Where-Object {$_.Substring($i,1) -eq "0"}
    } else {
        write-error "fout $stats"
    }

    $i++
} while ( $i -lt $diagnostics[0].Length -and ($oxygen.count -gt 1))

$i = 0
$co2 = $diagnostics
do {
    $stats = $co2.Substring($i,1) | Measure-Object -AllStats

    # CO2 scrubber rating
    If ($stats.Sum -lt ($stats.count / 2)) {
        $co2 = $co2 | Where-Object {$_.Substring($i,1) -eq "1"}
    } elseif ($stats.Sum -ge ($stats.count / 2)) {
        $co2 = $co2 | Where-Object {$_.Substring($i,1) -eq "0"}
    } else {
        write-error "fout $stats"
    }

    $i++
} while ( ($i -lt $diagnostics[0].Length) -and ($co2.count -gt 1))

$oxygenInt = $([convert]::ToInt32($oxygen,2))
$co2Int = $([convert]::ToInt32($co2,2))
# $epsilon = [convert]::ToString($(-bnot $gammaInt),2) | ForEach-Object {$_.Substring($($_.Length - $gamma.Length ),($gamma.Length))}
# $epsilonInt = $([convert]::ToInt32($epsilon,2))

Write-host "Binary string oxygen:`t" -NoNewline -ForegroundColor Cyan
Write-host $oxygen -ForegroundColor Magenta
Write-host "Integer string oxygen:`t" -NoNewline -ForegroundColor Cyan
Write-host $oxygenInt -ForegroundColor Magenta

Write-host "Binary string co2:`t" -NoNewline -ForegroundColor Cyan
Write-host $co2 -ForegroundColor Magenta
Write-host "Integer string co2:`t" -NoNewline -ForegroundColor Cyan
Write-host $co2Int -ForegroundColor Magenta

Write-host "Answer:`t" -NoNewline -ForegroundColor Cyan
Write-host "$($oxygenInt * $co2Int)"  -ForegroundColor Magenta
