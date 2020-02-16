New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR

#Write-Output #General "print this object"

$SearchPath = "HKCR:\"
#$SearchPath = "HKCR:\batfile"

$GeneratedDir = ("$PSScriptRoot\generated")
Get-ChildItem -Depth 1 -Path $SearchPath |
Where-Object { $_.PSChildName -like "shell" -or $_.PSChildName -like "shellex" } |
ForEach-Object { 
	$RegPath = $_.Name
	Write-Output $RegPath
	$Child = $RegPath.replace('HKEY_CLASSES_ROOT\', '')
	$SplitPath = Split-Path -Parent -Path $Child
	$Child = $Child.replace('\', '.')
	$SubFolder = "$GeneratedDir\$SplitPath"
	If(!(test-path "$SubFolder"))
	{
		New-Item -ItemType "directory" -Path "$SubFolder" | Out-Null
	}
	#Set-PSDebug -Trace 0
	echo $RegPath "$SubFolder\$Child.enable.reg"
	reg.exe export $RegPath "$SubFolder\$Child.enable.reg"
}
return




	#####$FileNameBase = $RegPath.replace('HKEY_CLASSES_ROOT\', '')#.replace('\', '.')
	#$FileNameBase = $FileNameBase -replace '^(.*?)(\.)(.*)', '$1\$3'
	#####$SubFolder = "$GeneratedDir\$($($FileNameBase | Select-String -List -Pattern '^(.*\\)').matches[0].value)"
	#$SubFolder = "$GeneratedDir\$($($FileNameBase | Select-String -List -Pattern '^(.*?\\)').matches[0].value)"
	#If(!(test-path "$SubFolder"))
	#{
		#New-Item -ItemType "directory" -Path "$SubFolder"
	#}
	#####New-Item -Force -ItemType "directory" -Path "$SubFolder"
	#####$AddFilePath = "$GeneratedDir\$FileNameBase.add.reg" 
	#echo "Key: $RegPath"
	#echo "Generated Path: $AddFilePath"
	#####reg export $RegPath $AddFilePath
	#}

