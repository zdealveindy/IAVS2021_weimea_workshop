# Exercise 1: CWM on Vltava forest vegetation data

library (weimea) # check https://anadat-r.davidzeleny.net/doku.php/en:cwm_fc_r how to install
data (vltava)  # load Vltava dataset

# Prepare variables
com <- vltava$herbs$spe  # species composition data
cover <- vltava$env$COVERE32  # environmental vector (cover of tree layer = light availability)
SLA <- vltava$herbs$traits$SLA  # trait vector (specific leaf area)

# Calculate CWM of SLA and relate it to SLA by standard parametric test (regression)
CWM_SLA <- cwm (com = com, traits = SLA)
head (CWM_SLA)

LM <- lm (CWM_SLA$traits ~ cover)
summary (LM)  # standard parametric F-test shows P < 0.001

plot (CWM_SLA$traits ~ cover)
abline (lm (CWM_SLA$traits ~ cover))

# CWM calculated from randomized trait values
CWM_SLA_rand <- cwm (com = com, traits = sample (SLA))
plot (CWM_SLA_rand$traits ~ cover)
LM_rand <- lm (CWM_SLA_rand$traits ~ cover)
anova (LM_rand)

P_rand <- replicate (100, expr = {
  CWM_SLA_rand <- cwm (com = com, traits = sample (SLA))
  LM_rand <- lm (CWM_SLA_rand$traits ~ cover)
  anova (LM_rand)$`Pr(>F)`[1]
})

sum (P_rand < 0.05)  # ca 28 out of 100 are significant at P < 0.05 (should be around 5)

# Test the CWM~env relationship using max permutation test
CWM_cover <- test_cwm (cwm = CWM_SLA, env = cover, method = 'lm', test = 'all', perm = 999)
CWM_cover

plot (CWM_cover)

# max test 100 x repeated on randomized trait data
CWM_cover_rand_100 <- replicate (100, simplify = 'matrix', expr = {
  CWM_cover_rand <- test_cwm (cwm = cwm (com, sample (SLA)), env = cover, method = 'lm', test = 'all', perm = 999)
  coef (CWM_cover_rand)[,c("P_par", "P_row", "P_col", "P_max")]
})

apply (CWM_cover_rand_100, MARGIN = 1, FUN = function (x) sum (x < 0.05))
# P_par P_row P_col P_max 
# 24    27     6     6


# CWM-env on more than one trait
traits <- vltava$herb$traits
traits$seed.weight <- log10 (traits$seed.weight) # log transform skewed seed weight values

CWM <- cwm (com = com, traits = traits)
CWM_env <- test_cwm (cwm = CWM, env = vltava$env[, c('COVERE32', 'pH', 'HEAT.LOAD')], method = 'lm', test = 'max')
plot (CWM_env)

CWM_env_wreg <- test_wreg (com = com, traits = traits, env = vltava$env[, c('COVERE32', 'pH', 'HEAT.LOAD')], test = 'max')
plot (CWM_env_wreg, )

CWM_env_four <- test_fourth (com = com, traits = traits, env = vltava$env[, c('COVERE32', 'pH', 'HEAT.LOAD')], test = 'max')
plot (CWM_env_four)

# CWM-env relationship with qualitative env. variable
shallow_soil <- as.factor (as.numeric (vltava$env$SOILDPT < 20))
CWM_soil <- test_cwm (cwm = CWM, env = as.factor (shallow_soil), method = 'aov', test = 'standard')
CWM_soil
plot (CWM_soil)

# Example 2 - relating mean Ellenberg indicator values to ordination axes
com <- vltava$herbs$spe
civ <- vltava$herbs$civ[,1:5]

library (vegan)
DCA <- decorana (log1p (com))
ordiplot (DCA)
com_pa <- decostand (com, method = 'pa')

mCIV <- cwm (com = com_pa, traits = civ)
mCIV

ef <- envfit (DCA, mCIV, na.rm = TRUE)
plot (ef)

# do the same on randomized EIVs
civ_rand <- apply (civ, 2, sample)
mCIV_rand <- cwm (com = com_pa, traits = civ_rand)
ef_rand <- envfit (DCA, mCIV_rand)
ef_rand
plot (ef_rand, col = 'red')

# apply modified permutation test on envfit
ef_modif <- envfit_cwm (DCA, mCIV, na.rm = TRUE)
ef_modif
ordiplot (DCA)
plot (ef_modif, p.max = 0.05)

civ_rand <- apply (civ, 2, sample)
mCIV_rand <- cwm (com = com_pa, traits = civ_rand)
ef_rand <- envfit_cwm (DCA, mCIV_rand)
ef_rand
plot (ef_rand, p.max = 0.05, col = 'red')

# Modified permutation test with qualitative variable (vegetation type)
vegtype <- cutree (hclust (dist (log1p (com)), method = 'ward.D'), k = 4)
ordiplot (DCA, display = 'si', type = 'n')
points (DCA, col = vegtype, pch = vegtype)

civ_vegtype <- test_cwm (cwm = mCIV, env = as.factor (vegtype), method = 'aov', test = c('parametric', 'modified'))
civ_vegtype
plot (civ_vegtype)
