CHTNsa <- function(age, sex, systolic, diastolic, height) {
  
  ag <- trunc(age)
  
  if(ag<= 2) {
    stop("Age is out of range (aged <=2 years)")
  }
  
  sx <- sex
  sbp <- round(systolic)
  dbp <- round(diastolic)
  ht <- round(height,1)
  
  if(ag>=18) {
    
    
    if(sbp < 120) {
      print("SBP: Normotensive")
    } else if(sbp >= 120 & sbp < 130) {
      print("SBP: Elevated")
    } else if(sbp >= 130 & sbp < 140) {
      print("SBP: Stage 1")
    } else {
      print("SBP: Stage 2")
    }
    
    
    if(dbp < 80) {
      print("DBP: Normotensive")
    } else if(dbp >= 80 & dbp < 90) {
      print("DBP: Stage 1")
    } else {
      print("DBP: Stage 2")
    }
    
  } else {
    
    #**************************************************** 
    # Manually set directory to location of BPTABLES.rds (saved locally) or load BP tables from github (only supported on windows)
    urlfile <-
      'https://raw.githubusercontent.com/mkarmstrong/PediatricBP/main/BPTABLES.csv'
    ll <- read.csv(urlfile)
    #****************************************************
    
    ll2 <- ll[ll$sex == sx, ]
    ll3 <- ll2[ll2$age == ag, ]
    stab <- ll3[ll3$bp == "sbp", ]
    dtab <- ll3[ll3$bp == "dbp", ]
    
    
    #SYSTOLIC ============================
    
    sp.tile = NA
    
    if (ht < stab$h.cm[1]) {
      sp.tile <- stab[1,]
    } else if(ht >= stab$h.cm[7]) {
      sp.tile <- stab[7, ]
    } else {
      sp.tile <- stab[which(ht < stab$h.cm)[1]-1, ]
    }
    
    
    if(sbp >= sp.tile$bpC9512) {
      print("SBP: Stage 2", quote = F)
    } else if(sbp >= sp.tile$bpC95 & sbp < sp.tile$bpC9512) {
      print("SBP: Stage 1", quote = F)
    } else if(sbp >= sp.tile$bpC90 & sbp < sp.tile$bpC95) {
      print("SBP: Elevated", quote = F)
    } else if(sbp >= sp.tile$bpC50 & sbp < sp.tile$bpC90){
      print("SBP: Normotensive", quote = F)
    } else {
      print("SBP: Normotensive < c50", quote = F)
    }
    
    
    #DIASTOLIC ============================
    
    dp.tile <- NA
    
    if (ht < dtab$h.cm[1]) {
      dp.tile <- dtab[1,]
    } else if(ht >= dtab$h.cm[7]) {
      dp.tile <- dtab[7, ]
    } else {
      dp.tile <- dtab[which(ht < dtab$h.cm)[1]-1, ]
    }
    
    
    if(dbp >= dp.tile$bpC9512) {
      print("DBP: Stage 2", quote = F)
    } else if(dbp >= dp.tile$bpC95 & dbp < dp.tile$bpC9512) {
      print("DBP: Stage 1", quote = F)
    } else if(dbp >= dp.tile$bpC90 & dbp < dp.tile$bpC95) {
      print("DBP: Elevated", quote = F)
    } else if(dbp >= dp.tile$bpC50 & dbp < dp.tile$bpC90){
      print("DBP: Normotensive", quote = F)
    } else {
      print("DBP: Normotensive < c50", quote = F)
    }
    
    
    if(ag >= 13) {
      message("Note: for individuals aged >=13, the adult AHA guidlines may be used instead")
    }
    
    #PLOT ================================
    
    hcent <- sp.tile[["h.cent"]]
    plotdf <- ll2[ll2$h.cent == hcent, c("age", "bpC50", "bpC90", "bpC95", "bpC9512", "bp")]
    
    splot <- plotdf[plotdf$bp == "sbp", -length(plotdf)]
    dplot <- plotdf[plotdf$bp == "dbp", -length(plotdf)]
    spdplot <- cbind(splot, dplot)
    
    
    matplot(
      spdplot$age,
      spdplot[, c(-1, -6)],
      main = "SBP & DBP cut offs",
      type = "l",
      lwd = 2.5,
      lty = c(1, 3, 3, 1, 1, 3, 3, 1),
      col = c(
        "seagreen4",
        "seagreen4",
        "firebrick",
        "firebrick",
        "seagreen4",
        "seagreen4",
        "firebrick",
        "firebrick"
      ),
      xaxp  = c(2, 17, 15),
      #2 to 17 with 15 between
      ylab = "mmHg",
      xlab = "Age (y)"
    )
    grid()
    points(ag, sbp, pch = 8, cex=1.5, col = "dodgerblue3",lwd = 2.5)
    points(ag, dbp, pch = 8, cex=1.5, col = "dodgerblue3",lwd = 2.5)
    
  }
  
}
