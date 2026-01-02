#define _CRT_SECURE_NO_WARNINGS
#include "DiskDriver.h"
#include "CacheManager.h"
#include "OpenFileManager.h"
#include "SystemCall.h"
#include "UserCall.h"
#include <iostream>
#include <sstream>
#include <unordered_map>
using namespace std;

DiskDriver myDiskDriver;
CacheManager myCacheManager;
OpenFileTable myOpenFileTable;
SuperBlock mySuperBlock;
FileSystem myFileSystem;
INodeTable myINodeTable;
SystemCall mySystemCall;
UserCall myUserCall;

int main() 
{
	UserCall& User = myUserCall;
	
	// 清屏并显示欢迎界面
	system("cls");
	
	cout << "\033[1;36m"; // 青色加粗
	cout << "╔══════════════════════════════════════════════════════════════════════════════╗" << endl;
	cout << "║                                                                              ║" << endl;
	cout << "║                           类Unix文件系统模拟器                               ║" << endl;
	cout << "║                                                                              ║" << endl;
	cout << "║                       基于C++实现的文件系统实验项目                          ║" << endl;
	cout << "║                                                                              ║" << endl;
	cout << "╚══════════════════════════════════════════════════════════════════════════════╝" << endl;
	cout << "\033[0m"; // 重置颜色
	
	cout << "\n\033[1;33m 系统功能概览:\033[0m\n";
	cout << "┌──────────────────────────────────────────────────────────────────────────────┐" << endl;
	cout << "│ \033[1;32m 文件管理\033[0m │ 创建、删除、重命名文件和目录                                     │" << endl;
	cout << "│ \033[1;32m 目录操作\033[0m │ 浏览、切换、查看目录结构和内容                                   │" << endl;
	cout << "│ \033[1;32m 文件I/O\033[0m  │ 读写文件、文件指针定位、缓存管理                                 │" << endl;
	cout << "│ \033[1;32m 系统管理\033[0m │ 格式化、自动测试、系统状态监控                                   │" << endl;
	cout << "└──────────────────────────────────────────────────────────────────────────────┘" << endl;
	
	cout << "\n\033[1;34m 详细命令列表:\033[0m\n";
	cout << "┌──────────────────────────────────────────────────────────────────────────────┐" << endl;
	cout << "│ \033[1;33m基础命令:\033[0m                                                                    │" << endl;
	cout << "│   help <op_name>              - 命令提示                                     │" << endl;
	cout << "│   fformat                     - 格式化文件系统                               │" << endl;
	cout << "│   exit                        - 退出系统                                     │" << endl;
	cout << "│                                                                              │" << endl;
	cout << "│ \033[1;33m目录操作:\033[0m                                                                    │" << endl;
	cout << "│   ls                          - 查看当前目录内容                             │" << endl;
	cout << "│   mkdir <dirname>             - 创建目录                                     │" << endl;
	cout << "│   cd <dirname>                - 切换目录                                     │" << endl;
	cout << "│   ftree <dirname>             - 显示目录树                                   │" << endl;
	cout << "│                                                                              │" << endl;
	cout << "│ \033[1;33m文件操作:\033[0m                                                                    │" << endl;
	cout << "│   fcreate <filename>          - 创建文件                                     │" << endl;
	cout << "│   fopen <filename>            - 打开文件                                     │" << endl;
	cout << "│   fclose <fd>                 - 关闭文件                                     │" << endl;
	cout << "│   fdelete <filename>          - 删除文件/目录                                │" << endl;
	cout << "│   frename <old> <new>         - 重命名文件/目录                              │" << endl;
	cout << "│   scp [-u/-d] <from> <to>     - 在文件系统中上传/下载文件                    │" << endl;
	cout << "│                                                                              │" << endl;
	cout << "│ \033[1;33m文件I/O:\033[0m                                                                     │" << endl;
	cout << "│   fwrite <fd> <infile> <size> - 写入文件                                     │" << endl;
	cout << "│   fread <fd> <outfile> <size> - 读取文件                                     │" << endl;
	cout << "│   fread <fd> std <size>       - 读取到屏幕                                   │" << endl;
	cout << "│   fseek <fd> <step> <mode>    - 文件指针定位                                 │" << endl;
	cout << "│     mode: begin/cur/end                                                      │" << endl;
	cout << "└──────────────────────────────────────────────────────────────────────────────┘" << endl;
	
	cout << "\n\033[1;32m 系统已启动，开始您的文件系统之旅吧！\033[0m\n";

	string line, opt, val[3];
	while (true) 
	{
		cout << "\033[1;36m[FileSystem " << User.curDirPath << "]\033[0m \033[1;32m$\033[0m ";
		getline(cin, line);
		if (line.size() == 0) 
			continue;

		stringstream in(line);
		in >> opt;
		val[0] = val[1] = val[2] = "";
		
		//格式化文件系统
		if (opt == "fformat") {
			cout << "\033[1;33m  警告: 即将格式化文件系统，所有数据将被清除！\033[0m\n";
			cout << "确认格式化(Y/N): ";
			string confirm;
			getline(cin, confirm);
			if (confirm == "y" || confirm == "Y") {
				cout << "\033[1;31m 正在格式化文件系统...\033[0m\n";
				myOpenFileTable.Reset();
				myINodeTable.Reset();
				myCacheManager.FormatBuffer();
				myFileSystem.FormatDevice();
				cout << "\033[1;32m 格式化完成！文件系统已重置，请重新启动程序。\033[0m\n";
				return 0;
			} else {
				cout << "\033[1;34m 格式化操作已取消。\033[0m\n";
			}
		}
		//查看当前目录内容
		else if (opt == "ls") {
			cout << "\033[1;34m 当前目录内容:\033[0m\n";
			User.userLs();
		}
		//生成文件夹
		else if (opt == "mkdir") {
			in >> val[0];
			if (val[0][0] != '/')
				val[0] = User.curDirPath + val[0];
			cout << "\033[1;33m 创建目录: " << val[0] << "\033[0m\n";
			User.userMkDir(val[0]);
		}
		//进入目录
		else if (opt == "cd") {
			in >> val[0];
			cout << "\033[1;33m 切换目录: " << val[0] << "\033[0m\n";
			User.userCd(val[0]);
		}
		//创建文件名为filename的文件
		else if (opt == "fcreate") {
			in >> val[0];
			if (val[0][0] != '/')
				val[0] = User.curDirPath + val[0];
			cout << "\033[1;33m 创建文件: " << val[0] << "\033[0m\n";
			User.userCreate(val[0]);
		}
		//打开文件名为filename的文件
		else if (opt == "fopen") {
			in >> val[0];
			if (myUserCall.ar0[UserCall::EAX] == 0) {
				User.userMkDir("demo");
				User.userDelete("demo");
			}
			if (val[0][0] != '/')
				val[0] = User.curDirPath + val[0];
			cout << "\033[1;33m 打开文件: " << val[0] << "\033[0m\n";
			User.userOpen(val[0]);
		}
		//退出系统，并将缓存内容存至磁盘
		else if (opt == "exit") {
			cout << "\033[1;33m 正在保存缓存并退出系统...\033[0m\n";
			cout << "\033[1;32m 感谢使用类Unix文件系统模拟器！\033[0m\n";
			return 0;
		}
		//关闭文件句柄为fd的文件
		else if (opt == "fclose") {
			in >> val[0];
			cout << "\033[1;33m 关闭文件句柄: " << val[0] << "\033[0m\n";
			User.userClose(val[0]);
		}
		else if (opt == "fseek") {
			in >> val[0] >> val[1] >> val[2];
			cout << "\033[1;33m 文件指针定位: 句柄=" << val[0] << " 偏移=" << val[1] << " 模式=" << val[2] << "\033[0m\n";
			//以begin模式把fd文件指针偏移step
			if (val[2] == "begin")
				User.userSeek(val[0], val[1], string("0"));
			//以cur模式把fd文件指针偏移step
			else if (val[2] == "cur")
				User.userSeek(val[0], val[1], string("1"));
			//以end模式把fd文件指针偏移step
			else if (val[2] == "end")
				User.userSeek(val[0], val[1], string("2"));
		}
		//从fd文件读取size字节，输出到outfile
		//从fd文件读取size字节，输出到屏幕
		else if (opt == "fread") {
			in >> val[0] >> val[1] >> val[2];
			cout << "\033[1;33m 读取文件: 句柄=" << val[0] << " 输出=" << val[1] << " 大小=" << val[2] << "\033[0m\n";
			User.userRead(val[0], val[1], val[2]);
		}
		//从infile输入，写入fd文件size字节
		else if (opt == "fwrite") {
			in >> val[0] >> val[1] >> val[2];
			cout << "\033[1;33m  写入文件: 句柄=" << val[0] << " 输入=" << val[1] << " 大小=" << val[2] << "\033[0m\n";
			User.userWrite(val[0], val[1], val[2]);
		}
		//删除文件文件名为filename的文件或者文件夹
		else if (opt == "fdelete") {
			in >> val[0];
			if (val[0][0] != '/')
				val[0] = User.curDirPath + val[0];
			cout << "\033[1;33m  删除: " << val[0] << "\033[0m\n";
			User.userDelete(val[0]);
		}
		//重命名文件或文件夹
		else if (opt == "frename") {
			in >> val[0] >> val[1];
			cout << "\033[1;33m 重命名: " << val[0] << " → " << val[1] << "\033[0m\n";
			User.userRename(val[0], val[1]);
		}
		else if (opt == "ftree") {
			in >> val[0];
			cout << "\033[1;34m 目录树: " << val[0] << "\033[0m\n";
			User.userTree(val[0]);
		}
		else if (opt == "help") {
			in >> val[0];
			if (val[0] == "") {
				cout << "\033[1;35m 命令帮助手册:\033[0m\n";
				cout << "┌──────────────────────────────────────────────────────────────────────────────┐" << endl;
				cout << "│ \033[1;33m基础命令:\033[0m                                                                    │" << endl;
				cout << "│   help <op_name>              - 命令提示                                     │" << endl;
				cout << "│   fformat                     - 格式化文件系统                               │" << endl;
				cout << "│   exit                        - 退出系统                                     │" << endl;
				cout << "│                                                                              │" << endl;
				cout << "│ \033[1;33m目录操作:\033[0m                                                                    │" << endl;
				cout << "│   ls                          - 查看当前目录内容                             │" << endl;
				cout << "│   mkdir <dirname>             - 创建目录                                     │" << endl;
				cout << "│   cd <dirname>                - 切换目录                                     │" << endl;
				cout << "│   ftree <dirname>             - 显示目录树                                   │" << endl;
				cout << "│                                                                              │" << endl;
				cout << "│ \033[1;33m文件操作:\033[0m                                                                    │" << endl;
				cout << "│   fcreate <filename>          - 创建文件                                     │" << endl;
				cout << "│   fopen <filename>            - 打开文件                                     │" << endl;
				cout << "│   fclose <fd>                 - 关闭文件                                     │" << endl;
				cout << "│   fdelete <filename>          - 删除文件/目录                                │" << endl;
				cout << "│   frename <old> <new>         - 重命名文件/目录                              │" << endl;
				cout << "│   scp [-u/-d] <from> <to>     - 在文件系统中上传/下载文件                    │" << endl;
				cout << "│                                                                              │" << endl;
				cout << "│ \033[1;33m文件I/O:\033[0m                                                                     │" << endl;
				cout << "│   fwrite <fd> <infile> <size> - 写入文件                                     │" << endl;
				cout << "│   fread <fd> <outfile> <size> - 读取文件                                     │" << endl;
				cout << "│   fread <fd> std <size>       - 读取到屏幕                                   │" << endl;
				cout << "│   fseek <fd> <step> <mode>    - 文件指针定位                                 │" << endl;
				cout << "│     mode: begin/cur/end                                                      │" << endl;
				cout << "└──────────────────────────────────────────────────────────────────────────────┘" << endl;
			}
			else if (val[0] == "fformat")
				cout << "\033[1;33m[命令]: fformat\033[0m - 格式化文件系统，清除所有数据\n";
			else if (val[0] == "ls")
				cout << "\033[1;33m[命令]: ls\033[0m - 查看当前目录内容\n";
			else if (val[0] == "mkdir")
				cout << "\033[1;33m[命令]: mkdir <dirname>\033[0m - 创建新目录\n";
			else if (val[0] == "cd")
				cout << "\033[1;33m[命令]: cd <dirname>\033[0m - 切换当前目录\n";
			else if (val[0] == "fcreate")
				cout << "\033[1;33m[命令]: fcreate <filename>\033[0m - 创建新文件\n";
			else if (val[0] == "fopen")
				cout << "\033[1;33m[命令]: fopen <filename>\033[0m - 打开文件\n";
			else if (val[0] == "fwrite")
				cout << "\033[1;33m[命令]: fwrite <fd> <infile> <size>\033[0m - 从infile读取数据写入文件\n";
			else if (val[0] == "fread")
				cout << "\033[1;33m[命令]: fread <fd> <outfile> <size>\033[0m - 从文件读取数据到outfile\n"
				<< "\033[1;33m[命令]: fread <fd> std <size>\033[0m - 从文件读取数据到屏幕\n";
			else if (val[0] == "fseek")
				cout << "\033[1;33m[命令]: fseek <fd> <step> begin\033[0m - 从文件开头偏移\n"
				<< "\033[1;33m[命令]: fseek <fd> <step> cur\033[0m - 从当前位置偏移\n"
				<< "\033[1;33m[命令]: fseek <fd> <step> end\033[0m - 从文件末尾偏移\n";
			else if (val[0] == "fclose")
				cout << "\033[1;33m[命令]: fclose <fd>\033[0m - 关闭文件句柄\n";
			else if (val[0] == "fdelete")
				cout << "\033[1;33m[命令]: fdelete <filename>\033[0m - 删除文件或目录\n";
			else if (val[0] == "frename")
				cout << "\033[1;33m[命令]: frename <filename> <filename1>\033[0m - 重命名文件或目录\n";
			else if (val[0] == "ftree")
				cout << "\033[1;33m[命令]: ftree <dirname>\033[0m - 显示目录树结构\n";
			else if (val[0] == "exit")
				cout << "\033[1;33m[命令]: exit\033[0m - 退出系统并保存缓存\n";
			else if (val[0] == "scp")
				cout << "\033[1;33m[命令]: scp <src> <dst>\033[0m - 复制文件到目标路径\n";
			else
				cout << "\033[1;31m 未知命令: " << val[0] << "\033[0m\n";
		}

		else {
			cout << "\033[1;31m 未知命令: " << opt << "\033[0m\n";
			cout << "\033[1;34m 输入 'help' 查看可用命令\033[0m\n";
		}
	}
	return 0;
}