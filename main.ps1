$JreURL = "https://gitee.com/suhuiw4123/mirai-dice-release/attach_files/637574/download/OpenJDK11U-Windows-x86.zip"
$GitURL = "https://gitee.com/suhuiw4123/mirai-dice-release/attach_files/637695/download/MinGit-Windows-x86.zip"

$JAVA = ""
$GIT = ""

if (!$PSScriptRoot)
{
	$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

cd "$PSScriptRoot"

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
       Write-Progress -activity "���������ļ� '$($url.split('/') | Select -Last 1)'" -status "������ ($([System.Math]::Floor($downloadedBytes/1024))K of $($totalLength)K): " -PercentComplete ((([System.Math]::Floor($downloadedBytes/1024)) / $totalLength)  * 100)
   }
   Write-Progress -activity "�ļ� '$($url.split('/') | Select -Last 1)' ���������"
   $targetStream.Flush()
   $targetStream.Close()
   $targetStream.Dispose()
   $responseStream.Dispose()
}

Write-Host "Mirai Dice �����ű�"
Write-Host "��ʼ��"

if (-Not (Test-Path -Path "$PSScriptRoot\.git" -PathType Container))
{
	Write-Host "���棺.git�ļ��в�����" -ForegroundColor red
	Write-Host "����ܴ�����δʹ����ȷ��ʽ��װ�˳���" -ForegroundColor red
	Write-Host "��Ȼ����������Խ����������������¹��ܽ��޷�����ʹ��" -ForegroundColor red
	Write-Host "�볢��ʹ����ȷ��ʽ���°�װ�Խ��������" -ForegroundColor red
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
	if (-Not (Test-Path -Path "$PSScriptRoot\unzip.exe" -PathType Leaf))
	{
		$ZipURL = "https://gitee.com/suhuiw4123/mirai-dice-release/attach_files/646126/download/unzip.exe"
		DownloadFile $ZipURL "$PSScriptRoot\unzip.exe"
	}
	
	if (-Not (Test-Path -Path "$PSScriptRoot\unzip.exe" -PathType Leaf))
	{
		Write-Host "�޷�����Unzip" -ForegroundColor red
		Exit
	}
	
	function Unzip
	{
		param([string]$zipfile, [string]$outpath)

		& .\unzip.exe $zipfile -d $outpath
	}
}


Write-Host "���Java"

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
	$Command = Get-Command -Name "$PSScriptRoot\jre\bin\java" -ErrorAction Stop
	if (($Command | Select-Object -ExpandProperty FileVersionInfo | Select-Object ProductMajorPart).ProductMajorPart -ge 11)
	{
		$JAVA = "$PSScriptRoot\jre\bin\java"
	}
}
Catch {}

if ($JAVA -eq "")
{
	DownloadFile $JreURL "$PSScriptRoot\java.zip"
	Unzip "$PSScriptRoot\java.zip" "$PSScriptRoot\jre\"
	Remove-Item "$PSScriptRoot\java.zip"
	Try 
	{
		$Command = Get-Command -Name "$PSScriptRoot\jre\bin\java" -ErrorAction Stop
		if (($Command | Select-Object -ExpandProperty FileVersionInfo | Select-Object ProductMajorPart).ProductMajorPart -ge 11)
		{
			$JAVA = "$PSScriptRoot\jre\bin\java"
		}
	}
	Catch 
	{
		Write-Host "�޷�����Java!" -ForegroundColor red
		Exit
	}
}



Write-Host "Java: $JAVA" -ForegroundColor green
Write-Host "���Git"

Try 
{
	$Command = Get-Command -Name git -ErrorAction Stop
	$GIT = "git"
}
Catch {}

Try 
{
	$Command = Get-Command -Name "$PSScriptRoot\git\cmd\git" -ErrorAction Stop
	$GIT = "$PSScriptRoot\git\cmd\git"
}
Catch {}

if ($GIT -eq "")
{
	DownloadFile $GitURL "$PSScriptRoot\git.zip"
	Unzip "$PSScriptRoot\git.zip" "$PSScriptRoot\git\"
	Remove-Item "$PSScriptRoot\git.zip"
	Try 
	{
		$Command = Get-Command -Name "$PSScriptRoot\git\cmd\git" -ErrorAction Stop
		$GIT = "$PSScriptRoot\git\cmd\git"
	}
	Catch 
	{
		Write-Host "�޷�����Git!" -ForegroundColor red
		Exit
	}
}

Write-Host "Git: $GIT" -ForegroundColor green

if (($args[0] -eq "--update") -or ($args[0] -eq "-u"))
{
	& "$GIT" fetch --depth=1
	& "$GIT" reset --hard origin/master
	Write-Host "���²�����ִ�����" -ForegroundColor green
}
elseif (($args[0] -eq "--revert") -or ($args[0] -eq "-r"))
{
	& "$GIT" reset --hard "HEAD@{1}"
	Write-Host "�ع�������ִ�����" -ForegroundColor green
}
elseif (($args[0] -eq "--fullautoslider") -or ($args[0] -eq "-f")) 
{
	del -Path "$PSScriptRoot\plugins\mirai-automatic-slider*"
	del -Path "$PSScriptRoot\plugins\mirai-login-solver-selenium*"
	copy -Path "$PSScriptRoot\fslider\mirai-automatic-slider*" "$PSScriptRoot\plugins\"
	& "$JAVA" -jar mcl.jar
}
elseif (($args[0] -eq "--autoslider") -or ($args[0] -eq "-a")) 
{
	del -Path "$PSScriptRoot\plugins\mirai-automatic-slider*"
	del -Path "$PSScriptRoot\plugins\mirai-login-solver-selenium*"
	copy -Path "$PSScriptRoot\slider\mirai-login-solver-selenium*" "$PSScriptRoot\plugins\"
	& "$JAVA" -jar mcl.jar
}
elseif (($args[0] -eq "--slider") -or ($args[0] -eq "-s")) 
{
	del -Path "$PSScriptRoot\plugins\mirai-automatic-slider*"
	del -Path "$PSScriptRoot\plugins\mirai-login-solver-selenium*"
	& "$JAVA" "-Dmirai.slider.captcha.supported" "-jar" "mcl.jar"
}
else
{
	del -Path "$PSScriptRoot\plugins\mirai-automatic-slider*"
	del -Path "$PSScriptRoot\plugins\mirai-login-solver-selenium*"
	& "$JAVA" -jar mcl.jar
}

