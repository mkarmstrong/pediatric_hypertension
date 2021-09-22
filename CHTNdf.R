CHTNdf <- function(x, simple = TRUE) {
  
  #  GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007
  #  Copyright 2021 Matthew K. Armstrong (matthew.armstrong@utas.edu.au)
  #  Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
  #  Everyone is permitted to copy and distribute verbatim copies
  #  of this license document, but changing it is not allowed.
  #
  #  This program is distributed in the hope that it will be useful,
  #  but WITHOUT ANY WARRANTY; without even the implied warranty of
  #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  #  GNU General Public License for more details.
  #  http://www.gnu.org/licenses/gpl.html
  
  
  x <- x[ , c("id","age.y","sex","height.cm","systolic","diastolic")]
  
  BPfunction <- function(x) 
  {
    id = x["id"]
    print(unname(id))
    ag = trunc(x["age.y"])
    sbp = round(x["systolic"])
    dbp = round(x["diastolic"])
    sx = x["sex"]
    ht = round(x["height.cm"], 1)
    
    if(ag <= 2) {stop("Age is out of range")} #stop if age is <2y
    
    spc = NA
    dpc = NA
    #====================
    
    if(ag>=18) 
    {
      
      if(sum(is.na(c(sbp,dbp))) >= 1) { #leave as NA if is.na(NA)
        
      } else {
        
        if(sbp < 120) 
        {spc = 0} 
        else if(sbp >= 120 & sbp < 130) 
        {spc = 0.5} 
        else if(sbp >= 130 & sbp < 140) 
        {spc = 1} 
        else {spc = 2}
        
        
        if(dbp < 80) 
        {dpc = 0} 
        else if(dbp >= 80 & dbp < 90) 
        {dpc = 1} 
        else {dpc = 2}
        
      }
      
    } else { 
      
      
      #**************************************************** 
      # Manually set directory to location of BPTABLES.rds (saved locally) or load BP tables from github (only supported on windows)
      urlfile <-
        'https://raw.githubusercontent.com/mkarmstrong/PediatricBP/main/BPTABLES.csv'
      ll <- read.csv(urlfile)
      #****************************************************
      
      
      
      ll2 <- ll[ll$sex == sx,]
      ll3 <- ll2[ll2$age == ag,]
      stab <- ll3[ll3$bp == "sbp",]
      dtab <- ll3[ll3$bp == "dbp",]
      
      if(sum(is.na(c(ag,sx,ht,sbp,dbp))) >= 1) { #leave as NA if missing values
        
      } else {
        
        #SYSTOLIC ============================
        
        sp.tile <- NA
        
        if (ht < stab$h.cm[1]) 
        {sp.tile <- stab[1, ]} 
        else if (ht >= stab$h.cm[7]) 
        {sp.tile <- stab[7,]} 
        else {sp.tile <- stab[which(ht < stab$h.cm)[1] - 1,]}
        
        
        if (sbp >= sp.tile$bpC9512) 
        {spc <- 2} 
        else if (sbp >= sp.tile$bpC95 & sbp < sp.tile$bpC9512) 
        {spc <- 1} 
        else if (sbp >= sp.tile$bpC90 & sbp < sp.tile$bpC95) 
        {spc <- 0.5} 
        else if (sbp >= sp.tile$bpC50 & sbp < sp.tile$bpC90) 
        {spc <- 0} 
        else {spc <- 0}
        
        
        #DIASTOLIC ============================
        
        dp.tile <- NA
        
        if (ht < dtab$h.cm[1]) 
        {dp.tile <- dtab[1, ]} 
        else if (ht >= dtab$h.cm[7]) 
        {dp.tile <- dtab[7,]} 
        else {dp.tile <- dtab[which(ht < dtab$h.cm)[1] - 1,]}
        
        
        if (dbp >= dp.tile$bpC9512) 
        {dpc <- 2} 
        else if (dbp >= dp.tile$bpC95 & dbp < dp.tile$bpC9512) 
        {dpc <- 1} 
        else if (dbp >= dp.tile$bpC90 & dbp < dp.tile$bpC95) 
        {dpc <- 0.5} 
        else if (dbp >= dp.tile$bpC50 & dbp < dp.tile$bpC90) 
        {dpc <- 0} 
        else {dpc <- 0}
        
        
        ################################
        
        if(isTRUE(simple)) 
        {
          
          if(ag >= 13) 
          {
            
            if(sbp < 120) 
            {spc = 0} 
            else if(sbp >= 120 & sbp < 130) 
            {spc = 0.5} 
            else if(sbp >= 130 & sbp < 140) 
            {spc = 1} 
            else {spc = 2}
            
            if(dbp < 80) 
            {dpc = 0} 
            else if(dbp >= 80 & dbp < 90) 
            {dpc = 1} 
            else {dpc = 2}
          }
        }
        
      }
      
    }
    
    c(id, ag, sx, ht, sbp, dbp, spc, dpc)
  }
  
  ans <- data.frame(t(apply(x, 1, BPfunction)))
  colnames(ans)[7:8] <- c("SPhtn", "DPhtn")
  message("Key:\n0 = NORMOTENSIVE\n0.5 = ELEVATED\n1 = STAGE 1\n2 = STAGE 2")
  
  return(ans)
}