$JreURL = "https://gitee.com/suhuiw4123/mirai-dice-release/attach_files/637574/download/OpenJDK11U-Windows-x86.zip"
$GitURL = "https://gitee.com/suhuiw4123/mirai-dice-release/attach_files/637695/download/MinGit-Windows-x86.zip"

$JAVA = ""
$GIT = ""

cd $PSScriptRoot

Write-Host "Mirai Dice 启动脚本"

Write-Host "检测Java"
Try 
{
	$Command = Get-Command -Name java -ErrorAction Stop
	if (($Command | Select-Object -ExpandProperty Version).Major -ge 11)
	{
		$JAVA = "java"
	}
}
Catch {}

Try {
	$Command = Get-Command -Name "$PSScriptRoot\jre\bin\java" -ErrorAction Stop
	if (($Command | Select-Object -ExpandProperty Version).Major -ge 11)
	{
		$JAVA = "$PSScriptRoot\jre\bin\java"
	}
}
Catch {}

if ($JAVA -eq "")
{
	Start-BitsTransfer -Source $JreURL -Destination "$PSScriptRoot\java.zip"
	Expand-Archive "$PSScriptRoot\java.zip" -DestinationPath "$PSScriptRoot\jre\"
	Remove-Item "$PSScriptRoot\java.zip"
	Try 
	{
		$Command = Get-Command -Name "$PSScriptRoot\jre\bin\java" -ErrorAction Stop
		if (($Command | Select-Object -ExpandProperty Version).Major -ge 11)
		{
			$JAVA = "$PSScriptRoot\jre\bin\java"
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
	$Command = Get-Command -Name "$PSScriptRoot\git\cmd\git" -ErrorAction Stop
	$GIT = "$PSScriptRoot\git\cmd\git"
}
Catch {}

if ($GIT -eq "")
{
	Start-BitsTransfer -Source $GitURL -Destination "$PSScriptRoot\git.zip"
	Expand-Archive "$PSScriptRoot\git.zip" -DestinationPath "$PSScriptRoot\git\"
	Remove-Item "$PSScriptRoot\git.zip"
	Try 
	{
		$Command = Get-Command -Name "$PSScriptRoot\git\cmd\git" -ErrorAction Stop
		$GIT = "$PSScriptRoot\git\cmd\git"
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
	& "$GIT" reset --hard origin/head
}
elseif (($args[0] -eq "--autoslider") -or ($args[0] -eq "-a")) 
{
	copy -Path "$PSScriptRoot\slider\mirai-login-solver-selenium*" "$PSScriptRoot\plugins\"
	& "$JAVA" -jar mcl.jar
	
}
elseif (($args[0] -eq "--slider") -or ($args[0] -eq "-s")) 
{
	del -Path "$PSScriptRoot\plugins\mirai-login-solver-selenium*"
	& "$JAVA" -Dmirai.slider.captcha.supported -jar mcl.jar
}
else
{
	del -Path "$PSScriptRoot\plugins\mirai-login-solver-selenium*"
	& "$JAVA" -jar mcl.jar
}

