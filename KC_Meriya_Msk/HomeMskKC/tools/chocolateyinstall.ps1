import-module C:\ProgramData\chocolatey\helpers\functions\Get-ChocolateyWebFile.ps1
import-module "C:\ProgramData\chocolatey\helpers\functions\Install-ChocolateyPackage.ps1"
function Text-Host {
  [CmdletBinding()]
  param (
      [string]$Text
  )
  Write-Host -Object "##################################" -ForegroundColor Green
  Write-Host -Object ":::: $Text "   -ForegroundColor Green
  Write-Host -Object "##################################" -ForegroundColor Green

}
function Get-WebFile {
  param (
  [string]$url,  
  [string]$Folder
  )
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $download_url = $url
  $local_path = $Folder
  $WebClient = New-Object System.Net.WebClient
  $WebClient.DownloadFile($download_url, $local_path)
}

$packageName = $env:ChocolateyPackageName

$pthinstall = "c:\intel\soft"
$tPthinstall = Test-Path "C:\intel"
$tPthSoft = Test-Path "C:\intel\soft"
# полвеояем существовавие папок c:\intel и c:\intel\Soft


$urlXlite   = "https://github.com/nDPavel/Temp/raw/master/X-Lite3_29712.exe"
$urlAnnyCon =  "https://github.com/nDPavel/Temp/raw/master/anyconnect-win-4.7.04056.exe"
$urlChromeBookEdit = "https://github.com/nDPavel/Temp/raw/master/ChromeBookEdit.exe"



$packageName      = 'KC_Meriya_Msk'
$checkSumType     = 'SHA256'
$url_Xlite        = $urlXlite
$chkSum_Xlite     = "FA5A0694C2F29BDD6A8E7CCD5D6EAF66F90D87ED82FD88B368C4D940162F042D"

$url_AnnyCon      = $urlAnnyCon
$chkSum_AnnyConn  = "B574392D4112CB7326DC1FBF255B7418D8CCFCD45AEC0A2586237B97DF92F0ED"

$url_ChromeBook   = $urlChromeBookEdit 
$chkSum_ChromBook = "44376EA49F135EE49D37B8EE157951D8F6C878989E8177174C56BF2CEA0951B8"
# ChromeBook 
Get-ChocolateyWebFile -packageName $packageName  `
                          -fileFullPath (Join-Path -Path $pthinstall -ChildPath "ChromeBookEdit.exe") `
                          -url64 $url_ChromeBook `
                          -checksum64 $chkSum_ChromBook `
                          -checksumType $checkSumType

# xlite
Get-ChocolateyWebFile -packageName $packageName  `
                          -fileFullPath (Join-Path -Path $pthinstall -ChildPath "X-Lite3_29712.exe") `
                          -url64 $url_Xlite `
                          -checksum $chkSum_Xlite `
                          -checksumType $checkSumType

                          # annyconn 
Get-ChocolateyWebFile -packageName $packageName  `
                          -fileFullPath (Join-Path -Path $pthinstall -ChildPath "anyconnect-win-4.7.04056.exe") `
                          -url $url_AnnyCon  `
                          -checksum $chkSum_AnnyConn `
                          -url64 $url_AnnyCon  `
                          -checksum64 $chkSum_AnnyConn `
                          -checksumType $checkSumType

Text-Host -Text "Устанавливаем ПО xlite"

