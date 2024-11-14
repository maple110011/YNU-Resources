library(tidyverse)
library(readxl)
library(ggplot2)
library(rvest)
library(stringi)
library(MASS)
url <- "https://bangumi.tv/anime/browser?sort=rank"
web <- read_html(url)
id_get <- function(web){ #获取bangumi对番剧的id标识
  a <- html_elements(web,"li") %>%
    html_elements("a") %>%
    html_attr("href") %>%
    strsplit(split=' ') %>%
    unlist() %>%
    as.vector()
    a[str_which(a,"/subject/")] %>%
    gsub("[/subject/]","",.) %>%
    unique()
} #id爬取单元
times_get <- function(id,web){
  times <- c()
  for (i in id){
    time <- "#item_326 > div > p.info.tip"
    stri_sub(time,7,9) <- i
    html_nodes(web,time) %>%
      html_text() %>%
      c(times) -> times
  }
  gsub(" ","",times) %>%
    gsub("*.{2,6}话/","",.) %>%
    gsub("[月.*].*","月",.)
} #时间爬取单元
names_get <- function(id,web){
  Names <- c()
  for (i in id){
    Name <- "#item_326 > div > h3 > a"
    stri_sub(Name,7,9) <- i
    html_nodes(web,Name) %>%
      html_text() %>%
      c(Names) -> Names
  }
  Names
} #番剧名称爬取单元
get_all_pages <- function(pages1,pages2){
  id <- id_get(web)
  times <- times_get(id,web)
  Names <- names_get(id,web)
  timedata <- data.frame(id,Names,times)
  for(i in pages1:pages2){
  page <- stri_c("&page=",i)
  url_sequence <- stri_c(url,page)
  retry_link <- function(url_sequence){
    tryCatch({ 
    web_sequence <- read_html(url_sequence)
  },error = function(e){
    web_sequence <- read_html(url_sequence)
  })
    web_sequence
  }#连接失败时尝试重连
  web_sequence <- retry_link(url_sequence)
  id <- id_get(web_sequence)
  times <- times_get(id,web_sequence)
  Names <- names_get(id,web_sequence)
  timedata <- data.frame(id,Names,times) %>%
    bind_rows(timedata,.)
  }
  timedata
} #爬取指定页数
data_time <-  get_all_pages(2,333)
write_excel_csv(data_time,file = "时间信息.csv")

data <- read_excel("D:/预删除文件夹/大三上/数据统计案例分析/动画评分影响因素分析/季度特征.xlsx")
data$月份 <- data$时间 %>%
  gsub(" ","",.) %>%
  gsub("*.{2,6}话/","",.) %>%
  gsub("[月.*].*","",.) %>%
  gsub("[0-9].*年","",.) %>%
  as.numeric()
data$年份 <- data$时间 %>%
  gsub(" ","",.) %>%
  gsub("*.{2,6}话/","",.) %>%
  gsub("[年月.*].*","",.)
data <- data %>%
  rowwise() %>%
  mutate(季度 = case_when((1<=月份&月份<4) ~ 1,
                        (4<=月份&月份<7) ~ 2,
                        (7<=月份&月份<10) ~ 3,
                        (1<=月份&月份<12) ~ 4)) %>%
  drop_na()
high_score_line1 <- quantile(data$动画评分,0.75)
high_score_line2 <- quantile(data$动画评分,0.9)
high_score_line3 <- quantile(data$动画评分,0.97)
data <- data %>%
  rowwise() %>%
  mutate(高分1 = case_when(动画评分 >= high_score_line1 ~ 1,
                        动画评分 < high_score_line1 ~ 0)) %>%
  mutate(高分2 = case_when(动画评分 >= high_score_line2 ~ 1,
                         动画评分 < high_score_line2 ~ 0)) %>%
  mutate(高分3 = case_when(动画评分 >= high_score_line3 ~ 1,
                       动画评分 < high_score_line3 ~ 0)) 
data <- data %>%
  group_by(季度) %>%
  mutate(n=n()) %>%
  mutate(per = sum(高分1)/n)
data$季度 <- factor(data$季度)
data$n <- 1
llll <- c(351,524,378,490)
ggplot(data=data, aes(x=季度,y = n,fill = 季度)) +
  geom_col() +
  labs(x = "评分位于前25%的番剧", y = "占比")
ggplot(data=data[data$高分2==1,], aes(x=季度,y = 高分2,fill = 季度)) +
  geom_col() +
  labs(x = "评分位于前10%的番剧", y = "频数") +
  theme(axis.line=element_line(),
        panel.background = element_rect(fill = NA),
        panel.grid.minor = element_line("black",linetype = 2),
        panel.grid.major = element_blank())
ggplot(data=data[data$高分2==1,], aes(x=季度,y = 高分3,fill = 季度)) +
  geom_col() +
  labs(x = "评分位于前3%的番剧", y = "频数")

