'''
Author       : Pengfei.Zhou  --  pengfei.zhou@insnex.com
Date         : 2023-12-13 13:20:58
LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
LastEditTime : 2024-01-18 19:45:41
FilePath     : debug_test.py
Description  : ---
Copyright (c) 2023 by Insnex.com, All Rights Reserved.
'''
import re

input_text = """
    reg [31:0] cnt_camera_cycle         ;
    reg [31:0] cnt_camera_delay         ;



    reg [31:0] cnt_trig_in_cycle        ;
    reg [31:0] cnt_camera_trig_num      ;

    reg         trig_in_flag            ;

    reg         delay_flag              ;
    reg [31:0]  cnt_pic_num             ;
    reg [1:0]   trigger_in_dly          ;
    reg [1:0]   trig_to_camera_dly      ;
    wire [31:0] trig_in_cycle;
    input [31:0] reg_camera_cycle               ,
    input [31:0] reg_camera_delay               ,//相机收到触发后一段时间曝光开始
    input [31:0] reg_camera_trig_num            ,
    output reg   trig_to_camera                 ,
    output reg   trig_to_core
"""
pattern = r"(reg|wire)(?:\s*)?(?:(\[\d+\:\d+\]))?(?:\s*)?([a-zA-Z][a-zA-Z0-9_]*)"

matches = re.finditer(pattern, input_text)

# Store matches in a list for later use
match_list = list(matches)
debug_list = []
print("\n输出文本:")
for match in match_list:
    # name = 'reg' + '    ' + (match.group(2) if match.group(2) else '') + '    ' + 'debug_' + match.group(3) + ';'
    name = '(* mark_debug = "true" *)' + 'reg' + (' ' + match.group(2) if match.group(2) else '') + ' debug_' + match.group(3) + ';'
    debug_signal = ' debug_' + match.group(3) + ' <= ' + match.group(3) + ';' + '\n'
    debug_list.append(debug_signal)
    print(name)

# Now you can get the length
length = len(match_list)
# print(length)
always = 'always@(posedge clk)begin \n'
temp = ''.join(debug_list)
debug = always + temp + 'end'
print(debug)