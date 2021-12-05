param (
    [Switch]$example
)

begin {
    If ($example -eq $true) { $file = "example" } else { $file = "input" }
    try { $content = Get-Content "$PSScriptRoot\$($file).txt" -ErrorAction Stop }
    catch { $content = Get-Content "$($file).txt" }

    $content = $content -replace '\s+', '' -replace '^\s', '' -replace '\s$', ''

    $lines = @()
    ForEach ($item in $content) {
        $horcoords = , (($item -split '->')[0] -split ',')[0]
        $horcoords += (($item -split '->')[1] -split ',')[0]
        $vertcoords = , (($item -split '->')[0] -split ',')[1]
        $vertcoords += (($item -split '->')[1] -split ',')[1]
        If ($($horcoords | Sort-Object -Unique).count -eq 1) { $direction = "Vertical" } else { $direction = "Horizontal" }

        $object = [PSCustomObject]@{
            XA        = $($horcoords | Sort-Object)[0]
            XB        = $($horcoords | Sort-Object -Descending )[0]
            YA        = $($vertcoords | Sort-Object)[0]
            YB        = $($vertcoords | Sort-Object -Descending )[0]
            Direction = $direction
        }
        If (($($horcoords | Sort-Object -Unique).count -eq 1) -or ($($vertcoords | Sort-Object -Unique).count -eq 1)) {
            $lines += $object
        }

    }

    $horizontalStats = $lines.XA + $lines.XB | Measure-Object -Maximum
    $verticalStats = $lines.YA + $lines.YB | Measure-Object -Maximum
    $horizontalStats
    $verticalStats
    [System.Array]$diagram = New-Object 'object[,]' $horizontalStats.Maximum, $verticalStats.Maximum

    #fill Diagram with zero's
    $i = 0
    do {
        $j = 0
        do {
            $diagram[[int]$i, [int]$j] = 0
            $j++
        } while ($j -lt $diagram.GetLength(1))
        $i++
    } while ($i -lt $diagram.GetLength(0))
}
process {
    $lines.Count
    ForEach ($line in $lines) {
        switch ($line.Direction) {
            "Horizontal" {
                [int]$i = $line.XA
                do {
                    $diagram[[int]$($i - 1), [int]$($line.YA - 1)] = [int]$diagram[[int]$($i - 1), [int]$($line.YA - 1)] + [int]1
                    $i++
                } while ($i -le $line.XB)
            }
            "Vertical" {
                [int]$i = $line.YA
                do {
                    $diagram[[int]$($line.XA - 1), [int]$($i - 1)] = [int]$diagram[[int]$($line.XA - 1), [int]$($i - 1)] + [int]1
                    $i++
                } while ($i -le $line.YB)
            }
        }
    }
}

end {
    Write-Host "Number of dangerous spots: " -NoNewline -ForegroundColor Cyan
    Write-Host "$(($diagram | Where-object {$_ -ge 2}).Count)" -ForegroundColor Magenta

    #Print Diagram
    remove-item -Path "$PSScriptRoot\output.txt" -Force
    $i = 0
    do {
        $j = 0
        # Out-File -FilePath "$PSScriptRoot\output.txt" -Append -InputObject "`n" -NoNewline
        $textLine = ""
        do {
            $textLine += " $($diagram[[int]$j, [int]$i])"
            $j++
        } while ($j -lt $diagram.GetLength(1))
        $i++
        Add-Content -Path "$PSScriptRoot\output.txt" -Value $textLine
    } while ($i -lt $diagram.GetLength(0))
}