data <- read_excel("D:/预删除文件夹/大三上/数据统计案例分析/动画评分影响因素分析/anime_information.xlsx")
data1 <- data[data$TV==1,c(-14,-15)] #TV动画数据
data1$动画标签 <- data1$动画标签 %>%
  gsub("[[]","",.) %>%
  gsub("[]]","",.) %>%
  gsub("[']","",.) %>%
  gsub(" ","",.) %>%
  strsplit(.,split=',') #将动画标签转换为向量元素

all_values_add <- function(){
  data2 <- data1 %>%
    rowwise() %>%
    mutate(科幻 = ifelse("科幻" %in% 动画标签,1,0)) %>%
    mutate(百合 = ifelse("百合" %in% 动画标签,1,0)) %>%
    mutate(后宫 = ifelse("后宫" %in% 动画标签,1,0)) %>%
    mutate(校园 = ifelse("校园" %in% 动画标签,1,0)) %>%
    mutate(奇幻 = ifelse("奇幻" %in% 动画标签,1,0)) %>%
    mutate(恋爱 = ifelse("恋爱" %in% 动画标签,1,0)) %>%
    mutate(治愈 = ifelse("治愈" %in% 动画标签,1,0)) %>%
    mutate(日常 = ifelse("日常" %in% 动画标签,1,0)) %>%
    mutate(百合 = ifelse("百合" %in% 动画标签,1,0)) %>%
    mutate(热血 = ifelse("热血" %in% 动画标签,1,0)) %>%
    mutate(穿越 = ifelse("穿越" %in% 动画标签,1,0)) %>%
    mutate(战斗 = ifelse("战斗" %in% 动画标签,1,0)) %>%
    mutate(搞笑 = ifelse("搞笑" %in% 动画标签,1,0)) %>%
    mutate(萌 = ifelse("萌" %in% 动画标签,1,0)) %>%
    mutate(悬疑 = ifelse("悬疑" %in% 动画标签,1,0)) %>%
    mutate(少女 = ifelse("少女" %in% 动画标签,1,0)) %>%
    mutate(魔法 = ifelse("魔法" %in% 动画标签,1,0)) %>%
    mutate(冒险 = ifelse("冒险" %in% 动画标签,1,0)) %>%
    mutate(历史 = ifelse("历史" %in% 动画标签,1,0)) %>%
    mutate(运动 = ifelse("运动" %in% 动画标签,1,0)) %>%
    mutate(励志 = ifelse("励志" %in% 动画标签,1,0)) %>%
    mutate(音乐 = ifelse("音乐" %in% 动画标签,1,0)) %>%
    mutate(推理 = ifelse("推理" %in% 动画标签,1,0)) %>%
    mutate(催泪 = ifelse("催泪" %in% 动画标签,1,0)) %>%
    mutate(美食 = ifelse("美食" %in% 动画标签,1,0)) %>%
    mutate(偶像 = ifelse("偶像" %in% 动画标签,1,0)) %>%
    mutate(乙女 = ifelse("乙女" %in% 动画标签,1,0)) %>%
    mutate(职场 = ifelse("职场" %in% 动画标签,1,0)) %>%
    mutate(正太 = ifelse("正太" %in% 动画标签,1,0)) %>%
    mutate(异世界 = ifelse("异世界" %in% 动画标签,1,0)) %>%
    mutate(龙傲天 = ifelse("异世界" %in% 动画标签,1,0))
} #标签转二分类变量
all_values_add()
sd(data2$动画评分)
ggplot(data=data1,aes(x=动画评分)) +
  geom_histogram(bins=15,color="black",fill="orange") +
  xlab("动画评分") +
  ylab("频数") +
  scale_y_continuous(breaks = seq(0,500,by = 50))+
  scale_x_continuous(breaks = seq(2,10,by = 1))+
  theme(panel.background = element_rect(fill = NA),
        axis.line=element_line())

df = rbind(data[which(data$高分1 == 1),]$季度,data[which(data$高分2 == 1),]$季度)
table(df)
table(data[which(data$高分2 == 1),]$季度)/sum(c(32, 45 ,35, 63 ))
iris[which(iris$Sepal.Width == 2), ]
ggplot(data=data, aes(x = 高分1)) +
  geom_histogram() +
  labs(x = "评分位于前25%的番剧", y = "频数")

ggplot(data=data, aes(x = 季度, y = per,fill = 季度)) +
  geom_col() +
  labs(x = "评分位于前25%的番剧", y = "频数")

ggplot(data=data, aes(x = 季度, y = per,fill = 季度)) +
  geom_col() +
  labs(x = "评分位于前25%的番剧", y = "频数")

ggplot(data=data, aes(x = 季度, y = per,fill = 季度)) +
  geom_col() +
  labs(x = "季度", y = "频数")

