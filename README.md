# NatureESN_Dataset

This is the Matlab code and Matlab .m files for the datasets used in our paper "Adaptive State-feedback Echo State Networks for Temporal Sequence Learning".

This repository is organised into four folders, each correponding to each example.

Each folder contains:

    Example_Data_Gen.m - which is used to generate and preprocess the datasets. It contains explicit, step-by-step running explanationsa accompanied by variable definitions.
    points.mat - which is the matfile that contains the whole dataset.
    training.mat and testing.mat - which are the matfiles that contain the training/testing datasets (after splitting points.mat).

Folders Example A and Example B contain additional files:

    affinetarget.m - which is used to generate the target output using the generated matrices from Example_Data_Gen.m
    matrices.mat - which stores the generated A, B, C matrices of the current example for re-running and analysing purposes.

Folder Example C contains additional files:

    170_I-O_2000Hz_Complete.mat - the original recorded Fruitfly signals.
    170_PreProcessed.mat - the processed Fruitfly signals, as explained in section Example C of our paper.
    
The minimum required version is R2021b Update 7 (9.11.0.2358333).
