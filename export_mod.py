import os
import shutil

def copy_files(source_dir, destination_dir):
    # Iterate through all files and subdirectories in the source directory
    for root, _, files in os.walk(source_dir):
        for file in files:
            source_path = os.path.join(root, file)
            destination_path = os.path.join(destination_dir, os.path.relpath(source_path, source_dir))

            # Create the directory structure in the destination if it doesn't exist
            os.makedirs(os.path.dirname(destination_path), exist_ok=True)

            # Check if the file in the destination directory exists, and if so, delete it
            if os.path.exists(destination_path):
                os.remove(destination_path)

            # Copy the file from the source to the destination directory
            shutil.copy2(source_path, destination_path)

script_directory = os.path.dirname(os.path.abspath(__file__))
source_directory = os.path.join(script_directory, '_scripts')
destination_directory = "D:\\SteamLibrary\\steamapps\\common\\Don't Starve Together\\mods\\init"

copy_files(source_directory, destination_directory)
