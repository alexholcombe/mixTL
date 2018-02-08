load( file.path("dataRaw",'three_day.RData') )
head(three_day)
library(dplyr)

#mixRSVP requires that dataframe that must have fields targetSP and SPE
names(three_day)[names(three_day) == 'TargPos'] <- 'targetSP'
names(three_day)[names(three_day) == 'Distance'] <- 'SPE'

#group 3 were trained on all serial positions
three3<- three_day %>% filter(Group==3)

# for the 3-Day condition, the training blocks (all serial positions 3-14, because group 3) were
# blocks 2-7, 9-14, and 16-18  (blocks 1, 8, and 15 were "practice blocks" of 10 or so trials). 

blocks<-c(2:7,9:14,16:18) #training blocks for group 3
three3t <- three3 %>% filter(Block %in% blocks)

#Exclude trials where target was not presented
three3t <- three3t %>% filter(targetSP != 0)

#Exclude other cases where SPE not applicable
#Response.Pos == False indicates either		a) the participant reported "0"
# b) there was no target on that trial
# c) the participant reported a stimulus that was not presented
three3t <- three3t %>% filter(Response.Pos != FALSE)

#Plot some data

data <-three3t
numItemsInStream<- 16 #from their Methods section  

library(dplyr)

# SOA of 80 ms
#blue letter but were unsure what it was.  Participants responded using the 0 (zero) key to indicate that there was no blue letter on the catch trials.  
df<-data

#df<-df %>% dplyr::filter(subject=="BE",orientation=="Canonical",stream=="Right")
library(mixRSVP)

plotContinuousGaussian<-TRUE
annotateIt<-TRUE
minSPE<- -13 #targetSP = 14, subject reports first letter in stream (1)
maxSPE<- 13 #targetSP = 3 and response position is 16

# BE,2,1
#df<- data %>% dplyr::filter(subject=="BE" & stream=="Right" & orientation=="Canonical") 
#estimates<- analyzeOneCondition(df,numItemsInStream,parameterBounds())

g<- ggplot(df, aes(x=SPE)) + theme_apa() + geom_histogram(binwidth=1) + xlim(minSPE,maxSPE) 
g<-g+ facet_wrap(~Subject)
g
ggsave(file.path("plots","histEachSubject3dayGroup3train.png"))


g<- plot_hist_with_fit(df,minSPE,maxSPE,df$targetSP,numItemsInStream,plotContinuousGaussian,annotateIt, FALSE)
library(ggplot2)
g + annotate("text", x = 12, y = 25, label = "BE, Canonical, Right stream")
