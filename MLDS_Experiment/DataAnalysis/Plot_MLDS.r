#
# Plot MLDS perceptual scales
#
# Input: <mydata.txt> under each subject's folder
# Output:
#   1) 'bx.png': individual perceptual scale in each subject's folder
#   2) 'all.eps": average perceptual scale
#
#
#!/usr/bin/env Rscript
# 26/08/2017 Wenyan Bi <wb1918a@american.edu> wrote this


###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### 
# [wb]: Check library
libs <- c("reshape", "dplyr", "tibble", "MLDS", "rstudioapi", "ggplot2", "tidyr")

for (n in 1:length(libs)){
  if(libs[n] %in% rownames(installed.packages()) == FALSE){
    install.packages(libs[n])
  }
  
  library(libs[n], character.only = TRUE)
}

###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### 
# [wb]: Define subjects
subs <- c('wb', 'pj', 'bx')
expName <- 'Bending_Silk'
nStim <- 8


# [wb]: Other parameters
vid <- seq(1, nStim, length.out=nStim)
mydata <- list()
# [wb]: stores the mlds results
x <- list() 
# [wb]: save all mlds results to the .csv file
myCSVdata <- list()

###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### 
# [wb]: Set path
curDir <- getActiveDocumentContext()$path 
setwd(dirname(curDir))
print(getwd())

curDir <- getwd()
setwd("..")
rootDir <- getwd()
setwd(curDir)
# [wb]: output is in the same folder as the input
inputRootDir <- paste(dirname(curDir), '/', expName, '/resultsFolder', sep = '')


###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### 
# [wb]: Plot individual perceptual scale
for (n in 1:length(subs)){
  thisDir <- paste(inputRootDir, '/', subs[n], sep = '')
  thisDataFile <- paste(thisDir,'/mydata.txt', sep = '')
  mydata[[n]] <- read.table(thisDataFile, sep = "\t")
  
  
  x[[n]] <- mlds(mydata[[n]])
  summary(x[[n]])

  outputFileName <- paste (thisDir, '/', subs[n], '.png', sep = '')
  png(filename = outputFileName);
  plot(x[[n]], type = "b", main="MLDS Perceptual Scale", 
       xlab="Ground Truth Stiffness Values", 
       ylab="Perceived Stiffness",
       standard.scale =TRUE, cex = 1.7, pch = 16, col = "red")
  lines(x[[n]], standard.scale =TRUE, col='red')
  dev.off()
  
  ## un-normalize
  # myCSVdata[[n]] <- x[[n]]$pscale
  # normalize
  myCSVdata[[n]] <- (x[[n]]$pscale- min(x[[n]]$pscale))/(max(x[[n]]$pscale) - min(x[[n]]$pscale))
}


###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### 
# [wb]: output .csv file
df <- data.frame(matrix(unlist(myCSVdata), ncol=length(myCSVdata)))
outputFileName <- paste(curDir, "/mydata.csv", sep = '')
write.table(df, file = outputFileName, 
            row.names=FALSE, na="",
            col.names=subs, sep=",")



###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### ###### 
# [wb]: Plot average perceptual scale
mydata <-read.csv(outputFileName)
average <- rowMeans(x=mydata, na.rm=TRUE)  #calculate the mean
mydata <- cbind(mydata, average)

mydata <- gather(mydata, c(subs, 'average'), key = 'subject',value = perc)
mydata_vids <- rep(vid, length(subs)+1)
mydata <- cbind(mydata, mydata_vids)


p <- ggplot(data = mydata, aes(x=mydata_vids,y=perc, color=subject)) +
  geom_line() + geom_point() 
p <- p+scale_color_manual(values=c("#fe3d66","#e1e9fa","#c2d4f4", "#a8c5ef","#a4beef"))
p <- p+labs(title = "MLDS results",x="Physical Bending Stiffness Parameters",y="Perceptual Scale")+theme(plot.title = element_text(hjust = 0.5))
p <- p + scale_x_continuous(breaks=1:nStim, labels=vid) 


file_name = 'All_PerceptualScale'
postscript(file = paste(file_name, '.eps', sep=""), width = 6, height = 4)
print(p)
dev.off() 