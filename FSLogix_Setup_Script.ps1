
#******************************************************
#                  FSLogix Configuration           ****
#******************************************************


#******************************************************
#                   Setup SMB Share                ****
#******************************************************
# Share level permissions should be                ****
# Domain Admin "Full Contol"                       ****
# Everyone "Modify"                                ****
#******************************************************


#******************************************************
#          ******* SET VARIABLES ********          ****
#******************************************************
$ProfileContainerUNC = "<\\SERVER_NAME\SHARE> | <\\SERVER_NAME\SHARE;\\SERVER_NAME\SHARE;etc...>"
$OfficeContainerUNC = "<\\SERVER_NAME\SHARE> | <\\SERVER_NAME\SHARE;\\SERVER_NAME\SHARE;etc...>"
$RegPropertyType = "<String | MultiString>"


#******************************************************
#     Set Registry Keys for Profile Containers     ****
#******************************************************
New-Item hklm:\software\FSLogix\Profiles -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name Enabled -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name VHDLocations -Value $ProfileContainerUNC  -PropertyType $RegPropertyType  -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name PreventLoginWithFailure -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name DeleteLocalProfileWhenVHDShouldApply -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name AccessNetworkAsComputerObject -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name FlipFlopProfileDirectoryName -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name IsDynamic -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name SizeInMBs -Value 30000 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name KeepLocalDir -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name PreventLoginWithFailure -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name VolumeType -Value "vhdx" -PropertyType String -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name SIDDirNameMatch -Value "%sid%_%username%" -PropertyType String -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name SIDDirNamePattern -Value "%sid%_%username%" -PropertyType String -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name VHDNameMatch -Value "Profile*" -PropertyType String -Force
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name VHDNamePattern -Value "Profile_%username%" -PropertyType String -Force


#******************************************************
#      Set Registry Keys for Office Containers     ****
#******************************************************
New-Item hklm:\software\Policies\FSLogix\ODFC -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name Enabled -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name VHDLocations -Value $OfficeContainerUNC  -PropertyType $RegPropertyType  -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name DeleteLocalProfileWhenVHDShouldApply -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name PreventLoginWithFailure -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name IncludeOneDrive -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name IncludeOneNote -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name IncludeOneNote_UWP -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name IncludeOutlook -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name IncludeOutlookPersonalization -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name IncludeSharepoint -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name IncludeSkype -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name IncludeTeams -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name SizeInMBs -Value 30000 -PropertyType DWORD -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name VolumeType -Value "vhdx" -PropertyType String -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name SIDDirNameMatch -Value "%sid%_%username%" -PropertyType String -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name SIDDirNamePattern -Value "%sid%_%username%" -PropertyType String -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name VHDNameMatch -Value "Profile*" -PropertyType String -Force
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFC -Name VHDNamePattern -Value "Profile_%username%" -PropertyType String -Force


#******************************************************
#     FSLogix Cloud Cache for Profile Containers   ****
#******************************************************
New-ItemProperty -Path hklm:\software\FSLogix\Profiles -Name CCDLocations -Value "type=smb,connectionString=\\SERVER_NAME\SHARE" -PropertyType String  -Force

#******************************************************
#     FSLogix Cloud Cache for Office Container     ****
#******************************************************
New-ItemProperty -Path hklm:\software\Policies\FSLogix\ODFCs -Name CCDLocations -Value "type=smb,connectionString=\\SERVER_NAME\SHARE" -PropertyType String  -Force


#******************************************************
#                Download FSLogix                  ****
#******************************************************
$url = "https://aka.ms/fslogix_download"
$path = "C:\FSLogix_Apps.zip"
if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) 
{$path = Join-Path $pwd (Split-Path -leaf $path)}
$client = new-object System.Net.WebClient
$client.DownloadFile($url, $path)
& mkdir C:\FSLogix_App
& Expand-Archive C:\FSLogix_Apps.zip -d c:\FSLogix_App
& del C:\FSLogix_Apps.zip


#******************************************************
#     Install appropriate app or all of them       ****
#******************************************************
C:\FSLogix_App\x64\Release\FSLogixAppsSetup.exe /install /passive /norestart
C:\FSLogix_App\x64\Release\FSLogixAppsRuleEditorSetup.exe /install /passive /norestart
C:\FSLogix_App\x64\Release\FSLogixAppsJavaRuleEditorSetup.exe /install /passive /norestart


#Install Locations
& "C:\Program Files\FSLogix\Apps\RuleEditor.exe"
& "C:\Program Files\FSLogix\Apps\JavaRuleEditor.exe"


#******************************************************
#       FSLogix Local Groups or lusrmgr.msc        ****
#******************************************************
Add-LocalGroupMember `
-Group "FSLogix Profile Exclude List" `
-Member "Administrators", "DOMAIN NAME\Domain Admins"

Add-LocalGroupMember `
-Group "FSLogix ODFC Exclude List" `
-Member "Administrators", "DOMAIN NAME\Domain Admins"

Get-LocalGroupMember `
-Group "FSLogix ODFC Exclude List" 
Get-LocalGroupMember `
-Group "FSLogix Profile Exclude List"
`


#******************************************************
#                FSLogix Task Tray App             ****
#******************************************************
& "C:\Program Files\FSLogix\Apps\frxtray.exe"



#******************************************************
#                  Check Redirects                 ****
#******************************************************
C:\Program Files\FSLogix\Apps\frx.exe list-redirects


#******************************************************
#           Create VHDX from Local Profile         ****
#******************************************************
cd "\Program Files\FSLogix\Apps"
frx create-vhd -filename c:\Profile_XXXX.vhdx   # Replace XXXX with user name. Not UPN or Domain\user.
frx copy-profile -filename c:\Profile_XXXX.vhdx -username XXXX -dynamic 1 -verbose #Provide the user name.



