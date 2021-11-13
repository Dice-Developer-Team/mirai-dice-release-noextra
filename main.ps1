$JreURL = "https://dice-suhui-release-1252272169.file.myqcloud.com/OpenJDK11U-Windows-x86.zip"
$GitURL = "https://dice-suhui-release-1252272169.file.myqcloud.com/MinGit-Windows-x86.zip"

$JAVA = ""
$GIT = ""

# 尝试开启Tls1.2
if (-Not [System.Net.SecurityProtocolType]::Tls12)
{
	$TLSSource = @"
		using System.Net;
		public static class SecurityProtocolTypeExtensions
		{
			public const SecurityProtocolType EnableTls12 = (SecurityProtocolType)4032;
		}
"@
	
	Add-Type -TypeDefinition $TlSSource
	
	Try
	{
		[System.Net.ServicePointManager]::SecurityProtocol = [SecurityProtocolTypeExtensions]::EnableTls12
	}
	Catch
	{
<#
		开启失败，暂时不报错，因为当前切换到了支持Tls1.0的下载地址
		if ($PSVersionTable.PSVersion.Major -Le 2)
		{
			Write-Host "当前系统配置不支持TLS1.2，程序可能无法正常运行。请确保你正在使用Win7SP1或者Win2008R2SP1或更高版本，并打开Windows Update安装有关.Net Framework的更新后重试。"
		}
		else
		{
			Write-Host "当前系统配置不支持TLS1.2，程序可能无法正常运行。请更新至.Net Framework 4.5或更高版本后重试。"
		}
		Read-Host -Prompt "按回车键继续执行，但程序可能无法正常运行 ----->" 
#>
	}
}
else
{
	[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12
}

if (!$PSScriptRoot)
{
	$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

cd -LiteralPath "$PSScriptRoot"

function DownloadFile($url, $targetFile)
{
   $uri = New-Object "System.Uri" "$url"
   $request = [System.Net.HttpWebRequest]::Create($uri)
   $request.set_Timeout(15000) #15 second timeout
   $response = $request.GetResponse()
   $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)
   $responseStream = $response.GetResponseStream()
   $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create
   $buffer = new-object byte[] 256KB
   $count = $responseStream.Read($buffer,0,$buffer.length)
   $downloadedBytes = $count
   while ($count -gt 0)
   {
       $targetStream.Write($buffer, 0, $count)
       $count = $responseStream.Read($buffer,0,$buffer.length)
       $downloadedBytes = $downloadedBytes + $count
       Write-Progress -activity "正在下载文件 '$($url.split('/') | Select -Last 1)'" -Status "已下载 ($([System.Math]::Floor($downloadedBytes/1024))K of $($totalLength)K): " -PercentComplete ((([System.Math]::Floor($downloadedBytes/1024)) / $totalLength)  * 100)
   }
   Write-Progress -activity "文件 '$($url.split('/') | Select -Last 1)' 下载已完成" -Status "下载已完成" -Completed
   $targetStream.Flush()
   $targetStream.Close()
   $targetStream.Dispose()
   $responseStream.Dispose()
}

Write-Host "Mirai Dice 启动脚本"
Write-Host "初始化"

if (-Not (Test-Path -LiteralPath "$PSScriptRoot\.git" -PathType Container))
{
	Write-Host "警告：.git文件夹不存在" -ForegroundColor red
	Write-Host "这可能代表你未使用正确方式安装此程序" -ForegroundColor red
	Write-Host "虽然大多数功能仍将正常工作，但更新功能将无法正常使用" -ForegroundColor red
	Write-Host "请尝试使用正确方式重新安装以解决此问题" -ForegroundColor red
}

Try 
{
	Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
	function Unzip
	{
		param([string]$zipfile, [string]$outpath)

		[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
	}
}
Catch {
	if (-Not (Test-Path -LiteralPath "$PSScriptRoot\unzip.exe" -PathType Leaf))
	{
		$ZipURL = "https://dice-suhui-release-1252272169.file.myqcloud.com/unzip.exe"
		DownloadFile $ZipURL "$PSScriptRoot\unzip.exe"
	}
	
	if (-Not (Test-Path -LiteralPath "$PSScriptRoot\unzip.exe" -PathType Leaf))
	{
		Write-Host "无法加载Unzip" -ForegroundColor red
		Exit
	}
	
	function Unzip
	{
		param([string]$zipfile, [string]$outpath)

		& .\unzip.exe $zipfile -d $outpath
	}
}


Write-Host "检测Java"

Try 
{
	$Command = Get-Command -Name java -ErrorAction Stop
	if (($Command | Select-Object -ExpandProperty FileVersionInfo | Select-Object ProductMajorPart).ProductMajorPart -ge 11)
	{
		$JAVA = "java"
	}
}
Catch {}

Try {
	$Command = Get-Command -Name ".\jre\bin\java" -ErrorAction Stop
	if (($Command | Select-Object -ExpandProperty FileVersionInfo | Select-Object ProductMajorPart).ProductMajorPart -ge 11)
	{
		$JAVA = ".\jre\bin\java"
	}
}
Catch {}

if ($JAVA -eq "")
{
	DownloadFile $JreURL "$PSScriptRoot\java.zip"
	Remove-Item -LiteralPath "$PSScriptRoot\jre\" -Recurse -ErrorAction SilentlyContinue
	Unzip "$PSScriptRoot\java.zip" "$PSScriptRoot\jre\"
	Remove-Item -LiteralPath "$PSScriptRoot\java.zip" -ErrorAction SilentlyContinue
	Try 
	{
		$Command = Get-Command -Name ".\jre\bin\java" -ErrorAction Stop
		if (($Command | Select-Object -ExpandProperty FileVersionInfo | Select-Object ProductMajorPart).ProductMajorPart -ge 11)
		{
			$JAVA = ".\jre\bin\java"
		}
	}
	Catch 
	{
		Write-Host "无法加载Java!" -ForegroundColor red
		Exit
	}
}



Write-Host "Java: $JAVA" -ForegroundColor green
Write-Host "检测Git"

Try 
{
	$Command = Get-Command -Name git -ErrorAction Stop
	$GIT = "git"
}
Catch {}

Try 
{
	$Command = Get-Command -Name ".\git\cmd\git" -ErrorAction Stop
	$GIT = ".\git\cmd\git"
}
Catch {}

if ($GIT -eq "")
{
	DownloadFile $GitURL "$PSScriptRoot\git.zip"
	Remove-Item -LiteralPath "$PSScriptRoot\git\" -Recurse -ErrorAction SilentlyContinue
	Unzip "$PSScriptRoot\git.zip" "$PSScriptRoot\git\"
	Remove-Item -LiteralPath "$PSScriptRoot\git.zip" -ErrorAction SilentlyContinue
	Try 
	{
		$Command = Get-Command -Name ".\git\cmd\git" -ErrorAction Stop
		$GIT = ".\git\cmd\git"
	}
	Catch 
	{
		Write-Host "无法加载Git!" -ForegroundColor red
		Exit
	}
}

Write-Host "Git: $GIT" -ForegroundColor green

if (($args[0] -eq "--update") -or ($args[0] -eq "-u"))
{
	& "$GIT" fetch --depth=1
	& "$GIT" reset --hard origin/master
	Write-Host "更新操作已执行完毕" -ForegroundColor green
}
elseif (($args[0] -eq "--revert") -or ($args[0] -eq "-r"))
{
	& "$GIT" reset --hard "HEAD@{1}"
	Write-Host "回滚操作已执行完毕" -ForegroundColor green
}
elseif (($args[0] -eq "--fullautoslider") -or ($args[0] -eq "-f")) 
{
	del -Path ".\plugins\mirai-automatic-slider*"
	del -Path ".\plugins\mirai-login-solver-selenium*"
	copy -Path ".\fslider\mirai-automatic-slider*" ".\plugins\"
	& "$JAVA" -jar mcl.jar
}
elseif (($args[0] -eq "--autoslider") -or ($args[0] -eq "-a")) 
{
	del -Path ".\plugins\mirai-automatic-slider*"
	del -Path ".\plugins\mirai-login-solver-selenium*"
	copy -Path ".\slider\mirai-login-solver-selenium*" ".\plugins\"
	& "$JAVA" -jar mcl.jar
}
elseif (($args[0] -eq "--slider") -or ($args[0] -eq "-s")) 
{
	del -Path ".\plugins\mirai-automatic-slider*"
	del -Path ".\plugins\mirai-login-solver-selenium*"
	& "$JAVA" "-Dmirai.slider.captcha.supported" "-jar" "mcl.jar"
}
else
{
	del -Path ".\plugins\mirai-automatic-slider*"
	del -Path ".\plugins\mirai-login-solver-selenium*"
	& "$JAVA" -jar mcl.jar
}

