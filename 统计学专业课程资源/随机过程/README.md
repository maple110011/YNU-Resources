## 课程信息

- 教材为应用随机过程(张波,商豪)

## 学习参考

- 建议学习[应用随机过程(李东风)](https://www.math.pku.edu.cn/teachers/lidf/course/stochproc/stochprocnotes/html/_book/index.html)，李东风在张波商豪教材的基础上修正了大量错误，并增补了许多内容
- 选取教材较为糟糕，错漏颇多，下面是一些已发现的问题：
    - 32页定理2.2.3缺少条件 $X(0)=0$
    - 59页例4.2.4对Wald等式的第二种证明错误， 因为$N(t)=1$的情况下$X_1$只能截尾至小于等于1，李东风给出了基于停时的[证明](https://www.math.pku.edu.cn/teachers/lidf/course/stochproc/stochprocnotes/html/_book/martingale.html#thm:mart-stopth-th-wald)
    - 65页例4.3.2未给出服务员忙时到达的顾客的行动，应当假定顾客离开，此时为更新过程，否则将成为排队系统


## 实验

- 实验1：R语言的基本操作和随机数的生成
- 实验2：逆变换法生成随机数
- 实验3：分布特征的数值计算
- 实验4：随机游动的模拟与计算
- 实验5：泊松过程的随机模拟
- 实验6：复合泊松过程的随机模拟
- 实验7(期中实验1)
- 实验8：更新过程的模拟与计算
- 实验9：Markov链的模拟与计算
- 期中实验2
- 期末实验
