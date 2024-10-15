'''
Author       : Pengfei.Zhou  --  pengfei.zhou@insnex.com
Date         : 2023-12-07 11:31:13
LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
LastEditTime : 2024-01-30 10:59:35
FilePath     : instance.py
Description  : ---
Copyright (c) 2023 by Insnex.com, All Rights Reserved.
'''
import re
import os
# import pyperclip
# import pyautogui
# import time
def get_verilog_files():
    current_directory = os.getcwd()  # 获取当前工作目录
    # print(current_directory)
    verilog_files = [file for file in os.listdir(current_directory) if file.endswith(".v")]
    return verilog_files

def instantiate_verilog_module(module_name, instance_name, ports):
    instantiation_template = f'{module_name} {instance_name} (\n {ports});'
    return instantiation_template

def main():
    # # 读取原始 Verilog 文件
    # current_directory = os.getcwd()
    # verilog_files = [file for file in os.listdir(current_directory) if file.endswith(".v")]
    verilog_directory = r'E:\RZZ\LDOF_2500\LDOF_2500\SRC\RTL\sensor_driver\trigger\trigger_ctrl.v'
    # print(verilog_directory)
    with open(verilog_directory, 'r', encoding='utf-8', errors='ignore') as f:
        verilog_code = f.read()
    # verilog_code = get_selected_text()
    # 提取模块定义
    module_pattern = re.compile(r'module\s+(\w+)\s*\((.*?)\);', re.DOTALL)
    matches = module_pattern.findall(verilog_code)

    # 遍历每个找到的模块
    for module_match in matches:
        module_name = module_match[0]
        ports = module_match[1]

        # 构建信号连接字符串
        signals = re.findall(r'\s*(\w+)\s*,', ports)
        connections = ",\n ".join([f'.{signal}({signal})' for signal in signals])

        # 生成实例化语句
        instance_name = f'{module_name}_inst'
        instantiation = instantiate_verilog_module(module_name, instance_name, connections)

        # 输出实例化语句到控制台
        print(instantiation)

if __name__ == "__main__":
    main()
