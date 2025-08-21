# Photoactivation pipeline with image analysis using cell morphology and signal intensity parameters (General Analysis module)

## Purpose
Automated image acquisition, analysis by the General Analysis module (intensity thresholding, morphology criteria) and stimulation of detected objects, all executed within the NIS-Elements software (Nikon).

## Requirements

**JOB-GeneralAnalysis-IntensityThresholding.bin**<br>
_JOB (NIS-Elements, Nikon) for image acquisition, analysis and stimulation_

## Running the JOB

1.	In NIS-Elements software, open _View_ > _A1R Stimulation_ and set laser and laser power (e.g., 405 nm, 10% laser power).
2.	Open _View_ > _ND Stimulation_ and set:
- Task 1: Stimulation, configuration: A1, time: 300 ms
- Task 2: Waiting, time: 10 ms (a stimulation task has to end with an acquisition or waiting step).
3.	Position the stage to the center of the imaging well and focus.
4.	Enable the Perfect Focus System (PFS).
5.	Take a capture of your sample. Select ROI (e.g., Point Stimulation) and test the stimulation by comparing PAmCherry2 fluorescence intensity before and after stimulation (using the ND Stimulation window).
6.	If it works, close all captures.
7.	Take capture and make sure the ROI is visible and move it a bit (does not matter where).
8.	Click on _Apply Stimulation Settings_.
9.	Import the JOB (_JOB-GeneralAnalysis-IntensityThresholding.bin_) in the JOBS Explorer. Specify the path to saving the data, the imaging configuration and the number of field-of-views (FOVs).
10.	Adjust the _Correction_misalign_ expression to correct for difference between the target and observed location of point-stimulation (see Fig. S8 of manuscript):<br>
`StgMoveXY(x destination coordinate [µm], y destination coordinate [µm], movement type [0=absolute; 1=relative])`<br>
E.g., `StgMoveXY(-1.75, 0, 1)` results in a relative movement of -1.75 µm in x direction.
11.	When imaging with an image size other than 512x512 pixels, adjust the center pixels of the FOV in the Macro accordingly.
12.	**Start the JOB**. Make sure the Perfect Focus System (PFS) is on, but make sure that no captures are taken outside of the sample area.

Optional: By modifying the JOB to take a capture after stimulation, you can validate the photoactivation performance after running the JOB. However, this will increase the time it takes for the JOB to finish. Therefore, it is efficient to first run this JOB with a couple of FOVs to check if accurate photoactivation is successful. Hereafter, you start the experiment with the total number of FOVs.

## Description of the workflow and User interface

For each FOV, a capture is taken, which is analysed by the General Analysis module (_Analysis1_). The resulting points (i.e., coordinates of the detected objects) are stored in _GA_points_. The JOB will loop over the points in _GA_points_ and stimulate each coordinate in the center of the FOV. The _Correction_misalign_ expression corrects for a misalignment between the intended and actual stimulation point.

<img src="./JOB-GeneralAnalysis-IntensityThresholding-1.PNG" alt="plot" width="500"/>

**Fig. 1 JOB (JOB-GeneralAnalysis-IntensityThresholding.bin) for automated imaging, analysis by the General Analysis module (employing cell morphology parameters and intensity thresholding) and photoactivation.**

<img src="./JOB-GeneralAnalysis-IntensityThresholding-2.PNG" alt="plot" width="500"/>

**Fig. 2 General Analysis module within _JOB-GeneralAnalysis-IntensityThresholding.bin_.** The results of the detection are stored in _GA_points_ (this is defined in the _Calculations_ tab).
