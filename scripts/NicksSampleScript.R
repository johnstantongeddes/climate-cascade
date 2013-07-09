# Co-occurrence algorithms and metrics for testing
# 25 May 2013
# NJG
rm(list=ls())
# ###############################################
# Function to Calculate Number Of Species Combinations
##
##

Species.Combo <- function(m=matrix(rbinom(100,1,0.5),nrow=10))
{
  
  m <- m[which(rowSums(m)>0),] # make calculation on submatrix with no missing species
  print(m)
  return(ncol(unique(m,MARGIN=2))) # number of columns in submatrix of uniques
    
}
#############################################
## Checkerboard function function
## Takes a binary presence absence matrix
## returns number of checkerboard pairs
##
##

Checker <- function(m=matrix(rbinom(100,1,0.5),nrow=10)) 
  
{
  m <- m[which(rowSums(m)>0),] # make calculation on submatrix with no missing species
  print(m)
  pairwise <- cbind(t(combn(nrow(m),2)),0) # set up pairwise species list
  
        
  shared <- mat.or.vec(1,nrow(pairwise))
  
  for (i in 1:nrow(pairwise)) 
  {
    shared[i] <- sum(m[pairwise[i,1],]==1 & m[pairwise[i,2],]==1)
  }
 

  
  return(sum(shared==0)) # return number of pairs with no shared sites
  
}
#############################################
## C-score function
## Takes a binary presence absence matrix
## returns Stone and Roberts C-score
##
##

C.Score <- function(m=matrix(rbinom(100,1,0.5),nrow=10)) 
  
{
  m <- m[which(rowSums(m)>0),] # make calculation on submatrix with no missing species
  print(m)
  pairwise <- cbind(t(combn(nrow(m),2)),0) # set up pairwise species list
  
  
  C.score <- mat.or.vec(nrow(pairwise),1)
  shared <- mat.or.vec(nrow(pairwise),1)
  
  for (i in 1:nrow(pairwise)) 
  {
    shared[i] <- sum(m[pairwise[i,1],]==1 & m[pairwise[i,2],]==1)
    C.score[i] <- (sum(m[pairwise[i,1],]) - shared[i])*
                  (sum(m[pairwise[i,2],]) - shared[i])
      
      
  }
  
  
  
  return(mean(C.score)) # return average C-score
  
}
######################################################################
#############################################
## C-score variance function
## Takes a binary presence absence matrix
## returns variance of Stone and Roberts C-score
##
##

C.Score.var <- function(m=matrix(rbinom(100,1,0.5),nrow=10)) 
  
{
  m <- m[which(rowSums(m)>0),] # make calculation on submatrix with no missing species
  print(m)
  pairwise <- cbind(t(combn(nrow(m),2)),0) # set up pairwise species list
  
  
  C.score <- mat.or.vec(nrow(pairwise),1)
  shared <- mat.or.vec(nrow(pairwise),1)
 
  for (i in 1:nrow(pairwise)) 
  {
    shared[i] <- sum(m[pairwise[i,1],]==1 & m[pairwise[i,2],]==1)
    C.score[i] <- (sum(m[pairwise[i,1],]) - shared[i])*
      (sum(m[pairwise[i,2],]) - shared[i])
    
    
  }
  
  
  
  return(var(C.score))  # return variance of pairwise C-score
  
}
######################################################################
#############################################
## C-score skew function
## Takes a binary presence absence matrix
## returns skewness of Stone and Roberts C-score
##
##

C.Score.skew <- function(m=matrix(rbinom(100,1,0.5),nrow=10)) 
  
{
  m <- m[which(rowSums(m)>0),] # make calculation on submatrix with no missing species
  print(m)
  pairwise <- cbind(t(combn(nrow(m),2)),0) # set up pairwise species list
  
  
  C.score <- mat.or.vec(nrow(pairwise),1)
  shared <- mat.or.vec(nrow(pairwise),1)
  
  for (i in 1:nrow(pairwise)) 
  {
    shared[i] <- sum(m[pairwise[i,1],]==1 & m[pairwise[i,2],]==1)
    C.score[i] <- (sum(m[pairwise[i,1],]) - shared[i])*
      (sum(m[pairwise[i,2],]) - shared[i])
    
    
  }
  
  m3 <- mean((C.score-mean(C.score))^3)
  C.score.skew <- m3/(sd(C.score)^3)
  
  
  return(C.score.skew)  # return skewness of pairwise C-score
  
}
######################################################################
## Schluter's V-ratio function
## Takes a binary presence absence matrix
## returns Schluter's V-ratio index
##
##
V.Ratio <- function(m=matrix(rbinom(100,1,0.5),nrow=10)) 
{
  m <- m[which(rowSums(m)>0),] # make calculation on submatrix with no missing species
print(m)

v <- var(colSums(m))/sum(apply(m,1,var))
  return(v)
}

###############################################
######################################################################
#############################################
## SIM9 function
## Takes a binary presence absence matrix
## returns a new matrix with same number of rows and columns
## uses swapping function from Denitz
##

SIM9 <- function(m=matrix(rbinom(100,1,0.5),nrow=10)) 
  
{
  m <- m[which(rowSums(m)>0),] # make calculation on submatrix with no missing species
  print("m ="); print(m)
  Burn.In <- max(c(10*nrow(m),1000)) # set the burn-in
# select two random rows and create submatrix
 for(i in 1:Burn.In)
 {
  ran.rows <- sample(nrow(m),2)
  
  m.pair <- m[ran.rows,]
  
 
  
# find columns if any in pair for which colsum =1; these can be swapped
  
    Sum.Is.One <- which(colSums(m.pair)==1)
  
  if(length(Sum.Is.One)>1)
  {
# swap them in m.pair.swapped
    m.pair.swapped <- m.pair
    m.pair.swapped[,Sum.Is.One] <- m.pair[,sample(Sum.Is.One)]
    
# return the two swapped rows to the original m matrix
    
    m[ran.rows,] <- m.pair.swapped
    
  }
 }
  return(m)
}
SIM9()
