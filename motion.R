#### 1. Vitesse de deplacement ####
motion = function(i1, i2, rg.vx=-10:10, rg.vy=-10:10){
  C=t(sapply(rg.vx, function(i, i1, i2){
    sapply(rg.vy, function(j, i, i1, i2){
      # zone de l'image a prendre en compte
      rgr = 1:nrow(i1) -i
      rgr[!rgr %in% c(1:nrow(i1))] = NA
      rgc = 1:ncol(i1) +j
      rgc[!rgc %in% c(1:ncol(i1))] = NA
      # calcul de la correlation
      cor(c(i1), c(i2[rgr, rgc]), use="complete.obs")
    },i=i, i1=i1, i2=i2)
  }, i1=i1, i2=i2))
  if (all(is.na(c(C)))){return(c(NA,NA))}else{
    # max de correlation
    w = which(C == max(C, na.rm=T), arr.ind=T)
    return(c(rg.vx[w[1,1]], rg.vy[w[1,2]]))
  }
}

#### 2. Interpolation ####
interp = function(i1, i2, v, search=expand.grid(-12:12, -12:12), n=5){
  m=dim(i1)[1] ; p=dim(i1)[2]
  out = array(NA, c(m, p, n+1), 
              dimnames=list(dimnames(i1)[[1]], dimnames(i1)[[2]], (0:n)/n))
  out[,,1] = i1
  out[,,n+1] = i2
  for (f in c(1:n-1)/n){
    # en partant de t (i1)
    A = search[abs(search[,1]+f*v[1])<1 & abs(search[,2]+f*v[2])<1,]
    A = cbind(A,w=apply(A,1,function(x){
                          (1-abs(x[1]+f*v[1]))*(1-abs(x[2]+f*v[2]))
                        }))
    M = vapply(1:nrow(A),FUN=function(i){
        rgr = 1:m + A[i,1]
        rgr[!rgr %in% 1:m] = NA
        rgc = 1:p + A[i,2]
        rgc[!rgc %in% 1:p] = NA
        return(A[i,3]*i1[rgr,rgc])
    }, FUN.VALUE=matrix(0,nrow=m,ncol=p))
    M = apply(M,c(1,2),sum)
    
    # en partant de t+5min (i2)
    A = search[abs(search[,1]+(1-f)*v[1])<1 & abs(search[,2]+(1-f)*v[2])<1,]
    A = cbind(A,w=apply(A,1,function(x){
                          (1-abs(x[1]+(1-f)*v[1]))*(1-abs(x[2]+(1-f)*v[2]))
                        }))
    M2 = vapply(1:nrow(A),FUN=function(i){
        rgr=1:m - A[i,1]
        rgr[!rgr %in% 1:m] = NA
        rgc=1:p - A[i,2]
        rgc[!rgc %in% 1:p] = NA
        return(A[i,3]*i2[rgr,rgc])
    }, FUN.VALUE=matrix(0,nrow=m,ncol=p))
    M2 = apply(M2,c(1,2),sum)
    
    M[is.na(M)] = M2[is.na(M)]
    M2[is.na(M2)] = M[is.na(M2)]
    dimnames(M) = dimnames(M2) = dimnames(i1)
    
    # moyenne ponderee des 2 interpolations
    out[,,n*f+1] = (1-f)*M + f*M2
  }
  return(out)
}
