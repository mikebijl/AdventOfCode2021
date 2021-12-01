[int[]]$measurements = Get-content adventofcode.csv
$answer = 0

$i = 1
do {
    if ($measurements[$i] -gt $measurements[$i-1]) {
        $answer++
    }
    $i++
} while ( $i -lt $measurements.count )

$answer