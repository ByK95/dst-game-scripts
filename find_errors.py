import os
import re

start_path = "C:\\Users\\bayram\\Documents\\Klei\\DoNotStarveTogether"
error_pattern = re.compile(r'LUA ERROR stack traceback:.*', re.DOTALL)
mod_init_pattern = re.compile(r'Mod: init[^\n]*', re.DOTALL)

for root, dirs, files in os.walk(start_path):
    for file in files:
        if file in ('master_server_log.txt', 'client_log.txt'):
            with open(os.path.join(root, file), 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                error_matches = error_pattern.findall(content)
                mod_init_matches = mod_init_pattern.findall(content)
                
                for match in error_matches:
                    print("Error Match:", match)
                    
                for match in mod_init_matches:
                    print("# Mod: init Match:", match)
