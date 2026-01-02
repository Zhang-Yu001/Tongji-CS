import re

# 定义文件路径
file_paths = [
    "data/US3800003.txt",
    "data/US3800000.txt",
    "data/US3800001.txt",
    "data/US3800002.txt",
]

# 初始化一个列表来存储找到的时间戳
timestamps = []

# 定义正则表达式，用于匹配时间戳
timestamp_pattern = r"\b(?:[A-Z][a-z]{2}\.\s\d{1,2},\s\d{4}|\d{1,4}[°°]-\d{1,4}[°°]\s?[CF])\b"

# 遍历文件并提取时间戳
for path in file_paths:
    try:
        # 打开文件并读取内容
        with open(path, 'r', encoding='utf-8', errors='ignore') as file:
            content = file.read()
            # 使用正则表达式查找时间戳
            matches = re.findall(timestamp_pattern, content)
            # 将匹配结果存入列表
            timestamps.extend(matches)
    except Exception as e:
        print(f"读取文件 {path} 时出错: {e}")

# 输出所有找到的时间戳
print("找到的时间戳：")
for timestamp in timestamps:
    print(timestamp)
