import os
import shutil


def remove_files(*files):
    for file in files:
        if os.path.exists(file):
            if os.path.isfile(file):
                os.remove(file)
            else:
                shutil.rmtree(file)

    return True


def touch(*files):
    for file in files:
        with open(file, "w") as f:
            f.write("")

    return True
