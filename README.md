# Common modular architecture across diverse cortical areas in early development
### Nathaniel J. Powell, Bettina Hein, Deyue Kong, Jonas Elpelt, Haleigh N. Mulholland, Matthias Kaschube, Gordon B. Smith

This repository contains code to regenerate the figures from “Common modular architecture across diverse cortical areas in early development”, by Powell et al., 2024, PNAS.

To run, download the code and associated data from this repository (total download size ~ 5MB).

Functions powell24_figure1.m, powell24_figure2.m, and powell24_figure3.m take the full path to the downloaded data as single input argument.

For example
dataPath=’~/Downloads/powell24_data/fig_1_data.mat’;
powell24_figure1(dataPath);

Requirements: Matlab, Statistics and Machine Learning Toolbox. Tested in Matlab 2017b, 2018b, 2023b.

#### _Additional data_
Additional data from this study is available at zenodo.org, https://doi.org/10.5281/zenodo.10718950

This data contains additional spontaneous events and correlation matrices for widefield and 2-photon datasets for each cortical area in this study. 

The file powell24_data_info.m contains further descriptions of this additional data. 
