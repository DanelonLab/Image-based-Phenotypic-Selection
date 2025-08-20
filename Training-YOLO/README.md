# Training and testing YOLO

Google Colab notebook for training and testing YOLO (e.g., YOLOv7-tiny). 

This code was developed by: https://github.com/theAIGuysCode/YOLOv3-Cloud-Tutorial.

## How to run this code

1.	Copy all required files to a folder in your Google Drive (listed below).
2.	In the first line of the code, define the path to your folder.
3.	Run the code.

## Required files:
-	Create an empty folder named ‘backup’, where the training weights will be stored after every 1000 epochs
-	generate_train.py
-	generate_test.py
-	obj.data
-	obj.names
-	obj.zip
-	val.zip
-	yolov7-tiny-training.cfg (or similar)

**Explanation of required files:**

**obj.data** contains number of classes and directions to files. Adjust only the number of classes and the path to the backup folder.

classes = 1

train  = data/train.txt

valid  = data/test.txt

names = data/obj.names

backup = /mydrive/foldername/backup/

**obj.names** contains list of class names.


<img width="142" height="95" alt="image" src="https://github.com/user-attachments/assets/5561a1b5-0eca-4d3c-a953-e9b89c5b7631" />



