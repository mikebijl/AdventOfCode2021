param (
    [Switch]$example
)

begin {
    $day = $PSScriptRoot.Substring($PSScriptRoot.Length - 1, 1)
    If ($example -eq $true) { $file = "example" } else { $file = "input" }
    $content = Get-Content "$PSScriptRoot\$($file)_$day.txt"
    # $content = Get-Content "Day4\Example_4.txt"
    function Convert-BingoCard {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true)]
            $card,
            [Parameter(Mandatory = $true)]
            [int]
            $cardIndex
        )

        begin {
            #normalize input to scrub all unnecessary white spaces
            $card = $card -replace '\s+', ' ' -replace '^\s', '' -replace '\s$', ''

            # convert input to CSV object
            $csv = ConvertFrom-Csv -InputObject $card -Delimiter ' ' -Header "c1", "c2", "c3", "c4", "c5"
            $cardSequence = @()
        }

        process {
            # add horizontal row to $cardSequence
            Foreach ($line in $csv) {
                $cardSequence += [PSCustomObject]@{
                    cardIndex = $cardIndex
                    Direction = 'Row'
                    value1    = $($line.PsObject.Properties.Value[0])
                    match1    = $false
                    value2    = $($line.PsObject.Properties.Value[1])
                    match2    = $false
                    value3    = $($line.PsObject.Properties.Value[2])
                    match3    = $false
                    value4    = $($line.PsObject.Properties.Value[3])
                    match4    = $false
                    value5    = $($line.PsObject.Properties.Value[4])
                    match5    = $false
                }
            }
            # add vertical columns to $cardSequence
            $headers = $csv | Get-member -MemberType 'NoteProperty' | Select-Object -ExpandProperty 'Name'
            Foreach ($column in $headers) {
                $cardSequence += [PSCustomObject]@{
                    cardIndex = $cardIndex
                    Direction = 'Column'
                    value1    = $csv.$column[0]
                    match1    = $false
                    value2    = $csv.$column[1]
                    match2    = $false
                    value3    = $csv.$column[2]
                    match3    = $false
                    value4    = $csv.$column[3]
                    match4    = $false
                    value5    = $csv.$column[4]
                    match5    = $false
                }

            }
        }

        end {
            return $cardSequence
        }
    }

    $drawingSequence = $content[0].Split(',')
    $contentCards = $content[2..$($content.Count - 1)]

    $bingoCardLines = @()
    $bingocardsRAW = @()
    $bingocardRAW = @()

    Foreach ($line in $contentCards) {
        If ($line -match '^\s*$') {
            $bingocardsRAW += , $bingocardraw
            $bingocardraw = @()
        }
        else {
            $bingocardraw += $line
        }
    }
    $bingocardsRAW += , $bingocardraw
}
process {
    # create list of all available rows and columns
    $i = 0
    Foreach ($card in $bingocardsRAW) {
        $bingoCardLines += $(Convert-BingoCard -card $card -cardIndex $i)
        $i++
    }

    $wonCards = [int[]]::new(($bingoCardLines | Sort-Object -Unique CardIndex).CardIndex.count)

    foreach ($draw in $drawingSequence) {

        $bingoCardLines | Where-Object {
            $_.PSObject.Properties.value.indexOf("$draw") -ne '-1'
        } | ForEach-Object {
            $_."$($_.PSObject.Properties.Name[$($_.PSObject.Properties.value.indexOf("$draw"))+1])" = $true
        }

        $bingocardLines | Where-object {
            -not($_.PSObject.Properties.Value.Contains($false))
        } | ForEach-Object {
            $wonCards[$_.cardIndex] = 1
        }

        #check when all cards have a winning line
        If (($wonCards | Where-Object { $_ -eq 0 }).count -eq 0) {
            $losingDraw = $draw
            break
        }
        # check when there is only 1 card that has no winning line. Store that card for future references.
        if (($wonCards | Where-Object { $_ -eq 0 }).count -eq 1) {
            $losingCardIndex = $wonCards.IndexOf(0)
        }
    }


}

end {
    $result = 0
    Write-Output "Losing Card: $($losingCardIndex)"
    Write-Output "Losing Draw: $($losingDraw)"
    $bingocardLines | Where-object {
         ($_.cardIndex -eq "$losingCardIndex") -and ($_.Direction -eq 'Row')
    } | ForEach-Object {
        $bingoCardLine = $_
        ($_.PSObject.Properties.GetEnumerator() | Where-Object { $_.value -eq $false }).name -replace 'match', 'value' | ForEach-Object {
            $result += $bingoCardLine.$_
        }
    }
    $result
    $result = $result * $losingDraw
    Write-Output "The Answer: $result"
}
