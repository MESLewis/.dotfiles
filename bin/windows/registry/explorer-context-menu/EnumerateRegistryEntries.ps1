New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR

$SearchPath = "HKCR:\*"
# $SearchPath = "HKCR:\batfile\shell"

$GeneratedDir = ("$PSScriptRoot\generated")
Get-ChildItem -Depth 2 -Path "HKCR:\" |
Where-Object { $_.PSChildName -like "shell" -or $_.PSChildName -like "shellex" -or $_.PSChildName -like "AllFileSystemObjects"} |
ForEach-Object {
	$RegPath = $_.Name
	$FileNameBase = $RegPath.replace('HKEY_CLASSES_ROOT\', '').replace('\', '.')
	$FileNameBase = $FileNameBase -replace '^(.*?)(\.)(.*)', '$1\$3'
	$SubFolder = "$GeneratedDir\$($($FileNameBase | Select-String -List -Pattern '^(.*?\\)').matches[0].value)"
	If(!(test-path "$SubFolder"))
	{
		New-Item -ItemType "directory" -Path "$SubFolder"
	}
	$AddFilePath = "$GeneratedDir\$FileNameBase.add.reg" 
	echo "Key: $RegPath"
	echo "Generated Path: $AddFilePath"
	reg export $RegPath $AddFilePath
	}

