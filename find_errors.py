import os
import re

start_path = "C:\\Users\\bayram\\Documents\\Klei\\DoNotStarveTogether"
pattern = re.compile(r'LUA ERROR stack traceback:.*', re.DOTALL)

for root, dirs, files in os.walk(start_path):
    for file in files:
        if file in ('master_server_log.txt', 'client_log.txt'):
            with open(os.path.join(root, file), 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                matches = pattern.findall(content)
                for match in matches:
                    print(match)
