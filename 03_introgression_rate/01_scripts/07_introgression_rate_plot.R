######### Introgression Rate Estimation from ELAI output Medianes ##############

## Maeva 
## July 2018

library(dplyr)


     
    Freq_Rec_plot<- function(x,  title) {
      
      png(paste0("04_plot/",title,".png"), width = 2000, height = 1200)
      
        x<-na.omit(x) 
        limitchromosomes=1:42
        ticks=NULL
        lastbase=0
        lastbase2=0
        numchroms=length(unique(x$lg))
        chrlist=1:42
        
        # create a new dataframe with LG, BP and freq
        d=data.frame(LG=x$lg, BP=x$snps, freq=x$Freq)
        d <- d[order(d$LG, d$BP), ]
        d$newpos=NA
        d$pos = NA
        
        for (i in limitchromosomes)
        {
          firstbase= min(d[d$LG == i,]$BP)
          d[d$LG==chrlist[i], ]$newpos= d[d$LG==chrlist[i], ]$BP -firstbase
        }
        
        for (i in limitchromosomes)
        {
          if (i==1) {
            d[d$LG==chrlist[i], ]$pos=d[d$LG==chrlist[i], ]$newpos}  
          else {
            lastbase=lastbase+tail(subset(d,LG==chrlist[i-1])$newpos, 1) 
            d[d$LG==chrlist[i], ]$pos=d[d$LG==chrlist[i], ]$newpos+lastbase 
          }
          
          ticks = c(ticks, (min(d[d$LG == i,]$pos) + max(d[d$LG ==i,]$pos))/2 + 1) 
          
        }
        
        
        # settings the plot
        
        with(d, plot(pos,rep(0.1,nrow(d)),ylim=c(0,0.6),type = "n", main=title ,bty="n",ylab="introgression rate",xlab="LGs",xaxt="n",yaxt="n",col="white"))
        axis(1, at=ticks, lab=chrlist, cex.axis=0.9)
        axis(2, at=c(0, 0.2, 0.4, 0.6), cex.axis=0.8,line = -1.5,las=1)
        
        ### plot lines and rectangles with different colors by LG 
        for (i in (1:22)) {
          rect(min(d[d$LG==chrlist[((2*i)-1)],]$pos),0,max(d[d$LG==chrlist[((2*i)-1)],]$pos),14,col="grey87",border = NA) # if tick by "pos" -> change line by pos
        }
        
        
        ### plot with alternate color between points 
        for (i in unique(d$LG)) {
          if ((i %% 2) == 0 ) {  # nbr paire
            b<-subset(d, LG==i)
            points(b$pos, b$freq, col="royalblue1", type="l", lwd=2, pch=20)
          } else {           #nbr impaire
            c<-subset(d, LG==i)
            points(c$pos, c$freq, col="royalblue4", type="l", lwd=2, pch=20)
          }
          
        }
        dev.off()
      }
      
      

   
    files <- list.files(path="03_data_merged/", pattern="*_introgression_rate_all_LGs.txt", full.names=FALSE, recursive=FALSE)
    lapply(files, function(x) {
      filename <- sub("_introgression_rate_all_LGs.txt", '', x)
      print(filename)
    
      t <- read.table(paste0("03_data_merged/",x), header=TRUE) # load file
           out<-Freq_Rec_plot(t, filename)
        })


