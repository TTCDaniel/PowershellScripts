Get-ChildItem -File | Where {$_.extension -in ".pdf",".stp" ,".step"}| % {	
	
	$PrettyName  = $_.Name
	
	[regex]$prePrettyName_rgx1 = '(^[0-9_-]+)(.*)'; #numeri iniziali
	[regex]$prePrettyName_rgx2 = '\('; #parentesi aperta
	[regex]$prePrettyName_rgx3 = '\)'; #parentesi chiusa
	[regex]$prePrettyName_rgx4 = '[_]+'; #underscore
	[regex]$prePrettyName_rgx5 = '[ ]+'; #spaces
	[regex]$prePrettyName_rgx6 = '([ ]+)(\.pdf)'; #end
	[regex]$PrettyName_rgx = '([A-Z0-9]{6,})+([\- _]?)+((\([ \-0-9\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff66-\uff9f]+)\))([\- _]?)+([A-Z0-9]{6,})(.*)'
	
	if($PrettyName -match $prePrettyName_rgx1)
	{
		$PrettyName  = $PrettyName -replace $prePrettyName_rgx1, '$2'
	}
	
	if($PrettyName -match $prePrettyName_rgx2)
	{
		$PrettyName  = $PrettyName -replace $prePrettyName_rgx2, ' ('
	}
	if($PrettyName -match $prePrettyName_rgx3)
	{
		$PrettyName  = $PrettyName -replace $prePrettyName_rgx3, ') '
	}
	if($PrettyName -match $prePrettyName_rgx4)
	{
		$PrettyName  = $PrettyName -replace $prePrettyName_rgx4, '-'
	}
	if($PrettyName -match $prePrettyName_rgx5)
	{
		$PrettyName  = $PrettyName -replace $prePrettyName_rgx5, ' '
	}
	if($PrettyName -match $prePrettyName_rgx6)
	{
		$PrettyName  = $PrettyName -replace $prePrettyName_rgx6, '$2'
	}
	
	if($PrettyName -match $PrettyName_rgx)
	{
		#$PrettyName = $PrettyName -replace $PrettyName_rgx, '$1 - $6 - $3$7'
		#reversed:
		$PrettyName = $PrettyName -replace $PrettyName_rgx, '$6 - $1 $3$7'
	}
	
			if($PrettyName.length -le 10)
		{
			write-host $_.name " viene sanificato con " $PrettyName
			exit
		}
	
	if( -not ($_.Name -eq $PrettyName))
	{
		if(-not (Test-Path -Path $PrettyName))
		{
			Write-Host $_.Name  " sanificato in " $PrettyName
			Rename-Item -literalpath $_.Name -NewName $PrettyName -ErrorAction Inquire
		}
		else
		{
			$fallback = (Get-Date -Format "yyyyMMddHHssfff")+".pdf";
			$PrettyName +=$fallback
			Write-Host $_.Name  " sanificato in " $PrettyName " COLLISIONE"
			Rename-Item -literalpath $_.Name -NewName $PrettyName -ErrorAction Inquire
		}
	}
	else
	{
		#Write-Host $_.Name " non necessita di sanificazione"
	}
}