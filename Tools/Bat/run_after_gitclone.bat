chcp 65001 > nul

@echo off
setlocal enabledelayedexpansion

call revision_update_usetobat.bat

echo 当前工作目录：%CD%
dir /B
cd..
rem 设置源文件夹路径
set SOURCE_FOLDER=%CD%
cd..
echo 当前工作目录：%CD%

rem 获取.git根目录绝对路径
set "currentDir=%CD%"
rem 获取当前工作目录下SRC/RTL/top/名字
set "topFolderName=!currentDir!\SRC\RTL\top"

rem 在目录 %topFolderName% 下查找文件名包含 '_top' 且扩展名为 '.v' 或 '.vhdl' 的文件
set "last_processed_file_name="

for /r %topFolderName% %%i in (*_top*.v * _top*.vhdl) do (
    set "full_path=%%i"

    REM 获取文件名部分
    for %%F in (!full_path!) do set "file_name=%%~nF"

    REM 删除文件名中的 '_top'，并判断扩展名
    set "new_file_name=!file_name:_top=!"

    if /i "%%~xi"==".v" (
        echo 找到 .v 文件: !full_path!
        echo 处理后的文件名: !new_file_name!
        set "project_name=!new_file_name!"
    ) else if /i "%%~xi"==".vhdl" (
        echo 找到 .vhdl 文件: !full_path!
        echo 处理后的文件名: !new_file_name!
        set "project_name=!new_file_name!"
    )
)

echo 查找完成。最后一个处理后的文件名:  %project_name%

rem 以top名字作为工程文件夹的名称
set project=!project_name!

rem 创建文件夹用于新建vivado工程
mkdir  "!project!"
@REM mkdir  "!project!\!project_name!"



@REM -------------------------------设置git_ignore-------------------------------------------

set "file_extension_to_ignore=%folderName%"


rem 检查是否存在.gitignore文件，如果不存在则创建一个新文件
set "gitignore_path=%currentDir%\.gitignore"
if not exist "%gitignore_path%" (
    echo. > "%gitignore_path%"
)
for /f "delims=" %%a in ('type "!gitignore_path!"') do (
    if "%%a" equ "!project_name!" (
        goto :end
    ) else (
        set "addflag=true"
    )

)
if "!addflag!"=="true" (
    goto :add
)

:add
echo !project_name!> "!gitignore_path!.tmp"
type "!gitignore_path!" >> "!gitignore_path!.tmp"
move /y "!gitignore_path!.tmp" "!gitignore_path!" >nul

:end








rem 准备工作***********************************

rem 设置.git/hooks路径
set hooks="%currentDir%\.git\hooks"

rem 循环遍历源文件夹及其所有子文件夹下的所有 post- 文件
for /r %SOURCE_FOLDER% %%i in (post-*) do (
    rem 获取每个 post- 文件的文件名（带扩展名）
    set FILE_NAME=%%~nxi

    rem 构建目标文件的完整路径
    set DESTINATION_FILE=%hooks%\!FILE_NAME!

    rem 获取 .tcl 文件的相对路径
    set RELATIVE_PATH=%%~pi

    rem 检查文件路径是否包含目标文件夹
    if not "!RELATIVE_PATH!" == "\%hooks%\" (
        rem 显示正在复制的文件信息
        echo 复制文件: !FILE_NAME!

        rem 使用 copy 命令复制文件
        copy "%%i" !DESTINATION_FILE!
    )
)

rem 设置目标文件夹的相对路径
set DESTINATION_FOLDER="!project!"

rem 循环遍历源文件夹及其所有子文件夹下project_name.tcl 文件
for /r %SOURCE_FOLDER% %%i in (*.tcl) do (
    rem 获取每个 .tcl 文件的文件名（带扩展名）
    set FILE_NAME=%%~nxi

    rem 构建目标文件的完整路径
    set DESTINATION_FILE=%DESTINATION_FOLDER%\!FILE_NAME!

    rem 获取 .tcl 文件的相对路径
    set RELATIVE_PATH=%%~pi

    rem 检查文件路径是否包含目标文件夹
    if not "!RELATIVE_PATH!" == "\%DESTINATION_FOLDER%\" (
        rem 显示正在复制的文件信息
        echo 复制文件: !FILE_NAME!

        rem 使用 copy 命令复制文件
        copy "%%i" !DESTINATION_FILE!
    )
)

rem 切换到工程目录
cd "!DESTINATION_FOLDER!"

rem 设置vivado安装路径
rem 设置vivado安装路径

REM 获取当前脚本文件所在的路径
set "script_path=%~dp0"
set "file_path=!script_path!vivado_path"


if exist "!file_path!" (
    for /F "tokens=*" %%i in ('type "!file_path!"') do (
        set "file_content=%%i"
        REM 使用 dir 命令检查文件是否存在
        dir /b "!file_content!\vivado.bat" > nul 2>&1

        if errorlevel 1 (
            set "inputUser=true"
        ) else (
            set "VIVADO_PATH=!file_content!\vivado.bat"
            set "inputUser=false"
            goto endLoop
        )

    )
) else (
    @REM 如果没有文件就创建
    echo. > "!file_path!"
    goto inputLoop
)

REM 如果文件中没有有效路径就重新输入
if "!inputUser!"=="true" (
    goto inputLoop
) else (
    goto endLoop
)

:inputLoop
set /p "user_input=请输入 vivado.bat 路径 (示例: D:\Xilinx\Vivado\2022.1\bin): "

REM 使用 dir 命令检查文件是否存在
dir /b "!user_input!\vivado.bat" >nul 2>&1

if errorlevel 1 (
    echo 路径下不存在 vivado.bat 文件，请重新输入
    goto inputLoop
) else (
    set "VIVADO_PATH=!user_input!\vivado.bat"
     ::输入到temp文件的第一行 原来的复制到temp 新的内容再覆盖原有的
    echo !user_input!> "!file_path!.tmp"
    type "!file_path!" >> "!file_path!.tmp"
    move /y "!file_path!.tmp" "!file_path!" > nul
)

:endLoop

rem 设置复制后tcl脚本路径
@REM set TCL_SCRIPT_PATH=!project!\create_project.tcl
set TCL_SCRIPT_PATH=!project_name!.tcl
echo 路径: !TCL_SCRIPT_PATH!


rem 调用Vivado启动脚本
"%VIVADO_PATH%" -mode gui -source "%TCL_SCRIPT_PATH%"

endlocal