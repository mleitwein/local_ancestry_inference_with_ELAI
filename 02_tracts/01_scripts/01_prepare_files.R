require(dplyr)

step1 <- function(pop,LG){
	
	  panel_list = list.files(path="01_Run_ELAI/07_Medianes/", pattern=paste0(pop,"_mg*[0-9]*.sf",LG,"_MEDiANreplicates.ps21.txt"))
				panel= lapply(paste0("01_Run_ELAI/07_Medianes/",panel_list), function(x) read.table( x))
				panel<-panel[[1]]
	  
	  snpinfo_list = list.files(path="01_Run_ELAI/06_outputELAI/", pattern=paste0(pop,".sf",LG,".replicate01.numgen*[0-9]*.snpinfo.txt"))
				snpinfo= lapply(paste0("01_Run_ELAI/06_outputELAI/",snpinfo_list), function(x) read.table( x, header=T))
				snpinfo<-snpinfo[[1]]	
				snp <-as.data.frame(snpinfo[,2])

				
				
	 dom<-panel[,c(TRUE, FALSE)]
	 
	  tdom=as.matrix(t(dom))
	  tdom_pos<-cbind(snp, tdom)
	  result = paste("02_tracts/temps_file_OMR/",pop,"_sf",LG,".dom.res",sep="")
	  write.table(tdom_pos, file=result, row.names=FALSE, col.names=FALSE)
   }


print ("END FIRST STEP")


data <- read.table("02_tracts/02_info/populations_and_numbers_of_generations.csv.all.pops", sep=",")


    for (i in c(1:nrow(data))){
	 for (j in c(1:42)){
       arg1=data[i,1] %>% as.character(.)
        step1(arg1, as.character(j))
      }
    }
    
