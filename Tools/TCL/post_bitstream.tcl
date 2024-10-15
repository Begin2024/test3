# 获取当前工作目录
set project_directory [pwd]

# 打印当前工作目录到控制台
puts "当前工作目录：$project_directory"

# 拼接 log.txt 文件路径
set log_file_path "$project_directory/ccclog.txt"

# 检查文件是否存在，如果不存在则创建
if {![file exists $log_file_path]} {
    set log_file [open $log_file_path w]
    close $log_file
}

# 打开 log.txt 文件，以追加的方式写入当前工作目录
set log_file [open $log_file_path a]
puts $log_file "当前工作目录：$project_directory"
close $log_file

# 由于此时工作目录在imp_1文件夹下，需要向上跳三级目录
cd ..
cd ..
cd ..

# 获取当前工作目录
set current_directory [pwd]

# 获取项目名称
set project_name [file tail $current_directory]

# 打印当前目录到控制台
puts $current_directory

# 构建项目的 top 名称
set project_top ${project_name}_top

# 打印项目名称到控制台
puts $project_top

# write_project_tcl -all_properties -no_copy_sources -use_bd_files -force $current_directory/$project_name.tcl

write_hw_platform -fixed -include_bit -force -file $current_directory/$project_top.xsa

# 构建目标文件路径
set tcl_file_path "$current_directory/$project_name.tcl"

# 复制生成的 .tcl 文件到父目录的 Tools/TCL 文件夹
set tools_tcl_folder "$current_directory/../Tools/TCL"
file mkdir $tools_tcl_folder
file copy -force $tcl_file_path $tools_tcl_folder

cd $project_directory