Install-ChocolateyInstallPackage -packageName "X-lite 3" `
                                -fileType "exe"  `
                                -silentArgs "/SILENT " `
                                -file64 "C:\intel\soft\X-Lite3_29712.exe" -validExitCodes @(0, 3010, 1641)
Text-Host -Text "Остановка процесса X-lite"
  & taskkill.exe /im x-lite.exe /f
Text-Host -Text "Устанавливаем ПО AnnyConnection"

Install-ChocolateyInstallPackage -packageName "AnnyConnection" `
                                -fileType "exe"  `
                                -silentArgs " /qn" `
                                -file "C:\intel\soft\anyconnect-win-4.7.04056.exe" `
                                -file64 "C:\intel\soft\anyconnect-win-4.7.04056.exe" -validExitCodes @(0, 3010, 1641)

# Конфигурирование настроек
#google
Text-Host -Text "добавляем ссылки на пропуска"
Start-Process -FilePath "C:\intel\Soft\ChromeBookEdit.exe" -Wait

$usrName = $Env:USERNAME

Text-Host -Text "Текущий пользователь:: $usrName"
$pthAnnyConnCfg   = "C:\Users\$usrName\AppData\Local\Cisco\Cisco AnyConnect Secure Mobility Client\preferences.xml"
$pthAppCisco      = "C:\Users\$usrName\AppData\Local\Cisco"
$pthAppCiscoAnny  = "C:\Users\$usrName\AppData\Local\Cisco\Cisco AnyConnect Secure Mobility Client"
# тестируем пути
$tPthAnnyConnCfg  = Test-Path $pthAnnyConnCfg
$tPthAppCisco     = Test-Path $pthAppCisco
$tPthAppCiscoAnny = Test-Path $pthAppCiscoAnny
# логика обработки папок настройки анни конекшен

if($tPthAnnyConnCfg -like $true){
  if (!$tPthAppCisco or !$tPthAppCiscoAnny) {
    New-Item -Path $pthAppCiscoAnny -ItemType Directory -Force -Confirm:$false
    
    $xmlsettings = New-Object System.Xml.XmlWriterSettings
    $xmlsettings.Indent = $true
    $xmlsettings.IndentChars = "    "
    $XmlWriter = [System.XML.XmlWriter]::Create("$pthAnnyConnCfg ", $xmlsettings)
    $xmlWriter.WriteStartDocument()
    $xmlWriter.WriteStartElement("AnyConnectPreferences")
      $xmlWriter.WriteElementString("DefaultUser","")
      $xmlWriter.WriteElementString("DefaultSecondUser","")
      $xmlWriter.WriteElementString("ClientCertificateThumbprint","")
      $xmlWriter.WriteElementString("MultipleClientCertificateThumbprints","")
      $xmlWriter.WriteElementString("ServerCertificateThumbprint","")
      $xmlWriter.WriteElementString("DefaultHostName","vpn.fl-cc.ru")
      $xmlWriter.WriteElementString("DefaultHostAddress","")
      $xmlWriter.WriteElementString("DefaultGroup","")
      $xmlWriter.WriteElementString("ProxyHost","")
      $xmlWriter.WriteElementString("ProxyPort","")
      $xmlWriter.WriteElementString("SDITokenType","none")
      $xmlWriter.WriteStartElement("ControllablePreferences") # <-- Start <SubObject> 
        $xmlWriter.WriteElementString("BlockUntrustedServers",$false)
      $xmlWriter.WriteEndElement() # <-- End <SubObject>
    $xmlWriter.WriteEndElement() # <-- End <Root> 
    $xmlWriter.WriteEndDocument()
    $xmlWriter.Flush()
    $xmlWriter.Close()
    
  }  

}else{

  $xmlsettings = New-Object System.Xml.XmlWriterSettings
  $xmlsettings.Indent = $true
  $xmlsettings.IndentChars = "    "
  $XmlWriter = [System.XML.XmlWriter]::Create("$pthAnnyConnCfg ", $xmlsettings)
  $xmlWriter.WriteStartDocument()
  $xmlWriter.WriteStartElement("AnyConnectPreferences")
    $xmlWriter.WriteElementString("DefaultUser","")
    $xmlWriter.WriteElementString("DefaultSecondUser","")
    $xmlWriter.WriteElementString("ClientCertificateThumbprint","")
    $xmlWriter.WriteElementString("MultipleClientCertificateThumbprints","")
    $xmlWriter.WriteElementString("ServerCertificateThumbprint","")
    $xmlWriter.WriteElementString("DefaultHostName","vpn.fl-cc.ru")
    $xmlWriter.WriteElementString("DefaultHostAddress","")
    $xmlWriter.WriteElementString("DefaultGroup","")
    $xmlWriter.WriteElementString("ProxyHost","")
    $xmlWriter.WriteElementString("ProxyPort","")
    $xmlWriter.WriteElementString("SDITokenType","none")
    $xmlWriter.WriteStartElement("ControllablePreferences") # <-- Start <SubObject> 
      $xmlWriter.WriteElementString("BlockUntrustedServers",$false)
    $xmlWriter.WriteEndElement() # <-- End <SubObject>
  $xmlWriter.WriteEndElement() # <-- End <Root> 
  $xmlWriter.WriteEndDocument()
  $xmlWriter.Flush()
  $xmlWriter.Close()
  
}

# настройка телефонии

function Set-XlitePhone {
  
  $Number = (Read-Host -Prompt "введите номер Xlite::") -replace(" ",'')
  $Phone1 = (4285..4290) 
  $Phone2 = (5900..5999)
  $Phone3 = (8814..8860)
  $Number = $Null
  #Функция копирования настроек xlite
  $Number = 4285

  function Set-XliteSettings{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Number,
        [Parameter()]
        [string]
        $AppUser
    )
    Text-Host -Text "Формируем ссылка на настрйки номера"
    $Url_dialPad = "https://github.com/nDPavel/Temp/raw/master/XliteProfile/$Number/default_user/dialpad.cps"
    $Url_recentcalls = "https://github.com/nDPavel/Temp/raw/master/XliteProfile/$Number/default_user/recentcalls.cps"
    $Url_settings = "https://github.com/nDPavel/Temp/raw/master/XliteProfile/$Number/default_user/settings.cps"
    $Url_ui = "https://github.com/nDPavel/Temp/raw/master/XliteProfile/$Number/default_user/ui.cps"
    
    
    $Url_dialPad
    $Url_recentcalls
    $Url_setting
    $Url_ui

    Text-Host -Text "Подготавливаем профиль пользователя"
    # проверяем профиль пользователя
    # C:\Users\Administrator\AppData\Local\CounterPath\X-Lite\default_user
    $pthUserAppCounter = "c:\users\$usrName\appdata\Local\CounterPath"
    $TpthUserAppCounter = Test-Path $pthUserAppCounter
    $pthUserAppXlite = "c:\users\$usrName\appdata\Local\CounterPath\X-Lite"
    $TpthUserAppXlite = Test-Path $pthUserAppXlite
    $pthUserAppDefUser = "c:\users\$usrName\appdata\Local\CounterPath\X-Lite\default_user"
    $TpthUserAppDefUser = Test-Path $pthUserAppDefUser
    if ($TpthUserAppDefUser) {
      Text-Host -Text "Удаляем старые настройки"
      Remove-Item -Path $pthUserAppDefUser -Force -Confirm:$false -Recurse
      New-Item -Path $pthUserAppDefUser -ItemType Directory -Force -Confirm:$false
    
    
    
    }else{
      New-Item -Path $pthUserAppDefUser -ItemType Directory -Force -Confirm:$false
    }



  
  
  
  }
  







  if (!($Phone1 -eq $Number) -like $false){
    Text-Host -Text "настраиваем телефонию"
    Text-Host -Text "на номер::$Number"
  }
  elseif (!($Phone2 -eq $Number) -like $false) {
    Text-Host -Text "настраиваем телефонию"
    Text-Host -Text "на номер::$Number"
  }
  elseif (!($Phone3 -eq $Number) -like $false) {
    Text-Host -Text "настраиваем телефонию"
    Text-Host -Text "на номер::$Number"
  }
  else{
    Write-Error -message "!!!!!номера нет или он введн не правильно!!!!"
    
    return Set-XlitePhone
  }
   
}

Set-XlitePhone 






