# FUNCTION 1: ECAV.reliability.overall
 # Description: evaluate the overall reliability using different metrics
 # Arguments:
    # alldata (the "maindata" object contained in ECAV_reliability_mainenvironment.RData file)
    # variables (a list of variables names to be analyzed specified in accordance with the ECAV_reliability_mainenvironment.RData file)
    # irrmetric (a vector of metrics, supports "agree", "kappam.fleiss" and "kripp.alpha" from the irr package)
    # plot(to be implemented)

ECAV.reliability.overall<-function(alldata, variables, irrmetric, print.console=F){
  library(irr)
  return.objects<-list()
  
  for(v in 1:length(variables)){
    
    # subset data
    mydata.text<-paste("mydata<-alldata[,",variables[v],"]")
    eval(parse(text=mydata.text))
      
    # overall - calculate reliability
      for (i in 1:length(irrmetric)){
        
        if(irrmetric[i]=="avg.kappa"){
          
          ck.pairs<-list()
          
          for(j in 2:12){
            for(z in 2:12){
              if(j!= z){
                coder.b<-mydata[,j]
                coders.ab<-cbind(mydata[,z],mydata[,j])
                k<-kappa2(coders.ab)
                ck.pairs<-append(k$value,ck.pairs)
              }
            }
          }
          ck.pairs<-as.numeric(ck.pairs)
          assessment.text<-paste("assessment",i,"<-","mean(ck.pairs)", sep="")
          eval(parse(text=assessment.text))
        }
        
        if(irrmetric[i]=="agree"){
          assessment.text<-paste("assessment",i,"<-","agree(mydata[,2:12], tolerance=0)", sep="")
          eval(parse(text=assessment.text))
        }
        if(irrmetric[i]=="kappam.fleiss"){
          assessment.text<-paste("assessment",i,"<-","kappam.fleiss(mydata[,2:12], detail=T)", sep="")
          eval(parse(text=assessment.text))
        }
        if(irrmetric[i]=="kripp.alpha"){
          assessment.text<-paste("assessment",i,"<-","kripp.alpha(t(as.matrix(mydata[,2:12])), method=c('nominal'))", sep="")
          eval(parse(text=assessment.text))
        }
      }
    
      # overall - print on console and return object
      return.object<-list()
      for (i in 1:length(irrmetric)){
        # print on console
        if(print.console==T){
         cat("\n","~~~~~",variables[v],"-",irrmetric[i],"~~~~~","\n")
         output.text<-paste("print(assessment",i,")", sep="")
         eval(parse(text=output.text))
        }
        # create object to be returned
        if(irrmetric[i]=="avg.kappa"){
          return.text<-paste("return.object<-append(assessment",i,",return.object)", sep="")
          eval(parse(text=return.text))
        }
        else{
          return.text<-paste("return.object<-append(assessment",i,"$value,return.object)", sep="")
          eval(parse(text=return.text))
        }
      }
      return.objects<-append(return.objects,return.object)
    }
  return.objects<-round(as.numeric(return.objects),2)
  data.output<-matrix(return.objects, nrow=length(variables), ncol=length(irrmetric), byrow = T)
  dimnames(data.output)<-list(variables,irrmetric)
  if(print.console == T){
    print(data.output)
  }
  return(data.output)
}


# FUNCTION 2: ECAV.reliability.pairs

ECAV.reliability.pairs<-function(alldata, variable, irrmetric, mhtest=F, ploto=F,cols){
  
  library(irr)
  mydata.text<-paste("mydata<-alldata[,",variable,"]")
  eval(parse(text=mydata.text))

  reliability.pairs<-list()
  marginal.pairs<-list()
  
  for (i in 2:12){
    for (j in 2:12){
      coder.b<-mydata[,j]
      coders.ab<-cbind(mydata[,i],mydata[,j])
      
      if(irrmetric == "kappam.fleiss"){
        k<-kappam.fleiss(coders.ab)
        reliability.pairs<-append(reliability.pairs,k$value)
      }
      
      if(irrmetric == "agree"){
        k<-agree(coders.ab)
        reliability.pairs<-append(reliability.pairs,k$value)
      }
      
      if(irrmetric == "kappa2"){
        k<-kappa2(coders.ab)
        reliability.pairs<-append(reliability.pairs,k$value)
      }
      if(mhtest == TRUE){
      tryCatch(
        if(i!=j){
          mht<-bhapkar(coders.ab)
          mhtp<-round(mht$p.value,2)
        }
        else{
          mhtp<-0
        }, error=function(inv){
          mhtp<-NA
        })
      marginal.pairs<-append(mhtp, marginal.pairs)
      }
    }
  }
  
  data.pairs<-matrix(reliability.pairs, nrow=11, ncol=11)
  data.pairs<-apply(data.pairs, 2,as.numeric)
  data.pairs[lower.tri(data.pairs)]<-NA
  cat(variable,"-", irrmetric, "\n")
  print(data.pairs)
  cat("min:", signif(min(data.pairs[upper.tri(data.pairs)]),1), "max:", signif(max(data.pairs[upper.tri(data.pairs)]),1), "\n")
  if(mhtest == TRUE){
    cat(variable, "- Bhapkar test", "\n")
    data.mht.pairs<-matrix(marginal.pairs, nrow=11, ncol=11)
    data.mht.pairs[lower.tri(data.mht.pairs)]<-NA
    print(data.mht.pairs)
  }
  if (ploto==T){
    library(gplots)
    score.min<-signif(min(data.pairs[upper.tri(data.pairs)]),1)
    score.breaks<-seq(score.min,1,0.1)
    
    heatmap.2(data.pairs, cellnote = round(data.pairs,2), Rowv = NA,Colv=NA, symm=T, 
              main=gsub("[[:punct:]]", " ", variable),  xlab='coder id', ylab='coder id',
              trace="none", key.title=NA,
              breaks=score.breaks, 
              col=cols)
    }
}

