param (
    [Switch]$example
)
$day = $PSScriptRoot.Substring($PSScriptRoot.Length-1,1)
If ($example -eq $true) {$file = "example"} else {$file = "input" }
$diagnostics = Get-Content "$PSScriptRoot\$($file)_$day.txt"

$i = 0
$gamma = ""
do {
    $stats = $diagnostics.Substring($i,1) | Measure-Object -AllStats
    If ($stats.Sum -gt ($stats.count / 2)) {
        $gamma += "1"
    } elseif ($stats.Sum -lt ($stats.count / 2)) {
        $gamma += "0"
    } else {
        write-error "fout $stats"
    }

    $i++
} while ( $i -lt $diagnostics[0].Length)

$gammaInt = $([convert]::ToInt32($gamma,2))
$epsilon = [convert]::ToString($(-bnot $gammaInt),2) | ForEach-Object {$_.Substring($($_.Length - $gamma.Length ),($gamma.Length))}
$epsilonInt = $([convert]::ToInt32($epsilon,2))

Write-host "Binary string gamma:`t" -NoNewline -ForegroundColor Cyan
Write-host $gamma -ForegroundColor Magenta
Write-host "Integer string gamma:`t" -NoNewline -ForegroundColor Cyan
Write-host $gammaInt -ForegroundColor Magenta

Write-host "Binary string epsilon:`t" -NoNewline -ForegroundColor Cyan
Write-host $epsilon -ForegroundColor Magenta
Write-host "Integer string epsilon:`t" -NoNewline -ForegroundColor Cyan
Write-host $epsilonInt -ForegroundColor Magenta

Write-host "Answer:`t" -NoNewline -ForegroundColor Cyan
Write-host "$($epsilonInt * $gammaInt)"  -ForegroundColor Magenta
