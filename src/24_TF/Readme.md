souces

https://www.tensorflow.org/datasets/catalog/overview#all_datasets

https://www.tensorflow.org/datasets/catalog/cats_vs_dogs

https://www.kaggle.com/datasets/crowww/a-large-scale-fish-dataset/data


```python
import os


WORKING_DIRECTORY = os.getcwd()

filenames = list(os.listdir())

filepaths = []

print(WORKING_DIRECTORY)
def concat_dir(filename, directory):
  return directory + '\\' + filename

for filename in filenames:
  directory = concat_dir(filename, WORKING_DIRECTORY)
  filepaths.append(directory)

# print(filepaths)

i = 0
for file in filepaths:
  os.rename(file, f'dog_{i}.jpg')
  i = i+1

```