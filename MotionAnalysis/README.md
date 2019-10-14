[![GitHub issues](https://img.shields.io/github/issues/Naereen/StrapDown.js.svg)](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/issues/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Matlab](https://img.shields.io/badge/language-Matlab-red.svg)]()
[![BashScript](https://img.shields.io/badge/language-BashScript-red.svg)]()
![Total visitor](https://visitor-count-badge.herokuapp.com/total.svg?repo_id=motion_analysis)
![Visitors in today](https://visitor-count-badge.herokuapp.com/today.svg?repo_id=motion_analysis)


<h1> Predicting human perceptual scale of stiffness with support vector regression (SVR) </h1>

<p align="center">
    <img width=90% src="Z_demo/demo.gif">


We train a support vector regression (SVR) model with the dense motion trajectory motion features to predict human percetual scale of the cloth stiffness from videos. These codes are used in our paper [Estimating mechanical properties of cloth from videos using dense motion trajectories: Human psychophysics and machine learning
](https://jov.arvojournals.org/article.aspx?articleid=2682351). 

## Dependencies
* [VLFeat Matlab toolbox](http://www.vlfeat.org/download.html) (vlfeat-0.9.20). 

## References
If you use the codes, please cite the following papers.
```
1. Bi, W., Jin, P., Nienborg, H., & Xiao, B. (2018). Estimating mechanical properties of cloth from videos using dense motion trajectories: Human psychophysics and machine learning. Journal of Vision, 18(5):12, 1–20.
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
