import os
import re

# 定义文件夹路径（将此路径修改为实际文件所在的文件夹路径）
folder_path = "/data"

# 正则表达式匹配时间戳
timestamp_pattern = r"\b(?:[A-Z][a-z]{2}\.\s\d{1,2},\s\d{4}|\d{1,4}[°°]-\d{1,4}[°°]\s?[CF])\b"

# 初始化存储所有结果的列表
timestamps_with_files = []

# 遍历文件夹中的所有文件
for file_name in os.listdir(folder_path):
    file_path = os.path.join(folder_path, file_name)
    # 检查是否为文件
    if os.path.isfile(file_path):
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
                content = file.read()
                # 查找匹配的时间戳
                matches = re.findall(timestamp_pattern, content)
                # 将文件名和时间戳配对后存储
                timestamps_with_files.extend([(file_name, match) for match in matches])
        except Exception as e:
            print(f"读取文件 {file_name} 时出错: {e}")

# 输出结果
print("找到的时间戳及其所属文件：")
for file_name, timestamp in timestamps_with_files:
    print(f"文件: {file_name} => 时间戳: {timestamp}")
