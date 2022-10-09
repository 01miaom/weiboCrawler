library(jsonlite);
library(stringr);
library(httr)
library(rvest)
library(base)

#获取词条下的博文、时间、昵称、id等信息
data = matrix(0,ncol=12)
N = 10

for(j in 1:N){
url=str_c("https://m.weibo.cn/api/container/getIndex?containerid=@@&page_type=searchall&page=",j) #replace @@ to correspondind conter id
#webpage<-getURL(url,httpheader=myHttpheader,.encoding="UTF-8");
readlines <- readLines(url, warn = FALSE)

temple<-fromJSON(readlines);

text=array(0,9)
time=array(0,9)
name=array(0,9)
id=array(0,9)
gender=array(0,9)
follow=array(0,9)
befollow=array(0,9)
url=array(0,9)
zhuanfa=array(0,9)
pinglun=array(0,9)
dianzan=array(0,9)
wbid=array(0,9)

for(i in 1:10){ ## totally have 10 article in each page
  try({
    text[i]=temple$data$cards$card_group[[i]]$mblog$text[1]
    time[i]=temple$data$cards$card_group[[i]]$mblog$created_at
    name[i]=temple$data$cards$card_group[[i]]$mblog$user$screen_name
    id[i]=temple$data$cards$card_group[[i]]$mblog$user$id
    gender[i]=temple$data$cards$card_group[[i]]$mblog$user$gender
    follow[i]=temple$data$cards$card_group[[i]]$mblog$user$follow_count
    befollow[i]=temple$data$cards$card_group[[i]]$mblog$user$followers_count
    url[i]=temple$data$cards$card_group[[i]]$mblog$user$profile_url
    zhuanfa[i]=temple$data$cards$card_group[[i]]$mblog$reposts_count
    pinglun[i]=temple$data$cards$card_group[[i]]$mblog$comments_count
    dianzan[i]=temple$data$cards$card_group[[i]]$mblog$attitudes_count
    wbid[i]=temple$data$cards$card_group[[i]]$mblog$id
    })
    
##change to:
##temple$data$cards$card_group[[1]]$mblog$created_at
##if you want to get the time

text[i]=str_replace_all(text[i], "[0-9]+", "")
text[i]=str_replace_all(text[i], "[a-z]", "")
text[i]=str_replace_all(text[i], "[A-Z]", "")
text[i]=str_replace_all(text[i], "<", "")
#text[i]=str_replace_all(text[i], ".", "")
text[i]=str_replace_all(text[i], "=", "")
text[i]=str_replace_all(text[i], "\ ", "")
text[i]=str_replace_all(text[i], "/", "")
text[i]=str_replace_all(text[i], ">", "")
text[i]=str_replace_all(text[i], '"', "")
text[i]=str_replace_all(text[i], "%", "")
text[i]=str_replace_all(text[i], "-", "")
text[i]=str_replace_all(text[i], ";", "")
text[i]=str_replace_all(text[i], "&", "")
#text[i]=str_replace_all(text[i], '?', "")
text[i]=str_replace_all(text[i], ":", "")
}
r=as.matrix(cbind(text,time,name,id,gender,follow,befollow,url,zhuanfa,pinglun,dianzan,wbid))
data=rbind(data,r)
Sys.sleep(2)
cat(j)
}

write.csv(data,"article.csv")

########################################

#获取博文下的评论，需要使用cookie登陆才能获得全部评论内容

myHttpheader <- c(
  "cache-control" = "no-cache",
  "content-encoding" = "gzip",  
  "content-type" = "application/json; charset=utf-8",
  "date" = "Sat, 07 Oct 2022 17:00:56 GMT",
  "lb" = "", #ip address
  "proc_node" = "", #proc node
  "server" = "nginx",
  "set-cookie" = "XSRF-TOKEN=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT; Max-Age=0; path=/",
  "set-cookie" = "XSRF-TOKEN=; expires=Fri, 07-Oct-2022 17:20:56 GMT; Max-Age=1200; path=/; domain=m.weibo.cn",
  "set-cookie" = "", #real cookie
  "ssl_node" = "ssl.mweibo.intra.weibo.cn",
  "vary" = "Accept-Encoding",
  "x-log-uid" = "",
  "x-powered-by" = "PHP/7.2.1"
  # "Cookies" = "",
  # 
  # "User-Agent" = "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.6) ",
  # 
  # "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
  # 
  # "Accept-Language" = "en-us",
  # 
  # "Connection" = "keep-alive",
  # 
  # "Accept-Charset" = "GB2312,utf-8;q=0.7,*;q=0.7"
  # 
);


data=matrix(0,ncol=7)

N = 40

n = 2

for(k in 2:N){
  for(j in 1:n){
    url=str_c("https://m.weibo.cn/api/comments/show?id=",as.character(tmp$wbid[k]),"&page=",j)
    # url=str_c("https://m.weibo.cn/api/comments/show?id=",,"&page=",j)
    #webpage<-getURL(url,httpheader=myHttpheader,.encoding="UTF-8");
      try({
    
        readlines <- getURL(url)#,httpheader=myHttpheader)
  
        temple<-fromJSON(readlines);
      })

    try({
      text=as.matrix(temple[["data"]][["data"]][["text"]])
      time=as.matrix(temple[["data"]][["data"]][["created_at"]])
      name=as.matrix(temple[["data"]][["data"]][["user"]][["screen_name"]])
      id=as.matrix(temple[["data"]][["data"]][["user"]][["id"]])
      befollow=as.matrix(temple[["data"]][["data"]][["user"]][["followers_count"]])
      url=as.matrix(temple[["data"]][["data"]][["user"]][["profile_url"]])
      dianzan=as.matrix(temple[["data"]][["data"]][["like_counts"]])
    })


    try({
    text=str_replace_all(text, "[0-9]+", "")
    text=str_replace_all(text, "[a-z]", "")
    text=str_replace_all(text, "[A-Z]", "")
    text=str_replace_all(text, "<", "")
    #text[i]=str_replace_all(text[i], ".", "")
    text=str_replace_all(text, "=", "")
    text=str_replace_all(text, "\ ", "")
    text=str_replace_all(text, "/", "")
    text=str_replace_all(text, ">", "")
    text=str_replace_all(text, '"', "")
    text=str_replace_all(text, "%", "")
    text=str_replace_all(text, "-", "")
    text=str_replace_all(text, ";", "")
    text=str_replace_all(text, "&", "")
    #text[i]=str_replace_all(text[i], '?', "")
    text=str_replace_all(text, ":", "")
    
  r=as.matrix(cbind(text,time,name,id,befollow,url,dianzan))
  data=rbind(data,r)
  r=matrix(0,ncol=7)
  readline=""
  temple=""
    })
  Sys.sleep(sample(7:12,1))
  cat(">")
}

}
write.csv(data,"pinglun.csv")

