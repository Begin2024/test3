import os

current_directory = os.getcwd()
print("当前工作目录:", current_directory)

# 文件会在退出 "with" 代码块时自动关闭
# 定义数组
data_array = ['0,' for _ in range(736)] + ['1024,' for _ in range(144)] + ['16383,' for _ in range(144)]

# data_array = [str(item) for item in data_array]
# data_coe = data_head + ''.join(data_array)

# 打开一个文件，如果不存在则创建
with open('dds_wave.coe', 'w') as file:
    # 遍历数组，将每个元组写入文件
    for item in data_array:
        file.write(f'{item}\n')

data_head = '''memory_initialization_radix=10;
memory_initialization_vector=
'''

# 打开文件并读取内容
with open('dds_wave.coe', 'r') as file:
    file_content = file.read()

data_coe = data_head + file_content

# 再次打开文件，以写入模式覆盖原始内容
with open('dds_wave.coe', 'w') as file:
    file.write(data_coe)