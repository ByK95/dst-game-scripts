import os
import shutil

def delete_dir_contents(directory):
    for item in os.listdir(directory):
        item_path = os.path.join(directory, item)
        if os.path.isfile(item_path):
            os.remove(item_path)
        elif os.path.isdir(item_path):
            shutil.rmtree(item_path)

def copy_files(source_dir, destination_dir):
    for root, _, files in os.walk(source_dir):
        for file in files:
            source_path = os.path.join(root, file)
            destination_path = os.path.join(destination_dir, os.path.relpath(source_path, source_dir))
            os.makedirs(os.path.dirname(destination_path), exist_ok=True)
            
            if os.path.exists(destination_path):
                os.remove(destination_path)
            
            shutil.copy2(source_path, destination_path)

# Your script setup
script_directory = os.path.dirname(os.path.abspath(__file__))
source_directory = os.path.join(script_directory, '_scripts')
destination_directory = "D:\\SteamLibrary\\steamapps\\common\\Don't Starve Together\\mods\\init"

# Delete contents of destination directory first
delete_dir_contents(destination_directory)

# Then copy the files
copy_files(source_directory, destination_directory)
