## 课程信息

- 教材为属性数据分析(王静龙)
- 有不定期随堂测验，测验内容一般为1-2道课后习题
- 期末提交大报告

## 学习参考

- logistic回归可进一步参考[应用LOGISTIC回归分析第2版(Scott Menard)](https://book.douban.com/subject/10956294/)和[定序因变量的logistic回归模型(Ann A.O'Connell)](https://book.douban.com/subject/10956295/)，根据因变量的特征，可以分为二分类logistic，无序多分类logistic，有序多分类logistic，其中有序多分类logistic模型又可依据数据的现实意义采取连续比例模型、相邻类别模型等
- R语言中与logistic回归有关的函数
    - 二分类：[glm](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/glm)
    - 无序多分类：[nnet::multinom](https://rdrr.io/cran/nnet/man/multinom.html)
    - 有序多分类：[MASS::polr](https://rdrr.io/cran/MASS/man/polr.html)，[brant::brant](https://rdrr.io/cran/brant/)
- 医学统计中也常用logistic回归，可参考[R语言实战医学统计](https://ayueme.github.io/R_medical_stat/)，医学统计中有着用单因素logistic回归筛选变量的经验做法，风暴统计平台集成了许多医学统计常用方法，其R包为[autoReg](https://rdrr.io/cran/autoReg/man/)
