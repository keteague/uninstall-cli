$search = "Unitrends Agent*"


$installed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, UninstallString
$installed += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString
#$installed | ?{ $_.DisplayName -ne $null } | sort-object -Property DisplayName -Unique | Format-Table -AutoSize


$result =$installed | ?{ $_.DisplayName -ne $null } | Where-Object {$_.DisplayName -like $search } 


if ($result.uninstallstring -like "msiexec*") {
    $args=(($result.UninstallString -split ' ')[1] -replace '/I','/X ') + ' /q'
    Start-Process msiexec.exe -ArgumentList $args -Wait
} else {
    Start-Process $result.UninstallString -Wait
}