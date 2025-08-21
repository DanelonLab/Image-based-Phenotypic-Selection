# Image-based Phenotypic Selection

## About

We describe a **Smart Microscopy pipeline** that automates imaging, detection of (synthetic) cells of interest, and photoactivation, marking cells for subsequent sorting purposes.

This work is part of the research project published _here_. It operates via protocols (called JOBS) within the **NIS-Elements software (Nikon)** and was developed using an A1R Laser scanning confocal microscope (Nikon) and Windows 10 Enterprise operating system.

## Available code

The JOBS for three different applications are provided in the repository subfolders.
1.	[Image analysis by **cell morphology and signal intensity** parameters](https://github.com/DanelonLab/Image-based-Phenotypic-Selection/tree/main/Detection-By-Intensity-Thresholding)
2.	[Image analysis by **deep learning-assisted object detector** You Only Look Once (YOLO)](https://github.com/DanelonLab/Image-based-Phenotypic-Selection/tree/main/Detection-By-YOLO-Single-Time-Frame)
3.	[Analysis of **videos** by YOLO](https://github.com/DanelonLab/Image-based-Phenotypic-Selection/tree/main/Detection-By-YOLO-Using-Videos)

The [**code for training and testing YOLO**](https://github.com/DanelonLab/Image-based-Phenotypic-Selection/tree/main/Training-YOLO) using a Colaboratory Notebook is also available.

## Installation of the required software for image analysis using YOLO

_Last update: December 2022_

**Requirements for YOLO** (retrieved in December 2022 from: https://github.com/AlexeyAB/darknet#requirements-for-windows-linux-and-macos):
- CUDA >= 10.2
- OpenCV >= 2.4
- cuDNN >= 8.0.2
- GPU with CC >= 3.0 (but you can also run without GPU)

1.	**Install Visual Studio 2019** (tutorial: https://www.youtube.com/watch?v=mwN8CuazY9E)
Visual Studio 2019 was installed with ‘Desktop development with C++’ and ‘.NET desktop development’.

2.	**Install CUDA** (tutorial: https://www.youtube.com/watch?v=2TcnIzJ1RQs)
The version of CUDA that needs to be installed depends on the GPU. To find the correct CUDA version, check https://en.wikipedia.org/wiki/CUDA.
Quadro RTX 4000 > Compute capability 7.5 (Turing) > CUDA SDK 10.0 – 10.2. CUDA 10.2 was installed.

3.	**Install cuDNN** (tutorial: https://www.youtube.com/watch?v=2TcnIzJ1RQs) 
cuDNN >= 8.0.2 https://developer.nvidia.com/rdp/cudnn-archive, on Windows follow steps described here https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html#installwindows). 
cuDNN version 8.0.2 was installed.

4.	**Install OpenCV** (tutorial: https://www.youtube.com/watch?v=wBtiGTToVEE&t=295s)
OpenCV version: 4.2.0 was installed.

5.	**Make solution using Visual Studio 2019** (tutorial: https://www.youtube.com/watch?v=wBtiGTToVEE&t=295s)
There is a ‘gpu’ and ‘no gpu’ version that can be built as two separate exe files.
Check supported sm variation here: https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/.

6.	Lastly, the batch scripts for automated image analysis by YOLO require the installation of **ImageMagick** from https://imagemagick.org/script/download.php. Version ‘ImageMagick-7.1.1-18-Q16-HDRI-x64-dll.exe’ was downloaded.

## Developers
Marijn van den Brink and Marlena Stam

Danelon Lab (www.danelonlab.com)

We are open to any questions, suggestions and contributions.

## Acknowledgements
We are thankful to Michal Shemesh, Martin Holub, Timo Kuijt (Nikon) and the technical support team from Laboratory Imaging s.r.o. for their help with the microscopy automation.
