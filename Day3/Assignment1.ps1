$diagnostics = Get-Content input.txt

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
} while ( $i -lt 12)
$gamma

$epsilon = ""
$i = 0

do {
    If ($gamma[$i] -eq "1") {
        $epsilon += "0"
    } else {
        $epsilon += "1"
    }
    $i++
} while ($i -lt $gamma.Length)

$gammaInt = $([convert]::ToInt32($gamma,2))
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
