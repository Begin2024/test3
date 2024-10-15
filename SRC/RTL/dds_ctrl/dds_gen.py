

# 文件会在退出 "with" 代码块时自动关闭
# 定义数组
data_array = ['0,' for _ in range(736)] + ['1024,' for _ in range(144)] + ['16383,' for _ in range(144)]

# 打开一个文件，如果不存在则创建
with open('D:\FPGA\ins_2d5_pmsa\Pro_ectype\FPGA-ins_2d5lvs-6305f499d5ea2a281cea50600941cfc2383cc5b2\ins_2d5lvs\ins_2d5lvs.srcs\SRC\RTL\dds_ctrl\dds_gen.txt', 'w') as file:
    # 遍历数组，将每个元组写入文件
    for item in data_array:
        file.write(f'{item}\n')
