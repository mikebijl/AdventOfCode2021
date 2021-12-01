$measurements = @(Get-content adventofcode.csv)
$answer = 0

$i = 1
do {
    if ([int]$measurements[$i] -gt [int]$measurements[$i-1]) { # without the int cast there will be one case that is interepret wrongly
        $answer++
    }
    $i++
} while ( $i -lt $measurements.count )

$answer