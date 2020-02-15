# https://support.microsoft.com/en-us/help/310516/how-to-add-modify-or-delete-registry-subkeys-and-values-by-using-a-reg

# Basics:
# Export from regedit.exe to get a .reg that will add.

# To delete: Modify .reg with a '-' preceding [KEY] and after "TestValue"=
# meaning [-KEY] and "TestValue"=-

# For KEY_CLASSES_ROOT\*\shell in particular:
# Add a key with the name "LegacyDisable" will disable the entry.
# Add a key with the name "Extended" will make it only show on the shift right click menu


# Finding all existing commands:
HKEY_CLASSES_ROOT\*\shell
HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers
HKEY_CLASSES_ROOT\*\AllFileSystemObjects\ShellEx

# For keys specific to only folders:
HKEY_CLASSES_ROOT\Directory\shell
HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers

# Run as admin - .ps1 script - Looks to just be open defaults
Get-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\*\shell
Get-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers
Get-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\*\AllFileSystemObjects\ShellEx


Get-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Directory\shell
Get-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers

#Testing key, easy to check and verify
HKEY_CLASSES_ROOT\batfile\shell

# Gets the relative path of all children
Get-ChildItem -Path Registry::HKEY_CLASSES_ROOT\batfile\shell -Name -Recurse

# Mape HKCR in the same way the two registry hives already are
New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
