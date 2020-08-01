# Summerschool-Project-Ready
A intro—project of FPGA

一.概述：
数字识别在日常生活中非常常见,常应用在车牌识别、证件识别等,而目前比较常用的方法是用深度学习的方法,但这一方法对硬件设备的要求高;如果使用FPGA板,经过资料查阅,有三种实现方法:模板匹配法、神经网络法和数字特征识别法。
我们用了两种实现方式,一种是用传统的FPGA进行数字特征识别法,另一种是用EdgeBoard(内含fpga芯片)实现的神经网络法。其实对比起两种方法,我们要做的都是把每一个分类的特征找出来,传统方法是靠人为去找图像里的特征,而神经网络,或者说深度学习的方法是机器自己寻找图像里的特征。
因为我们团队是两个人,每个人偏的方向不同,所以我们分别对这两种方式都做了实例。
FPGA采用经典的结构层次化编程，将实际工程划分为多个可实现模块进行实现，包括摄像头初始化模块，摄像头驱动模块，HDMI显示驱动模块；其中摄像头驱动模块包括了数字识别算法，用于对摄像头捕捉到的画面进行实时处理。

深度学习的方法,我们使用的深度学习框架是PaddlePaddle,使用的神经网络是3层全连接层的DNN,我们也试了其他跟复杂的网络,比如VGG-16。
二.效果：
使用传统的FPGA开发方式,程序代码已经写好,但是在调试的时候出现了一些问题,只能出现设计好的区域分割线与数字一，不能很好地实现数字识别。
使用神经网络开发的方式,主要看网络的结构,如果只使用3层全连接层的DNN,只能识别出数字2,如果使用VGG-16,效果有显著提升,识别这10类数字时,召回率和准确率都在80%以上,但是由于VGG-16体积较大,在部署时遇到了一些问题。

三.展望：
作品计划实现的功能是能把0-9这十种数字,都能识别出来;当然,未来我们会继续研究,能把英文字母以及常见的车牌上的中文识别出来,也就是65个分类。不过在前期制作的过程中 ,我们把作品的难度降低,先从识别一个数字开始,再慢慢往上增加难度,识别2个数字,我们选择了0和1,最后再扩展到10个数字。
