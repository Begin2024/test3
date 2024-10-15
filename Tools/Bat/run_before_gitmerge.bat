chcp 65001 > nul

@echo off
setlocal enabledelayedexpansion

echo 当前工作目录：%CD%
dir /B
cd..
rem 设置源文件夹路径
set SOURCE_FOLDER=%CD%
cd..
echo 当前工作目录：%CD%

rem 获取当前工作目录的文件夹名字
set "currentDir=%CD%"
for %%i in ("%currentDir%") do set "folderName=%%~nxi"

echo 当前工作目录: %currentDir%
echo 文件夹名字: %folderName%

rem 设置Release文件夹路径
set "releaseDir=%currentDir%\Release\Update"
set "readmeFile=!releaseDir!\Readme.txt"


rem 新建 Release\Update 文件夹
if not exist "%releaseDir%" mkdir "%releaseDir%"

rem 清空或新建 Readme.txt 文件
type nul > "%readmeFile%"
echo Readme.txt 已清空或新建成功
echo 当前工作目录：%CD%



rem 获取提交次数
for /f %%b in ('git rev-list --count HEAD') do set "commitCount=%%b"

rem 获取修改日志
@REM git log --pretty=format:"%h - %s (%an)" > "%readmeFile%"









rem 获取当前版本号
for /f %%i in ('git rev-parse HEAD') do set version=%%i

for /f %%r in ('git rev-list --count HEAD') do set "seqnum=%%r"

rem 获取当前版本的修改日志并存放到变量
for /f "delims=" %%a in ('git log -1 --pretty^=oneline:%%s') do set "commitMessage=%%a"

rem 打印日志到控制台
echo 提交信息: !commitMessage!


rem 获取提交时间
git log -1 --format="%%ci"
for /f "delims=" %%i in ('git log -1 --format^="%%ci"') do set "commit_time=%%i"

rem 获取当前分支
for /f "tokens=*" %%a in ('git symbolic-ref -q --short HEAD') do set "currentBranch=%%a"

if not defined currentBranch (
    echo 处于分离头状态，没有活跃的分支。
) else (
    echo 当前分支: %currentBranch%
)



echo 最近 10 次提交信息：%commit_history%
@REM for /f "delims=" %%i in ('git log -10 --pretty=short') do set "commit_history=%%i"

rem 写入 Readme.txt 文件
echo 当前版本串号:     %version%          >> "%readmeFile%"
echo 当前版本上传次数: %seqnum%           >> "%readmeFile%"
echo 当前版本上传时间: %commit_time%      >> "%readmeFile%"
echo 当前版本修改日志: %commitMessage:~8% >> "%readmeFile%"
echo:   >> "%readmeFile%"
echo Commit_history:                     >> "%readmeFile%"
echo:   >> "%readmeFile%"
@REM echo 提交历史:         !commit_history!  >> "%readmeFile%"

set /

REM 获取以往10此 log 信息
for /f "tokens=*" %%i in ('call git log -10 ') do (
    @REM set "commit_history=!commit_history!%%i"
    echo %%i  >> "%readmeFile%"
    @REM echo:   >> "%readmeFile%"
)

@REM echo 上传次数: %commitCount% >> "%readmeFile%"





rem 设置Update路径
set update="%currentDir%\Release\Update"

rem 设置工程路径
set project="%currentDir%\%folderName%"

rem 循环遍历源文件夹及其所有子文件夹下的所有 post- 文件
for /r %project% %%i in (*.bin *.bit *.ltx *.xsa) do (
    rem 获取每个 post- 文件的文件名（带扩展名）
    set FILE_NAME=%%~nxi

    rem 构建目标文件的完整路径
    set DESTINATION_FILE=%update%\!FILE_NAME!

    rem 获取 .tcl 文件的相对路径
    set RELATIVE_PATH=%%~pi

    rem 检查文件路径是否包含目标文件夹
    if not "!RELATIVE_PATH!" == "\%update%\" (
        rem 显示正在复制的文件信息
        echo 复制文件: !FILE_NAME!

        rem 使用 copy 命令复制文件
        copy "%%i" !DESTINATION_FILE!
    )
)





echo 写入成功，请查看 Readme.txt 文件。


endlocal