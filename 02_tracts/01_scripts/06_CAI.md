## CAI estimation 
## R code in process.. 

### Step 1: Retrieve the LG length for each poulaitions from snpinfo.txt files from 01_Run_ELAI/06_outputELAI/
Create new directory 01_Run_ELAI/10_LG_size/01_length/

```
    LGsize <- function (file){
      
          df<-read.table(file, header=T)
          tab<- data.frame(matrix(ncol = 3, nrow = 1))
          name= paste(file)
         tab[1,1]=name
         tab[1,2]=df[1,2]  
         tab[1,3]=df[nrow(df), 2]
      
         namePos<- sub("\\.snpinfo\\.txt", '', file)
         filename <- paste("../10_LG_size/01_length/",namePos, "_LGlength.txt", sep="")
         write.table(tab, filename, quote = FALSE, col.names=TRUE,row.names=FALSE,sep="\t")
        }
    
       
        listfile = list.files(".", recursive = TRUE, pattern="\\.snpinfo\\.txt")
        end = length(listfile)
    
        for (i in 1:end) {
      
        LGsize(listfile[i])
    
            i=i+1
          }
```

Merged all files 

```
 setwd("../10_LG_size/01_length")

      file_list <- list.files(".", recursive = TRUE, pattern="_LGlength\\.txt")

      for (file in file_list){

        # if the merged dataset doesn't exist, create it
      if (!exists("dataset")){
       dataset <- read.table(file, header=TRUE, sep="\t")
       }
  
        # if the merged dataset does exist, append to it
      if (exists("dataset")){
       temp_dataset <-read.table(file, header=TRUE, sep="\t")
       dataset<-rbind(dataset, temp_dataset)
         rm(temp_dataset)
          }
      }
     
     dataset1<-unique(dataset)
     write.table(dataset1, "../LG_length.txt", quote = FALSE, col.names=TRUE,row.names=FALSE,sep="\t")

``` 
     
  ### Step 2: CAI estimation
     
  #### Compute the LG size 
```
     LG<-read.table("LG_length.txt", header=T)
     LG <- within(LG, length <- end - start)
 ``` 
   #### Compute the length and the number of tracts
      
  ```
   library(plyr)
   trac<-read.table("length_introgression_final_seuil0.1_final.txt", header=T)
   
   tab_sum<-aggregate( length ~ LG + pop + Ind + HET.HOM, data = trac, sum) 
   tab_nbr <- count(trac, c('LG', 'pop', 'Ind', 'HET.HOM'))
  ```
   
   #### Estimation of the percentage of domestic ancestry by chromatides and CAI estimation 
    
    ```
     tab_sum["percent"] <- NA
     
     for(t in 1:nrow(LG)){                   #tab contenant la taille totale du LG
       for (i in 1:nrow(tab_sum)){
         
         if (tab_sum[i,1]==LG[t,2] && tab_sum[i,2]==LG[t,1]){
           
           tot = LG[t,5]
           tab_sum[i,6]= (tab_sum[i,5] * 100)/ tot
         }
       }
     }
     
     percent_nbr<-merge (tab_sum, tab_nbr, by=c("LG", "pop", "Ind", "HET.HOM"))
     
     tab_HET <- subset(percent_nbr, HET.HOM=="HET") 
     tab_HOM <- subset(percent_nbr, HET.HOM=="HOM")
     
     Intro <- merge(tab_HET,tab_HOM,by=c("LG", "pop", "Ind"), all=T) 
     Intro[is.na(Intro)] <- 0              
     
     names(Intro)[6] <- "percent_HET"
     names(Intro)[10] <- "percent_HOM"
     
     # estimation of the CAI 
     Intro <- within(Intro, delta <- (percent_HET - percent_HOM)/100) 
     
     # percentage of introgression 
     Intro <- within(Intro, total_percent_intro <- (((percent_HET + percent_HOM)*100)/200)) 
     
     ### Estimation of the number of introgressed haplotype by individuals
 
     Intro <- within(Intro, nbr_trac <- freq.x + freq.y)
 
 
    ### save Tab 
 
    write.table(Intro, "summary_intro_seuil_0.1.txt", quote = FALSE, col.names=TRUE,row.names=FALSE,sep="\t")   
     
    ```
     
   #### Individuals information 
     
     ```
     require(data.table)
     Intro<-read.table("summary_intro_seuil_0.1.txt", header=T)
       
     Data <- subset( Intro, select=c(LG, pop, Ind, delta, total_percent_intro, nbr_trac) ) 
          
     dt <- data.table(Data)
    
    # example for 42 LGs 
     dt.out_test <- dt[, list(m.delta=sum(delta)/42, m.total_percent_intro=sum(total_percent_intro)/42, sum.nbr_trac=sum(nbr_trac)), 
                  by=c("pop","Ind")]
     
     
     require(ggplot2)
     
     tab<- read.table("sample_info.txt", header=T)
     tab_graph <- merge(dt.out_test,tab, by=c("pop", "Ind"), all=T)
     tab_graph[is.na(tab_graph)] <- 0 
     
     
     write.table(tab_graph, "Intro_byInd_seuil_0.1.txt", quote = FALSE, col.names=TRUE,row.names=FALSE,sep="\t")
     
     ```
     
   #### Plot 
     ```
      library(ggrepel)
     tab_graph<- read.table("Intro_byInd_seuil_0.1.txt", header=T)
     
     # label= total number of haplotype tracs
     
     
    p<-ggplot(tab_graph, aes(x=m.total_percent_intro, y=m.delta, colour=pop))+ 
       geom_point(size=2, shape=3 )  + funky(30)+
       theme_bw() +
       theme(axis.title = element_text(size = rel(1.5))) +
       xlab('Percentage of domestic ancestry') +
       ylab('Chromosomal ancestry imbalance')+
       theme(legend.position = c(0.9, 0.7))
     
      p
    
       ## Theoretical expectation 
     
     f0  <- data.frame(x = 0, y= 0, label= "F0MED", sum.nbr_trac="0")
     f1  <- data.frame(x = 50, y= 1, label="F1", sum.nbr_trac="40")
     f2  <- data.frame(x = 100, y=  0, label="F0ATL", sum.nbr_trac="80")
     
     p1<-p + geom_point(data=f0, aes(x = 0, y = 0), shape=15, size=3,  colour = "grey") +
         geom_point(data=f1, aes(x = 50, y = 1), shape=3, size=3,  colour = "grey55") +
         geom_point(data=f2, aes(x = 100, y = 0), shape=17, size=3,  colour = "grey") +
      
       annotate("text", x = 0, y = -0.05, label = "F0_wild", color = "grey55", size=4) +
       annotate("text", x = 50, y = 1.05, label = "F1", color = "grey55", size=4) +
       annotate("text", x = 100, y = -0.05, label = "F0_dom", color = "grey55", size=4) 
     
     p1
     ggsave(
       "CAI_Percent_allpop_seuil0.1.png",
       p1,
       width = 11,
       height = 7,
       dpi = 900
     )
     
     ``` 
     
     
      
     
     
     
