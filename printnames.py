import os

for filename in os.listdir('.'):
    if filename.endswith('.lua'):
        print(filename)

