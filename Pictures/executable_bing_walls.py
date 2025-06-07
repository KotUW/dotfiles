#!/usr/bin/env python3
import os
from urllib.request import urlretrieve, urlopen
import json

num_of_images = 10
api_url = f"http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n={num_of_images}&mkt=en-CA"

home = os.getenv("HOME")
cache_path: str = ""
save_path: str = ""
if home is not None:
    cache_path = home + "/Pictures/walls.txt"
    save_path = home + "/Pictures/wall/"

if not os.path.exists(save_path):
    print(
        f"save path {save_path} doesn't exist. Please create or change the above variable to it."
    )
if not os.path.exists(cache_path):
    with open(cache_path, "w") as file:
        print("Couldn't find the hash  file\n Assuming first run. creating it.")

hsh_files: list[str] = []
lines: str = ""
with open(cache_path, "r") as fcf:
    lines = fcf.read()
    fcf.close()

if len(lines) < 2:
    raise Exception("Weird bug!!")

for line in lines.split("\n"):
    hash = line.strip()
    hsh_files.append(hash)

# print(hsh_files)
new_hsh: list[str] = []

with urlopen(api_url) as res:
    if res.status != 200:
        raise Exception("Bing returned : ", res.reason)
    images = json.loads(res.read())["images"]

for obj in images:
    if obj["hsh"] in hsh_files:
        print("Already Dowloaded ", obj["title"])
        continue

    dwn_url: str = "http://bing.com" + obj["url"]
    filename = save_path + str(obj["title"]).replace(" ", "_") + ".jpg"
    path, _ = urlretrieve(dwn_url, filename)
    print("Downloaded ", obj["hsh"], " => ", path)
    new_hsh.append(obj["hsh"])

# This function overwrites the cache files.
if len(new_hsh) > 0:
    with open(cache_path, "a") as fcf:
        for hsh in new_hsh:
            _ = fcf.write(hsh + "\n")
