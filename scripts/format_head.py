import os
import subprocess
import re
import datetime
import argparse

def get_git_creation_time(file_path, repo_root):
    """使用 Git 获取文件的首次提交时间（Windows 兼容）。"""
    try:
        result = subprocess.run(
            ['git', 'log', '--follow', '--format=%aI', '--reverse', '--', file_path],
            capture_output=True,
            text=True,
            encoding='utf-8',
            cwd=repo_root,
            check=True
        )
        lines = result.stdout.strip().split('\n')
        if lines and lines[0]:
            creation_time = datetime.datetime.fromisoformat(lines[0]).strftime('%Y-%m-%d')
            return creation_time
        else:
            print(f"No Git history found for {file_path}")
            return None
    except subprocess.CalledProcessError as e:
        print(f"Error running Git command for {file_path}: {e}")
        return None
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return None

def has_yaml_frontmatter(content):
    """检查文件是否已有 YAML 前端元数据（--- 开头和结尾）。"""
    return bool(re.match(r'---\n.*?\n---\n', content, re.DOTALL))

def update_md_file(file_path, creation_time):
    """将 Git 首次提交时间写入 Markdown 文件头部，插入 [TOC] 到 YAML 后，并移除其他 [TOC]。"""
    try:
        # 读取文件内容
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # 移除文件中所有 [TOC]
        content = re.sub(r'^\[TOC\]\n*', '', content, flags=re.MULTILINE)

        # 准备新的头部内容（包含 [TOC]）
        new_frontmatter = f"---\ncreated_date: {creation_time}\n---\n\n[TOC]\n\n"

        # 检查是否已有 YAML 前端元数据
        if has_yaml_frontmatter(content):
            # 如果已有 YAML，检查是否包含 created_date
            if 'created_date:' in content:
                print(f"Skipping {file_path}: already has created_date")
                return
            else:
                # 在现有 YAML 后添加 created_date 和 [TOC]
                content = re.sub(
                    r'---\n(.*?)\n---\n',
                    f'---\n\\1\ncreated_date: {creation_time}\n---\n\n[TOC]\n\n',
                    content,
                    flags=re.DOTALL
                )
        else:
            # 如果没有 YAML，添加新的前端元数据和 [TOC]
            content = new_frontmatter + content

        # 写回文件
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {file_path} with Git creation time: {creation_time} and inserted [TOC]")

    except Exception as e:
        print(f"Error updating {file_path}: {e}")

def process_md_files(folder_path, target_subdirs=None):
    """
    遍历文件夹，处理 .md 文件，只处理指定子文件夹（若提供）。
    folder_path: Git 仓库根目录路径
    target_subdirs: 指定处理的子文件夹列表（如 ['blockchain']），None 表示所有文件夹
    """
    if not os.path.isdir(folder_path):
        print(f"Error: {folder_path} is not a valid directory")
        return

    # 检查是否为 Git 仓库
    if not os.path.isdir(os.path.join(folder_path, '.git')):
        print(f"Error: {folder_path} is not a Git repository")
        return

    # 规范化 target_subdirs
    if target_subdirs:
        target_subdirs = [os.path.normpath(subdir) for subdir in target_subdirs]
    else:
        target_subdirs = []

    # 遍历文件夹
    for root, _, files in os.walk(folder_path):
        rel_root = os.path.relpath(root, folder_path)
        if target_subdirs and not any(rel_root.startswith(subdir) for subdir in target_subdirs):
            continue

        for file in files:
            if file.lower().endswith('.md'):
                file_path = os.path.join(root, file)
                rel_path = os.path.relpath(file_path, folder_path)
                creation_time = get_git_creation_time(rel_path, folder_path)
                if creation_time:
                    update_md_file(file_path, creation_time)

def main():
    # 设置命令行参数解析
    parser = argparse.ArgumentParser(description="Process Markdown files to add Git creation time and [TOC].")
    parser.add_argument(
        '--repo',
        type=str,
        default=os.path.join(os.path.dirname(__file__), '..', '..', 'ITNote'),
        help="Path to the Git repository (default: ../../ITNote)"
    )
    parser.add_argument(
        '--subdirs',
        nargs='*',
        default=[],
        help="Subdirectories to process (default: all directories)"
    )
    args = parser.parse_args()

    # 规范化 Git 仓库路径
    folder_path = os.path.abspath(args.repo)

    print(f"Processing Markdown files in {folder_path}")
    process_md_files(folder_path, args.subdirs)
    print("Processing complete")

if __name__ == "__main__":
    main()