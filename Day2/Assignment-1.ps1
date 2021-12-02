$instructions = Import-Csv input.txt -Delimiter ' ' -Header 'Direction','Distance'

$verticalDistance = 0
$horizontalDistance = 0

foreach ($instruction in $instructions) {
    switch ($instruction.Direction) {
        "forward"   {
            $horizontalDistance += $instruction.Distance
        }
        "up"        {
            $verticalDistance   -= $instruction.Distance
        }
        "down"      {
            $verticalDistance   += $instruction.Distance
        }
        Default     {
            $horizontalDistance -= $instruction.Distance
        }
    }
}
write-host "Depth of the submarine is: " -NoNewline -ForegroundColor Cyan
Write-Host $verticalDistance -ForegroundColor Magenta
write-host "Horizontal distance of the submarine is: " -NoNewline -ForegroundColor Cyan
Write-Host $horizontalDistance -ForegroundColor Magenta

$answer = $horizontalDistance * $verticalDistance
write-host "Answer: " -NoNewline -ForegroundColor Cyan
Write-Host $answer -ForegroundColor Magenta