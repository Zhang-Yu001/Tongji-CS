# FileSystem文件系统模拟器

## 项目简介

本项目是一个类 Unix 文件系统的模拟器，支持文件的创建、删除、读写、重命名、目录操作、文件指针定位、文件复制等基本操作。适合操作系统课程实验、文件系统原理学习。

---

## 环境要求

- 操作系统：Windows 10/11
- 编译器：Visual Studio 2019/2022 或支持 C++11 的 g++/clang++
- 推荐内存：2GB 以上

---

## 主要功能
- 支持类 Unix 文件系统的基本操作：文件/目录的创建、删除、打开、关闭、重命名、读写、指针定位等
- 支持目录树显示
- 支持本地文件复制（scp 命令）
- 支持磁盘镜像文件 myDisk.img

---

## 命令行用法

启动后，输入以下命令进行操作：

| 命令 | 说明 |
|------|------|
| `fcreate <filename>` | 创建文件 |
| `fopen <filename>` | 打开文件 |
| `fclose <fd>` | 关闭文件 |
| `fdelete <filename>` | 删除文件/目录 |
| `frename <old> <new>` | 重命名文件/目录 |
| `scp [-u/-d] <from> <to> ` | 在文件系统中上传/下载文件 |
| `fwrite <fd> <infile> <size>` | 从 infile 读取 size 字节写入 fd 文件 |
| `fread <fd> <outfile> <size>` | 从 fd 文件读取 size 字节写入 outfile |
| `fread <fd> std <size>` | 从 fd 文件读取 size 字节输出到屏幕 |
| `fseek <fd> <step> <mode>` | 文件指针定位（mode: begin/cur/end）|
| `cd <dirname>` | 切换当前目录 |
| `ftree <dirname>` | 显示目录树 |
| `scp <src> <dst>` | 复制本地文件到目标路径 |
| `exit` | 退出系统并保存缓存 |

> 其中 fd 为文件描述符，由 `fopen` 返回。

---

## 输入输出说明
- 所有命令均在命令行交互输入。
- 文件内容的输入输出通过本地文件（如 `fwrite` 的 infile，`fread` 的 outfile）或直接输出到屏幕（`std`）。
- 文件系统数据存储在 `myDisk.img` 镜像文件中。

---

## 其他说明
- 项目目录结构：
  - `main.cpp`：主程序，命令行解析
  - `FileSystem.*`：文件系统核心实现
  - `INode.*`：INode 结构与操作
  - `File.*`：文件描述符与进程文件表
  - `CacheManager.*`：缓存管理
  - `SystemCall.*`：系统调用封装
  - `UserCall.*`：用户接口
  - `OpenFileManager.*`：文件表管理
  - `myDisk.img`：磁盘镜像文件
  - 其他辅助文件

- 详细设计和原理请参考 `Readme.txt` 和 `Report.pdf`。

---

## 常见问题
- **磁盘空间不足/缓存池耗尽**：请重启或格式化文件系统。
- **命令无效**：请检查命令拼写，或输入 `help` 查看支持命令。
- **文件读写异常**：请确保输入输出文件路径正确，且有读写权限。


