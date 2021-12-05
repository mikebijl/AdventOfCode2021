param (
    [Switch]$example
)

begin {
    If ($example -eq $true) { $file = "example" } else { $file = "input" }
    try { $content = Get-Content "$PSScriptRoot\$($file).txt" -ErrorAction Stop }
    catch { $content = Get-Content "$($file).txt" }

}
process {
}

end {
}
