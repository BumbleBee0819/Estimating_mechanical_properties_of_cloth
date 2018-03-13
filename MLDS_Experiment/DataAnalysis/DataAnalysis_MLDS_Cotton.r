# MLDS
#!/usr/bin/env Rscript
# 26/08/2017 Wenyan Bi wrote this

#install.packages("rstudioapi")
#install.packages("MLDS")

library(MLDS)
library(rstudioapi) 


curDir <- getActiveDocumentContext()$path 
setwd(dirname(curDir ))
print( getwd() )
###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### 

mydata1 = read.table('/Bending_Cotton/resultsFolder/NewWind/wb/mydata.txt', sep="\t")
mydata2 = read.table('/Bending_Cotton/resultsFolder/ebs/mydata.txt', sep="\t")
mydata3 = read.table('/Bending_Cotton/resultsFolder/hlw/mydata.txt', sep="\t")
mydata4 = read.table('/Bending_Cotton/resultsFolder/kelly/mydata.txt', sep="\t")
mydata5 = read.table('/Bending_Cotton/resultsFolder/mls/mydata.txt', sep="\t")
mydata6 = read.table('/Bending_Cotton/resultsFolder/zx/mydata.txt', sep="\t")


# original scene
#kk <- SwapOrder(mydata)
x1.mlds<-mlds(mydata1)
summary(x1.mlds)


png(filename="/Bending_Cotton/resultsFolder/bx/bx.png");
plot(x1.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "red")
lines(x1.mlds,standard.scale =TRUE,col='red')
dev.off()


x2.mlds<-mlds(mydata2)
summary(x2.mlds)
png(filename="/Bending_Cotton/resultsFolder/ebs/ebs.png");
plot(x2.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "red")
lines(x2.mlds,standard.scale =TRUE,col='red')
dev.off()


x3.mlds<-mlds(mydata3)
summary(x3.mlds)
png(filename="//Bending_Cotton/resultsFolder/hlw/hlw.png");
plot(x3.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "red")
lines(x3.mlds,standard.scale =TRUE,col='red')
dev.off()


x4.mlds<-mlds(mydata4)
summary(x4.mlds)
png(filename="/Bending_Cotton/resultsFolder/kelly/kelly.png");
plot(x4.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "red")
lines(x4.mlds,standard.scale =TRUE,col='red')
dev.off()


x5.mlds<-mlds(mydata5)
summary(x5.mlds)
png(filename="/Bending_Cotton/resultsFolder/mls/mls.png");
plot(x5.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "red")
lines(x5.mlds,standard.scale =TRUE,col='red')
dev.off()



x6.mlds<-mlds(mydata6)
summary(x6.mlds)
png(filename="/Bending_Cotton/resultsFolder/zx/zx.png");
plot(x6.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "red")
lines(x6.mlds,standard.scale =TRUE,col='red')
dev.off()






#plot(x.mlds, type = "b",xlab="Mass", ylab="difference scale")
#plot(x.mlds,  type = "b", main="Different Scaling for Bending", xlab="Bending Values", ylab="Difference Scale", xlim=c(1, 9), ylim=c(0, 7)) 
#plot(c(0.01, 0.1, 1, 5,10,25, 40, 80, 150), x.mlds$ps, type = "b", main="Different Scaling for Bending", xlab="Bending Values", ylab="Difference Scale") 
#plot(c(0.1, 0.3, 0.5, 0.7,1,1.3, 1.5, 1.7, 2.0), x.mlds$ps, type = "b", main="Different Scaling for Mass", xlab="Mass Values", ylab="Difference Scale",xlim=c(0, 2), ylim=c(0, 7)) 
#plot(c(1,2,3,4,5,6,7,8,9,10,11,12,13,14), x.mlds$ps, type = "b",main="Different Scaling for Bending", xlab="Bending Values", ylab="Difference Scale") 
png(filename="/Bending_Cotton/resultsFolder/all.png");

plot(x1.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "red")
plot(x2.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "blue")
plot(x3.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "red")
plot(x4.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "black")
plot(x5.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "yellow")
plot(x6.mlds, standard.scale =TRUE, cex = 1.7, pch = 16, col = "green")




lines(x1.mlds,standard.scale =TRUE,col='red')
lines(x2.mlds,standard.scale =TRUE,col='blue')
lines(x3.mlds,standard.scale =TRUE,col='blue')
lines(x4.mlds,standard.scale =TRUE,col='black')
lines(x5.mlds,standard.scale =TRUE,col='yellow')
lines(x6.mlds,standard.scale =TRUE,col='green')


#legend("topleft", inset=.02, title="Participants",
#       legend=c("C", "S"),col=c("red", "blue"), lty=1, cex=0.8,box.lty=2, box.lwd=2, box.col="black")


#lines(x.mlds$stimulus, lwd = 2)
dev.off()
