#Import data

#This way didn't work because complains of Java out of memory
# dyn.load('/Library/Java/JavaVirtualMachines/jdk-9.0.4.jdk/Contents/Home/lib/server/libjvm.dylib') #modified from https://stackoverflow.com/questions/46366520/rjava-loading-error
# require(rJava)
# library(xlsx)
#gr3day <- read.xlsx("../AllConditions_for_Holcombe.xlsx", sheetName = "3-day Condition")

#So, saved the sheets as csv files.

fileWithPath<- file.path("..","three_day.csv")
file.exists( fileWithPath )
three_day <- read.table(fileWithPath, header=TRUE, sep=",")
save(three_day,file=file.path("dataRaw",'three_day.RData'))
