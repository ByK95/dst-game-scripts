import os
import zipfile
from dotenv import load_dotenv

load_dotenv()

def unzip_selected_files(src_folder, dest_folder, filenames_to_unzip):
    for filename in filenames_to_unzip:
        zip_path = os.path.join(src_folder, filename)
        if os.path.exists(zip_path):
            # Create a new directory named after the ZIP file
            new_dest_folder = os.path.join(dest_folder, os.path.splitext(filename)[0])
            os.makedirs(new_dest_folder, exist_ok=True)
            
            # Unzip the ZIP file into the new directory
            with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                zip_ref.extractall(new_dest_folder)
                
            print(f"Unzipped {filename} into {new_dest_folder}")
        else:
            print(f"{filename} not found.")

if __name__ == "__main__":
    current_directory = os.getcwd()
    src_folder = os.path.join(os.getenv("DST_GAME_PATH"), 'data', 'anim')
    dest_folder =  os.path.join(current_directory, 'bundle')
    filenames = ['rocky', 'armor_ruins', 'gems']
    filenames_to_unzip = ["{}.zip".format(filename) for filename in filenames]

    unzip_selected_files(src_folder, dest_folder, filenames_to_unzip)
    
