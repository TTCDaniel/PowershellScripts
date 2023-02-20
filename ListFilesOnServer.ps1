[Console]::OutputEncoding = [System.Text.Encoding]::UTF8;

Measure-Command -Expression {

$startDT = Get-Date;
$AllFiles = Get-ChildItem -Force -File -Recurse -Path "\\srvfs01\\company\\"  | select FullName, Length, CreationTime, LastWriteTime, @{N="Owner";E={ (Get-Acl $_.FullName).Owner }}, @{N="Age";E={[int](((Get-Date) -  $_.LastWriteTime).TotalDays) }};
$AllFiles |  Export-Csv -path "\\srvfs01\company\GRAFICA\00_File di lavoro\Allfiles.txt" -Encoding utf8NoBOM -NoTypeInformation;
Copy-Item  "\\srvfs01\company\GRAFICA\00_File di lavoro\Allfiles.txt" -Destination $("{0}{1}{2}" -f "\\srvfs01\company\GRAFICA\00_File di lavoro\AllFiles_", $(Get-Date -Format "yyyyMMdd"), ".txt");

$LastWeekFiles = $AllFiles | Where-Object -FilterScript {$_.Age -le [int](Get-Date -UFormat "%u")}
$LastWeekFiles | Export-Csv -path "\\srvfs01\company\GRAFICA\00_File di lavoro\WeeklyFiles.txt" -Encoding utf8NoBOM -NoTypeInformation;
Copy-Item  "\\srvfs01\company\GRAFICA\00_File di lavoro\WeeklyFiles.txt" -Destination $("{0}{1}{2}" -f "\\srvfs01\company\GRAFICA\00_File di lavoro\WeeklyFiles_", $(Get-Date -Format "yyyyMMdd"), ".txt");
$endDT = Get-Date;
echo ($endDT - $startDT).TotalMiunutes;
}
read-host “Press ENTER to continue...”