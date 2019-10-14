[![GitHub issues](https://img.shields.io/github/issues/Naereen/StrapDown.js.svg)](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/issues/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Matlab](https://img.shields.io/badge/language-Matlab-red.svg)]()
[![BashScript](https://img.shields.io/badge/language-BashScript-red.svg)]()
![Total visitor](https://visitor-count-badge.herokuapp.com/total.svg?repo_id=motion_analysis)
![Visitors in today](https://visitor-count-badge.herokuapp.com/today.svg?repo_id=motion_analysis)


<h1> Predicting human perceptual scale of stiffness with support vector regression (SVR) </h1>

<p align="center">
    <img width=90% src="Z_demo/Cotton_BendingStiffness=25_Scene1.gif">


This folder contains the codes for the in-lab triplet maximum likelihood differential scaling (MLDS) psychophysics experiment and the data analysis. We used these codes in our paper [Estimating mechanical properties of cloth from videos using dense motion trajectories: Human psychophysics and machine learning
](https://jov.arvojournals.org/article.aspx?articleid=2682351). Codes in this repository are supposed to work as a template such that they should work for all triplet maximum likelihood differential scaling (MLDS) experiments with little modifications. See the project page [here](https://sites.google.com/site/wenyanbi0819/website-builder/jov_185_12?authuser=0).

## Dependencies
The codes require the [Psychtoolbox](http://psychtoolbox.org/credits/) in Matlab. 

## References
If you use the codes, please cite the following papers.
```
1. Bi, W., Jin, P., Nienborg, H., & Xiao, B. (2018). Estimating mechanical properties of cloth from videos using dense motion trajectories: Human psychophysics and machine learning. Journal of Vision, 18(5):12, 1–20.
2. Brainard, D. H., & Vision, S. (1997). The psychophysics toolbox. Spatial vision, 10, 433-436.
3. Knoblauch, K., & Maloney, L. T. (2008). MLDS: Maximum likelihood difference scaling in R. Journal of Statistical Software, 25(2), 1–26.
4. Maloney, L. T., & Yang, J. N. (2003). Maximum likelihood difference scaling. Journal of Vision, 3(8): 5, 573–585.
```

## Usage
1. The experimental design is explained in [our paper](https://jov.arvojournals.org/article.aspx?articleid=2682351).
<div class="image12">
    <p align="center"><img src="Z_demo/ui.gif"></p>
</div>

2. [WindExperimentMain_MLDS.m](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/blob/master/MLDS_Experiment/WindExperimentMain_MLDS.m): This is the main code for the experiment. The collected data will be stored in the results folders for the [Silk condition](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MLDS_Experiment/Bending_Silk/resultsFolder) and the [Cotton condition](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MLDS_Experiment/Bending_Cotton/resultsFolder).
   
3. We provided [codes](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MLDS_Experiment/DataAnalysis) for plotting the perceptual scales recovered by MLDS.
   * [DataAnalysis_MLDS.m](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MLDS_Experiment/DataAnalysis/DataAnalysis_MLDS.m): This code needs to be run first, it creates "mydata.txt" to be used by [Plot_MLDS.R](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MLDS_Experiment/DataAnalysis/Plot_MLDS.R)
   * [Plot_MLDS.R](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MLDS_Experiment/DataAnalysis/Plot_MLDS.R): This code plots the individual percetual scale for each participant and the average perceptual scale for all participants.
## Contact
If you have any questions, please contact "wb1918a@american.edu".