# FUNCTION 3: ECAV.reliability.pairs.summary

ECAV.reliability.pairs.summary<-function(alldata, variables, irrmetric){
  
  library(irr)
  scores.avg<-list()
  
  for(v in 1:length(variables)){
    
    mydata.text<-paste("mydata<-alldata[,",variables[v],"]")
    eval(parse(text=mydata.text))
    reliability.pairs<-list()
  
    for (i in 2:12){
      for (j in 2:12){
        coder.b<-mydata[,j]
        coders.ab<-cbind(mydata[,i],mydata[,j])
        
        if(irrmetric == "kappam.fleiss"){
          k<-kappam.fleiss(coders.ab)
          reliability.pairs<-append(reliability.pairs,k$value)
        }
        
        if(irrmetric == "agree"){
          k<-agree(coders.ab)
          reliability.pairs<-append(reliability.pairs,k$value)
        }
        
        if(irrmetric == "kappa2"){
          k<-kappa2(coders.ab)
          reliability.pairs<-append(reliability.pairs,k$value)
        }
        #print(paste(i,j,k$value))
      }
      
    }
    data.pairs<-matrix(reliability.pairs, nrow=11, ncol=11)
    data.pairs<-apply(data.pairs, 2,as.numeric)
    #print(data.pairs)
    score.sum<-rowSums(data.pairs)-1
    #print(score.sum)
    score.avg<-score.sum / 10
    score.avg<-round(score.avg,2)
    scores.avg<-append(scores.avg,score.avg)
  }
  scores<-matrix(scores.avg, nrow = 11, ncol=length(variables))
  rownames(scores)<-c("coder1","coder2","coder3","coder4","coder5","coder6","coder7","coder8","coder9","coder10","coder11")
  colnames(scores)<- variables 
  #print(t(scores))
  return(t(scores))
}

# FUNCTION 4: ECAV.GS.comparison

ECAV.GS.comparison<-function(alldata, variables, irrmetric, varmean=F){
  
  library(irr)
  reliability.pairs<-list()
  
  for (v in 1:length(variables)){
    mydata.text<-paste("mydata<-alldata[,",variables[v],"]")
    eval(parse(text=mydata.text))
    GS<-mydata[,1]
  
    for (i in 2:12){
      coder<-mydata[,i]
      coders.ab<-cbind(GS,coder)
      
      if(irrmetric == "kappam.fleiss"){
        k<-kappam.fleiss(coders.ab)
        reliability.pairs<-append(reliability.pairs,k$value)
      }
      
      if(irrmetric == "kappa2"){
        k<-kappa2(coders.ab)
        reliability.pairs<-append(reliability.pairs,k$value)
      }
      if(irrmetric=="kripp.alpha"){
        k<-kripp.alpha(t(as.matrix(coders.ab)), method=c('nominal'))
        reliability.pairs<-append(reliability.pairs,k$value)
        }
      
      #cat(variables[v],print(colnames(mydata[1])),print(colnames(mydata[i])), k$value, "\n")
    }
  }
  GScomparisons<-matrix(reliability.pairs, nrow = length(variables), ncol=11, byrow = TRUE)
  GScomparisons<-apply(GScomparisons, 2,as.numeric)
  colnames(GScomparisons)<-c("coder1","coder2","coder3","coder4","coder5","coder6","coder7","coder8","coder9","coder10","coder11")
  rownames(GScomparisons)<- variables
  
  if (varmean == F){
    rownames(GScomparisons)<- variables
    return(round(GScomparisons,2))
  }
  if (varmean == T){
    GScomparisons<-apply(GScomparisons, 2,as.numeric)
    GScomparisons.means<-rowMeans(GScomparisons)
    rownames(GScomparisons)<- variables
    return(GScomparisons.means)
  }
}

