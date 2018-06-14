#SHOULD ADD LABELING OF CONDITION, DON'T NEED SUBJECT NUMBER IN ANNOTATON
plotBunch<- function(df,curves,minSPE,maxSPE) {
  #Columns are epochs
  #Label rows by Subject+targetSP combinations. Outermost label is Subject, inner is targetSP
  g=ggplot(df, aes(x=SPE)) + facet_grid(Subject+targetSP~Epoch) #,  scales="free_y")
  g<-g+geom_histogram(binwidth=1,color="grey90") + xlim(minSPE,maxSPE)
  g<-g+ geom_text(x=12, y= 33, aes(label = Subject)) #inset subject name/number. Unfortunately it overwrites itself a million times
  g<-g +theme_apa() #+theme(panel.grid.minor=element_blank(),panel.grid.major=element_blank())# hide all gridlines.
  #g<-g+ theme(line=element_blank(), panel.border = element_blank())
  sz=.6
  #Plot the underlying Gaussian , not just the discretized Gaussian. But it's way too tall. I don't know if this is 
  #a scaling problem or what actually is going on.
  #g<-g + geom_line(data=gaussFine,aes(x=x,y=gaussianFreq),color="darkblue",size=1.2)
  
  if (!is.null(curves)) {
    g<-g+ geom_point(data=curves,aes(x=x,y=combinedFitFreq),color="chartreuse3",size=sz)
    #g<-g+ geom_line(data=curves,aes(x=x,y=guessingFreq),color="yellow",size=sz)
    #Discretized Gaussian
    #g<-g+ geom_line(data=curves,aes(x=x,y=gaussianFreq),color="lightblue",size=sz)
    
    #mixSig - whether mixture model statistically significantly better than guessing
    curves <- dplyr::mutate(curves, mixSig = ifelse(pLRtest <= .05, TRUE, FALSE)) #annotate_fit uses this to color the p-value
    g<- annotate_fit(g,curves) #assumes curvesDf includes efficacy,latency,precision
    #Somehow the which mixSig (TRUE or FALSE) is red and which green is flipped relative to plot_hist_with_fit even though
    #identical commands are used. I haven't been able to work out why.
    #g<- g + scale_color_manual(values=c("red","forestgreen")) #already done in annotate_fit
  }
  return (g)   
}  
