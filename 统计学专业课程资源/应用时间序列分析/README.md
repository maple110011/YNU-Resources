## 课程信息

- 教材为[应用时间序列分析第5版(易丹辉,王燕)](https://book.douban.com/subject/34763232/)
- 周建军老师编写的实验手册

## 学习参考

- 选用教材较为糟糕，但级别教材中也没有特别好的，要么难度过大，要么不够顺畅，建议同时看下面这些教材：
    - [金融时间序列分析第3版(Ruey S. Tray)](https://book.douban.com/subject/11610921/)
    - [时间序列分析及应用：R语言第2版(克莱尔)](https://book.douban.com/subject/5416787/)
- 若有意学习更深入的时间序列分析理论，可参考下列教材，无论是理论深度广度还是叙述流畅度都比上面的教材更好：
    - [现代时间序列分析导论(盖哈德·克西盖思纳,约根·沃特斯,乌沃·哈斯勒)](https://book.douban.com/subject/26417486/)
    - [时间序列分析预测与控制(George E. P. Box)](https://book.douban.com/subject/1551898/)
    - [金融时间序列分析讲义(李东风)](https://www.math.pku.edu.cn/teachers/lidf/course/fts/ftsnotes/html/_ftsnotes/index.html)
- 会用到的R package：
    - [forecast::auto.arima](https://rdrr.io/cran/forecast/man/auto.arima.html)自动识别ARIMA阶数
    - [tsoutliers::tso](https://rdrr.io/cran/tsoutliers/man/tso.html)自动识别异常点
    - [uroot::hegy.test](https://rdrr.io/cran/pdR/man/HEGY.test.html)HEGY检验
    - ADF检验
- 季节单位根有其特殊性，普通的ADF检验遇到季节单位根时结果不稳健，需要使用HEGY检验，详情可参考[Analysis of Integrated and Cointegrated Time Series with R (Bernhard Pfaff)](https://book.douban.com/subject/4079399/)的6.2节

##
- 实验注意事项：
    - 周建军老师提供的部分数据需要一定预处理，譬如存在编码不同(ANSI、GBK、UTF-8，UTF-16LE)、格式messy(值列中包含多个变量的值)等问题，建议借此练习数据预处理能力
    - 部分实验的数据需要自行收集，譬如实验4预测对比中美GDP，可从[世界银行](https://data.worldbank.org.cn/)下载数据，若考虑严谨性，建议分别采用购买力平价和汇率折算数据，并且使用定基不变价数据
- 实验1：时间序列的分解
- 实验2：时间序列数据的预处理
- 实验3：线性平稳时间序列建模
- 实验4：非平稳时间序列建模1
- 实验5：非平稳时间序列建模2
- 实验6：多元时间序列建模
- 随堂实验1：太阳黑子趋势建模
- 随堂实验2：月度温度数据规律分析
- 随堂实验3：云南省进出口贸易值干预分析
- 期末实验：我国外商直接投资额的趋势分析及预测
