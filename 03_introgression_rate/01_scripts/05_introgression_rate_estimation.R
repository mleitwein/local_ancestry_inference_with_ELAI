######### Introgression Rate Estimation from ELAI output Medians ##############

#launch from 01_ELAI directory

introgression <- function (pop, LG){

      panel_list = list.files(path="07_Medianes/", pattern=paste0(pop,"_mg*[0-9].sf",LG,"_MEDiANreplicates.ps21.txt"))
      panel= lapply(paste0("07_Medianes/",panel_list), function(x) read.table( x))
      panel<-panel[[1]]
      
      # Frequence of the domestic introgression in the population
        dom <-panel[,c(TRUE, FALSE)]
        t_dom=as.data.frame(t(dom))
        nind= ncol(t_dom)
        t_dom$Freq=(((rowSums(t_dom))/nind)/2)
        
      #We add the SNPs informations
      
        snpinfo_list = list.files(path="06_outputELAI/", pattern=paste0(pop,".sf",LG,".replicate01.numgen*[0-9].snpinfo.txt"))
        snpinfo= lapply(paste0("06_outputELAI",snpinfo_list), function(x) read.table( x, header=T))
        snpinfo<-snpinfo[[1]]	
        snp <-as.data.frame(snpinfo[,2])


      # Saving this new table
    
        df<-cbind(snp, t_dom)
        names(df)[1] <-"snps"
        name<-sub("_MEDiANreplicates\\.ps21\\.txt", '', panel_list [[1]])
        filename <- paste0("../03_introgression_rate/02_data/",name, "_introgression_rate.txt")
        write.table(df, filename, quote = FALSE, col.names=TRUE,row.names=FALSE, sep="\t")


data<-read.table("02_info/populations_and_number_of_individuals.csv", sep=",")


for (i in c(1:nrow(data))){
  for (j in c(1:42)){
    arg1=data[i,1] %>% as.character(.)
    
    
   introgression(arg1, as.character(j))
  }
}  
