import argparse
from collections import deque
import os
import re

def tail(filename, n=20):
    with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
        return list(deque(f, n))

def print_side_by_side(lines):
    max_length = 70
    for i in range(0, len(lines), 2):
        line1 = lines[i].strip()[:max_length]
        
        if i+1 < len(lines):
            line2 = lines[i+1].strip()[:max_length]
            if len(line1) + len(line2) + 4 <= max_length * 2:
                print(f"{line1.ljust(max_length)}    {line2}")
            else:
                print(line1)
                print(line2)
        else:
            print(line1)

parser = argparse.ArgumentParser()
parser.add_argument('--tail', type=int, help='Number of lines to tail')
args = parser.parse_args()

start_path = "C:\\Users\\bayram\\Documents\\Klei\\DoNotStarveTogether"
error_pattern = re.compile(r'LUA ERROR stack traceback:.*', re.DOTALL)
mod_init_pattern = re.compile(r'Mod: init[^\n]*', re.DOTALL)

for root, dirs, files in os.walk(start_path):
    for file in files:
        if file in ('master_server_log.txt', 'client_log.txt'):
            file_path = os.path.join(root, file)
            
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                
            if args.tail:
                print(f"===================== {file} ====================")
                last_lines = tail(file_path, args.tail)
                print_side_by_side(last_lines)
            else:
                error_matches = error_pattern.findall(content)
                mod_init_matches = mod_init_pattern.findall(content)
                
                for match in error_matches:
                    print("Error Match:", match)
                    
                for match in mod_init_matches:
                    print("# Mod: init Match:", match)
