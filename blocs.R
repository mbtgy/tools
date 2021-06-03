blocs = function(x, var.num=NULL, lags = rep(0, length(levels(x)))){
  lags = data.frame(lev = levels(x), lag = lags)
  length=clust=position=cumul=maximum=NULL
  b=!is.null(var.num)
  i=1
  while (i<=length(x)){
    if (is.na(x[i])){while (is.na(x[i])){i=i+1}}
    cl=x[i] ; pos=i ; l=1
    if (b){cum = var.num[i];max = var.num[i]}
    while (cl %in% x[(i+1):min(length(x), i+1+lags[lags$lev==cl,"lag"])] 
           & i<length(x)){
      rgstop = max(which(x[(i+1):min(length(x), 
                   i+1+lags[lags$lev==cl,"lag"])]==cl))
      if (b){cum = cum + sum(var.num[(i+1) : (i+rgstop)], na.rm=T)
             max = max(c(max, var.num[(i+1) : (i+rgstop)]), na.rm=T)}
      l=l+rgstop ; i=i+rgstop
    }
    i=i+1
    length=c(length, l)
    clust = c(clust, as.character(cl))
    position=c(position,pos)
    if (b){cumul = c(cumul, cum)
    maximum = c(maximum, max)}
  }
  if (b) {blocs=data.frame(position, clust, length, cumul, maximum)
    blocs$mean = blocs$cumul/blocs$length
    return(blocs)
  }else{return(data.frame(position, clust, length))}
}