data$季度 <- factor(data$季度)
ggplot(data=data[data$高分1==1,], aes(x=季度,y = 高分1,fill = 季度)) +
  geom_col() +
  labs(x = "评分位于前25%的番剧", y = "频数")
ggplot(data=data[data$高分1==1,], aes(x=季度,y = 高分1,fill = 季度)) +
  geom_col() +
  labs(x = "评分位于前25%的番剧", y = "频数")
ggplot(data=data[data$高分2==1,], aes(x=季度,y = 高分2,fill = 季度)) +
  geom_col() +
  labs(x = "评分位于前10%的番剧", y = "频数")

table(data$季度)
table(data[data$高分1==1,]$季度)
table(data[data$高分2==1,]$季度)

write_excel_csv(data2,file = "全变量.csv")
data2 <- data2 %>%
  rowwise() %>%
  mutate(改编 = case_when(小说改 == 1 ~ 1,
                        漫画改 == 1 ~ 2,
                        游戏改 == 1 ~ 3,
                        GAL改 == 1 ~ 4))
data2$改编 <- factor(data2$改编)
table(data2$乙女)
summary(lm(动画评分~原作评分+导演标准分+编剧标准分,subset = (原创==0),data=data1))
l <- lm(动画评分^2~原作评分+导演标准分+编剧标准分,subset = (原创==0),data=data1)
influence.measures(l)
summary(lm(动画评分~导演标准分+编剧标准分+原创,data=data1))
qqnorm(data1$动画评分)
ks.test(data1$动画评分,"pnorm",mean(data1$动画评分), sd(data1$动画评分))

qqnorm(data1$动画评分^2)
ks.test(data1$动画评分^2,"pnorm",mean(data1$动画评分^2), sd(data1$动画评分^2))
model1 <- lm(动画评分^2~原作评分+导演标准分+编剧标准分+改编,subset = (原创==0),data=data2)
summary(model1)
plot(model1)
#异常值点分析
lll <- data1[c(688),]
plot(model2)
data2$动画评分=data2$动画评分+min(data2$动画评分)+0.01
model1_1 <-lm(动画评分^2~原作评分+导演标准分+编剧标准分+改编,subset = (原创==0),data=data2)
lambda <- data.frame(boxcox(model1))
lambda[which.max(lambda$y),]
plot(model1)
mean(data1$动画评分)
ggplot(data=data1[data1$GAL改==1,],aes(x=动画评分)) +
  geom_histogram(bins=15,color="black",fill="pink") +
  xlab("动画评分") +
  ylab("频数") +
  scale_x_continuous(breaks = c(seq(2,10,by = 1),6.62))+
  theme(panel.background = element_rect(fill = NA),
        axis.line=element_line())


#原创TV动画
model3 <- lm(动画评分^2~导演标准分+编剧标准分+奇幻+科幻+恋爱+
               校园+治愈+日常+百合+热血+穿越+战斗+搞笑+萌+悬疑+少女+魔法+历史+
               运动+励志+音乐+推理+催泪+美食+偶像+乙女+职场+正太+后宫+异世界,
             subset = (原创==1),data=data2)
summary(model3)
model4 <- step(model3)
summary(model4)
#非原创TV动画
model5 <- lm(动画评分^2~原作评分+导演标准分+编剧标准分+漫画改+游戏改+GAL改+奇幻+科幻+恋爱+
               校园+治愈+日常+百合+热血+穿越+战斗+搞笑+萌+悬疑+少女+魔法+历史+
               运动+励志+音乐+推理+催泪+美食+偶像+乙女+职场+正太+后宫+异世界,
             subset = (原创==0),data=data2)
summary(model5)
model6 <- step(model5)
summary(model6)
#所有TV动画
model7 <- lm(动画评分^2~导演标准分+编剧标准分+奇幻+科幻+恋爱+
               校园+治愈+日常+百合+热血+穿越+战斗+搞笑+萌+悬疑+少女+魔法+历史+
               运动+励志+音乐+推理+催泪+美食+偶像+乙女+职场+正太+后宫+异世界,
             subset = (原创==0),data=data2)
summary(model7)
model8 <- step(model7)
summary(model8)

model9 <- lm(动画评分^2~导演标准分+编剧标准分+百合+少女+少女*百合+恋爱+治愈,
             data=data2)
summary(model9)
model10 <- lm(动画评分^2~导演标准分+编剧标准分+异世界+后宫*异世界+战斗,
             data=data2)
summary(model10)
model11 <- lm(动画评分^2~导演标准分+编剧标准分+百合+少女+少女*百合+恋爱+治愈,
             data=data2)
summary(model11)
model12 <- lm(动画评分^2~导演标准分+编剧标准分+百合+少女+少女*百合+恋爱+治愈,
             data=data2)
summary(model12)