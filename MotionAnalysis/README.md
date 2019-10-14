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
](https://jov.arvojournals.org/article.aspx?articleid=2682351). See the project page [here](https://sites.google.com/site/wenyanbi0819/website-builder/jov_185_12?authuser=0).

## Dependencies
* [VLFeat Matlab toolbox](http://www.vlfeat.org/download.html) (vlfeat-0.9.20). 
* [Yael for matlab](http://yael.gforge.inria.fr/matlab_interface.html)(yael_v438).
* [Dense trajectories video descriptors](https://lear.inrialpes.fr/people/wang/dense_trajectories) (third version).
* [ffmpeg-0.11.1](https://ffmpeg.org/releases/).



## References
If you use the codes, please cite the following papers.
```
1. Bi, W., Jin, P., Nienborg, H., & Xiao, B. (2018). Estimating mechanical properties of cloth from videos using dense motion trajectories: Human psychophysics and machine learning. Journal of Vision, 18(5):12, 1–20.
2. Wang, H., Kläser, A., Schmid, C., & Cheng-Lin, L. (2011, June). Action recognition by dense trajectories.
3. Wang, H., & Schmid, C. (2013). Action recognition with improved trajectories. In Proceedings of the IEEE international conference on computer vision (pp. 3551-3558).
```

## Usage
1. [BashExtract_DenseTrajectory.sh](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/blob/master/MotionAnalysis/BashExtract_DenseTrajectory.sh): Bash extract motion trajectory features of videos. You should download and compile the [dense trajecotry codes](https://lear.inrialpes.fr/people/wang/dense_trajectories) first. Put this bash file in the root folder of the dense trajectory codes. This code only works for the Linux/MacOS system.


2. [BaseLine.m](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/blob/master/MotionAnalysis/SVM_model/BaseLine.m): After extracting the dense motion trajectory features of all the training and testing videos, put the extracted trajectory features in the [test](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MotionAnalysis/SVM_model/test) folder and the [train](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MotionAnalysis/SVM_model/train) folder Next, run this code to train the SVM model and plot the results. 
   


## Contact
If you have any questions, please contact "wb1918a@american.edu".
