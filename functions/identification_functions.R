

# Function 1 - ecav.identification
# Elio Amicarelli
  # Description: Create a dataset containing true positive rates and precision performances by coder with 95% bootstrapped confidence intervals
  # Arguments: data.input (an input dataset with true classes and coder's classification for each coder)
    # coder.list (a list with coders' names), ci.bootiterations (number of iterations for the bootstrapped metric distribution, default = 1000)
    # coerrection (if true 10 false positives are removed before calculation of metrics and CIs)
    # save.names (path to save the output dataset)

ecav.identification<-function(data.input,coders.list,ci.bootiterations=1000,correction=F,save.name){
  j=1
  newdata<- data.frame(codername= character(), metric= character(), val= numeric(0), low=numeric(0), up=numeric(0),stringsAsFactors=FALSE)
  for (coder in coders.list){
    print(coder)
    ## Calculate the main performances 
    #subset data for a specific coder
    reference<-paste("Reference_",coder,sep="")
    coder_data<-data[,names(data.input)%in%c("id_row",reference, coder)]
    coder_data<-coder_data[complete.cases(coder_data),]
    if(correction == T){
      coder_data<-coder_data[1:(nrow(coder_data)-10),]
    }
    print(nrow(coder_data))
    # calculate true positive rate and precision
    print("Calculating performance metrics...")
    tp<-which(coder_data[2] == coder_data[3])
    fp<-which(coder_data[2] == 0 & coder_data[3] == 1)
    fn<-which(coder_data[2] == 1 & coder_data[3] == 0)
    tpr<-length(tp) / (length(tp)+length(fn))
    prec<-length(tp) / (length(tp)+length(fp))
    ## Calculate confidence intervals
    tpr.bootdis<-c()
    prec.bootdis<-c()
    print("Calculating confidence intervals...")
    for (i in 1:5000){
      idrows.sample<-sample(1:nrow(coder_data), nrow(coder_data), replace=T)
      boot.sample<-coder_data[idrows.sample,]
      tp.boot<-which(boot.sample[2] == boot.sample[3])
      fp.boot<-which(boot.sample[2] == 0 & boot.sample[3] == 1)
      fn.boot<-which(boot.sample[2] == 1 & boot.sample[3] == 0)
      tpr.boot<-length(tp.boot) / (length(tp.boot)+length(fn.boot))
      prec.boot<-length(tp.boot) / (length(tp.boot)+length(fp.boot))
      tpr.bootdis<-append(tpr.bootdis,tpr.boot)
      prec.bootdis<-append(prec.bootdis,prec.boot)
    }
    # bootstrap 95% ci
    tpr.percentiles<-quantile(tpr.bootdis,probs=c(0.025,0.975))
    prec.percentiles<-quantile(prec.bootdis,probs=c(0.025,0.975))
    newdata[j,]<-c(coder,"tpr",tpr,unname(tpr.percentiles))
    newdata[j+1,]<-c(coder,"prec",prec,unname(prec.percentiles))
    j=j+2
  }
  write.csv(newdata,save.name)
}
