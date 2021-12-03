param (
    [Switch]$example
)
$day = $PSScriptRoot.Substring($PSScriptRoot.Length - 1, 1)
If ($example -eq $true) { $file = "example" } else { $file = "input" }
$diagnostics = Get-Content "$PSScriptRoot\$($file)_$day.txt"

$i = 0

$oxygen = $diagnostics
$co2 = $diagnostics
do {

    # Oxygen generator rating
    $oxygenstats = $oxygen.Substring($i, 1) | Measure-Object -AllStats
    If ($oxygen.count -gt 1) {
        If ($oxygenstats.Average -ge 0.5) {
            $oxygen = $oxygen | Where-Object { $_.Substring($i, 1) -eq "1" }
        }
        else {
            $oxygen = $oxygen | Where-Object { $_.Substring($i, 1) -eq "0" }
        }
    }
    # CO2 generator rating
    $co2stats = $co2.Substring($i, 1) | Measure-Object -AllStats
    If ($co2.count -gt 1) {
        If ($co2stats.Average -ge 0.5) {
            $co2 = $co2 | Where-Object { $_.Substring($i, 1) -eq "0" }
        }
        else {
            $co2 = $co2 | Where-Object { $_.Substring($i, 1) -eq "1" }
        }
    }

    $i++
} while ( $i -lt $diagnostics[0].Length -and (-not(($oxygen.count -eq 1) -and ($co2.count -eq 1))))

$oxygenInt = $([convert]::ToInt32($oxygen, 2))
$co2Int = $([convert]::ToInt32($co2, 2))
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
Write-host "$($oxygenInt * $co2Int)" -ForegroundColor Magenta
