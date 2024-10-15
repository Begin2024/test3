chcp 65001 > nul

@echo off
setlocal enabledelayedexpansion

echo 当前工作目录：%CD%
dir /B
cd..
cd..
echo 当前工作目录：%CD%

rem 获取当前版本号
for /f %%i in ('git rev-parse HEAD') do set version=%%i

for /f %%r in ('git rev-list --count HEAD') do set "seqnum=%%r"

rem 将十进制序列号转换为十六进制并确保结果是四位数字
set /A "seqnum=seqnum & 0xFFFF"
set seqnum=0000%seqnum%
set seqnum=!seqnum:~-4!

rem 获取提交时间
git log -1 --format="%%ci"
for /f "delims=" %%i in ('git log -1 --format^="%%ci"') do set "commit_time=%%i"

rem 解析 git 提交时间的年、月、日、时、分
for /f "tokens=1-5 delims=- " %%a in ("!commit_time!") do (
    set "year=%%a"
    set "month=%%b"
    set "day=%%c"
    set "time=%%d"
    @REM set "minute=%%e"
)

rem 将时分秒和时区拆分
for /f "tokens=1-3 delims=:" %%g in ("!time!") do (
    set "hour=%%g"
    set "minute=%%h"
    set "second=%%i"
)

echo 当前版本号：%version%
echo 提交时间：%commit_time%

set "REV=SRC\RTL\top\revision.h"

type nul > "!REV!" rem 清空文件内容

rem 添加多行新内容

echo `define YEAR    16'h!year! >> "!REV!"
echo `define MONTH   8'h!month!    >> "!REV!"
echo `define DATE    8'h!day!    >> "!REV!"
echo `define HOUR    16'h!hour!   >> "!REV!"
echo `define MINUTE  16'h!minute!   >> "!REV!"
echo `define HASH    16'h!version:~0,4! >> "!REV!"
echo `define SEQNUM  16'd!seqnum! >> "!REV!"


endlocal
