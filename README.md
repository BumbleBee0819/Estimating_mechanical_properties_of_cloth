[![GitHub issues](https://img.shields.io/github/issues/Naereen/StrapDown.js.svg)](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/issues/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Matlab](https://img.shields.io/badge/language-Matlab-red.svg)]()
[![R](https://img.shields.io/badge/language-R-red.svg)]()
[![BashScript](https://img.shields.io/badge/language-BashScript-red.svg)]()
![Total visitor](https://visitor-count-badge.herokuapp.com/total.svg?repo_id=dense_traject)
![Visitors in today](https://visitor-count-badge.herokuapp.com/today.svg?repo_id=dense_traject)


<h1 align="center"> Estimating mechanical properties of cloth from videos using dense motion trajectories: Human psychophysics and machine learning </h1>

    
**In this project, we use Blender (2.7.6) rendered cloth animations as our dataset.**
* **First, we used a maximum likelihood differential scaling (MLDS) method to measure the human perceptual scale of cloth stiffness. Codes and instructions of this experiment can be found in the [MLDS_Experiment](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MLDS_Experiment) folder.** 

<p align="center">
    <img width=20% src="MLDS_Experiment/Z_demo/Cotton_BendingStiffness=25_Scene1.gif">
    <img width=20% src="MLDS_Experiment/Z_demo/Cotton_BendingStiffness=25_Scene2.gif">
    <img width=20% src="MLDS_Experiment/Z_demo/Silk_BendingStiffness=25_Scene1.gif">
    <img width=20% src="MLDS_Experiment/Z_demo/Silk_BendingStiffness=25_Scene2.gif">
<p align="center">Perceptual scale of cloth stiffness</strong></p>


* Next, we extracted the dense motion trajectory features of all the cloth videos, and built a support vector regression (SVR) model with these trajectory features to predict the human perceptual scale of stiffness. Codes and instruction of this experiment can be found in the [MotionAnalysis](https://github.com/BumbleBee0819/Estimating_mechanical_properties_of_cloth/tree/master/MotionAnalysis) folder.

<p align="center">
    <img width=90% src="MotionAnalysis/Z_demo/demo.gif">
<p align="center">Computational modeling of human perceptual scale</strong></p>

## Contact
If you have any questions, please contact "wb1918a@american.edu".
