

$usrName = $Env:USERNAME
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
    $WebClient.dispose()
}

#$Number = (Read-Host -Prompt "введите номер Xlite::") -replace(" #",'')

function Find-XliteNumber {
    $Phone1 = (4285..4290)
    $Phone2 = (5900..5999)
    $Phone3 = (8814..8860)
    #$AllPhone = @{ 
    #    "1" = [string]$Phone1
    #    "2" = [string]$Phone2
    #    "3" = [string]$Phone3
    #    }
        
    $InputNumber = (Read-Host -Prompt "введите номер Xlite::") -replace(" ",'')
    $Number = $InputNumber
    
    if (!($Phone1 -eq $Number) -like $false){
        Text-Host -Text "Есть такой номер::$InputNumber"
        return $InputNumber
    }
    elseif (!($Phone2 -eq $Number) -like $false) {
        Text-Host -Text "Есть такой номер::$InputNumber"
        return $InputNumber
    }
    elseif (!($Phone3 -eq $Number) -like $false) {
        Text-Host -Text "Есть такой номер::$InputNumber"
        return $InputNumber
    }
    else{
        Write-Error -message "!!!!!номера нет или он введн не правильно!!!!"
        return Find-Xlitenumber
    }
}
# Получаем номер для настройки
$FindNumer = Find-XliteNumber
$FindNumer

Text-Host -Text "Формируем ссылка на настрйки номера"
$Url_dialPad = "https://github.com/nDPavel/Temp/raw/master/XliteProfile/$FindNumer/default_user/dialpad.cps"
$Url_dialPad
$Url_recentcalls = "https://github.com/nDPavel/Temp/raw/master/XliteProfile/$FindNumer/default_user/recentcalls.cps"
$Url_recentcalls
$Url_settings = "https://github.com/nDPavel/Temp/raw/master/XliteProfile/$FindNumer/default_user/settings.cps"
$Url_setting
$Url_ui = "https://github.com/nDPavel/Temp/raw/master/XliteProfile/$FindNumer/default_user/ui.cps"
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
# пути к файлам
$file_dialPad = (Join-Path -path  $pthUserAppDefUser  -ChildPath "dialpad.cps")    
$file_recentcalls = (Join-Path -path  $pthUserAppDefUser  -ChildPath "recentcalls.cps")   
$file_settings = (Join-Path -path  $pthUserAppDefUser  -ChildPath "settings.cps")   
$file_ui= (Join-Path -path  $pthUserAppDefUser  -ChildPath "ui.cps")   

if ($TpthUserAppDefUser) {
    Text-Host -Text "Удаляем старые настройки"
    Remove-Item -Path $pthUserAppDefUser -Force -Confirm:$false -Recurse
    Text-Host -Text "Создаем чистую директорию"
    New-Item -Path $pthUserAppDefUser -ItemType Directory -Force -Confirm:$false
    Text-Host -Text "Скачиваем dialpad.cps"
    Get-WebFile -Folder $file_dialPad -url $Url_dialPad
    Text-Host -Text "Скачиваем recentcalls.cps"
    Get-WebFile -Folder $file_recentcalls -url $Url_recentcalls
    Text-Host -Text "Скачиваем settings.cps"
    Get-WebFile -Folder $file_settings -url $Url_settings
    Text-Host -Text "Скачиваем ui.cps"
    Get-WebFile -Folder $file_ui -url $Url_ui
    Text-Host -Text "номер настроен $FindNumer"

}else{
    New-Item -Path $pthUserAppDefUser -ItemType Directory -Force -Confirm:$false
    Text-Host -Text "Создаем чистую директорию"
    New-Item -Path $pthUserAppDefUser -ItemType Directory -Force -Confirm:$false
    Text-Host -Text "Скачиваем dialpad.cps"
    Get-WebFile -Folder $file_dialPad -url $Url_dialPad
    Text-Host -Text "Скачиваем recentcalls.cps"
    Get-WebFile -Folder $file_recentcalls -url $Url_recentcalls
    Text-Host -Text "Скачиваем settings.cps"
    Get-WebFile -Folder $file_settings -url $Url_settings
    Text-Host -Text "Скачиваем ui.cps"
    Get-WebFile -Folder $file_ui -url $Url_ui
    Text-Host -Text "номер настроен $FindNumer"
}




