[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$FormatEnumerationLimit = -1

$BaseLineFile = 'C:\aliases\saka.csv'
$locations = @(
    "\\srvfs01\Company\GRAFICA\KGT\KGT_MOTORIZZATI_SAKASHICHI\Disegni tecnici\",
    "\\srvfs01\Company\GRAFICA\00_File di lavoro\01_Tavole song gia\",
    "C:\_tmp\tavole\"
	"C:\OneDrive-Data\OneDrive - Dal Lago TTC S.r.l\Tech Sheets\"
)
echo $locations;

$args = $args.where({$_ -ne "90" -and $_ -ne "-" -and $_ -ne ""})

if ($($args.Count) -eq 0) {
	
	foreach ($FOLDER in $locations)
	{
		 Invoke-Item $FOLDER
	}
}

elseif ($($args.Count) -eq 1) {
    $item1 = $args[0]
    $regex = "($item1)+"

}
elseif ($($args.Count) -eq 2) {
    $item1 = $args[0]
    $item2 = $args[1]
    $regex = "(($item1)+.+($item2)+)|(($item2)+.+($item1)+)"
}
else {
        Write-Host "WRONG PARAMETERS" -Separator "\r\n"
 }



if (Get-Variable -Name regex -ErrorAction SilentlyContinue) {
  #  Write-Host "REGEX: " $regex
	
	$fileObj = ''
	
	if(Test-Path -LiteralPath $BaseLineFile -PathType Leaf)
	{
		$fileObj = Get-Item $BaseLineFile
	}

    if (-not(Test-Path -LiteralPath $BaseLineFile -PathType Leaf) -or ($fileObj.LastWriteTime) -lt (Get-Date).AddMinutes(-5) ){
$FullList = Get-ChildItem -LiteralPath $locations -Recurse -Force -Filter "*.pdf"
        $FullList | Select-Object FullName, Name, Length, LastWriteTime | Export-Csv -Path $BaseLineFile -Encoding utf8
    }
    else {
        $FullList = Import-Csv -Path $BaseLineFile
    }
        
}  
 
#20230518 Typecasting CSV imported data
$FullList | Where-Object { $_.Name -match $regex } | Select-Object -Property @{Name="Hash"; Expression={((Get-FileHash -LiteralPath $_.Fullname).hash)}}, Fullname | Sort-Object -Property Hash|Out-GridView -OutputMode Multiple 
