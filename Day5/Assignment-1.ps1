param (
    [Switch]$example = $true
)

begin {
    If ($example -eq $true) { $file = "example" } else { $file = "input" }
    try { $content = Get-Content "$PSScriptRoot\$($file).txt" -ErrorAction Stop }
    catch { $content = Get-Content "$($file).txt" }

    $content = $content -replace '\s+', '' -replace '^\s', '' -replace '\s$', ''

    $lines = @()
    ForEach ($item in $content) {
        If ((($item -split '->')[0] -split ',')[0] -eq (($item -split '->')[1] -split ',')[0]) {$direction = "Horizontal"} else {$direction = "Vertical"}
        $lines += [PSCustomObject]@{
            XA = (($item -split '->')[0] -split ',')[0]
            YA = (($item -split '->')[0] -split ',')[1]
            XB = (($item -split '->')[1] -split ',')[0]
            YB = (($item -split '->')[1] -split ',')[1]
            Direction = $direction
        }
    }
    $horizontalStats    = $lines.XA + $lines.XB | Measure-Object -Maximum -Minimum
    $verticalStats      = $lines.YA + $lines.YB | Measure-Object -Maximum -Minimum

    [System.Array]$diagram = [System.Array]::CreateInstance( [Int32], $horizontalStats.Maximum, $verticalStats.Maximum )
}
process {
    # ForEach ($line in $lines) {
    #     If ($line.Direction -eq "Horizontal") {
    #         $diagram
    #     }
    # }
}

end {
    ConvertFrom-CSV -inputObject $diagram
}
