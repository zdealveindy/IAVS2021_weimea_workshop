# Example 1: CWM of plant traits related to environment (using Vltava river valley forest vegetation dataset) ----

library (weimea) # follow https://github.com/zdealveindy/IAVS2021_weimea_workshop#readme to install the current version
data (vltava)  # load Vltava dataset from weimea package

## Prepare variables ----
com <- vltava$herbs$spe  # species composition data
cover <- vltava$env$COVERE32  # environmental vector (cover of tree layer = light availability)
SLA <- vltava$herbs$traits$SLA  # trait vector (specific leaf area)

## Calculate CWM of SLA and regress against env. vars.----
CWM_SLA <- cwm (com = com, traits = SLA) # calculate CWM
head (CWM_SLA)  # overview the data

LM <- lm (CWM_SLA$traits ~ cover) # Linear regression of CWM and env
summary (LM)  # standard parametric F-test shows P < 0.001

plot (CWM_SLA$traits ~ cover)  # plot the relationship
abline (lm (CWM_SLA$traits ~ cover))  # at the regression line

## Calculate CWM of randomized SLA and regress against env. vars. ----
CWM_SLA_rand <- cwm (com = com, traits = sample (SLA)) # randomize traits first and calculate CWM

LM_rand <- lm (CWM_SLA_rand$traits ~ cover)
summary (LM_rand) # perhaps not significant

plot (CWM_SLA_rand$traits ~ cover)

# Repeat above 100 times:
P_rand <- replicate (100, expr = {
  CWM_SLA_rand <- cwm (com = com, traits = sample (SLA))
  LM_rand <- lm (CWM_SLA_rand$traits ~ cover)
  anova (LM_rand)$`Pr(>F)`[1]
})

sum (P_rand < 0.05)  # ca 30 out of 100 are significant at P < 0.05 (should be around 5)

## Test the CWM~env relationship using max permutation test ----
CWM_cover <- test_cwm (cwm = CWM_SLA, env = cover, method = 'lm', test = 'all', perm = 999)
CWM_cover

plot (CWM_cover)  # plot the relationship using dedicated plot function

## Test the CWM~env relationship using max permutation test with more than one trait and env. variable ----
traits <- vltava$herb$traits
traits$seed.weight <- log10 (traits$seed.weight) # log transform skewed seed weight values

CWM <- cwm (com = com, traits = traits)
CWM_env <- test_cwm (cwm = CWM, env = vltava$env[, c('COVERE32', 'pH', 'HEAT.LOAD')], method = 'lm', test = 'max')
plot (CWM_env)

CWM_env_four <- test_fourth (com = com, traits = traits, env = vltava$env[, c('COVERE32', 'pH', 'HEAT.LOAD')], test = 'max')
plot (CWM_env_four)

## CWM-env relationship with qualitative env. variable ----
shallow_soil <- as.factor (as.numeric (vltava$env$SOILDPT < 20))
CWM_soil <- test_cwm (cwm = CWM, env = as.factor (shallow_soil), method = 'aov', test = 'max')
CWM_soil
plot (CWM_soil)

# Example 2 - relating mean Ellenberg indicator values to ordination axes ----
library (weimea)
library (vegan)

## Prepare variables ----
data (vltava)
com <- vltava$herbs$spe
civ <- vltava$herbs$civ[,1:5]

## Unconstrained ordination of the community data (DCA) ----
DCA <- decorana (log1p (com))  # log-transform abundance composition data
ordiplot (DCA)  # plot DCA

com_pa <- decostand (com, method = 'pa')  # presence-absence transformation on abundances of community data (to calculate mean Ellenberg-type indicator values)
mCIV <- cwm (com = com_pa, traits = civ) # mean Czech Indicator Values (Ellenberg-type)
head (mCIV)

## Project mCIV onto the DCA ordination diagram tested by standard test ----
ef <- envfit (DCA, mCIV)
#           DCA1     DCA2     r2 Pr(>r)    
# light  0.53152  0.84705 0.6988  0.001 ***
# temp   0.36380  0.93148 0.5836  0.001 ***
# moist -0.90057  0.43471 0.9146  0.001 ***
# react -0.74996  0.66148 0.4543  0.001 ***
# nutr  -0.99859  0.05300 0.8730  0.001 ***

plot (ef, p.max = 0.05)

## ... and the same using mCIV calculated from randomized Ell. values ----
civ_rand <- apply (civ, 2, sample)
mCIV_rand <- cwm (com = com_pa, traits = civ_rand)
ef_rand <- envfit (DCA, mCIV_rand)
ef_rand
#           DCA1     DCA2     r2 Pr(>r)    
# light -0.79120 -0.61155 0.0053  0.812    
# temp  -0.88168 -0.47184 0.2294  0.001 ***
# moist  0.32002 -0.94741 0.0069  0.777    
# react -0.20225 -0.97933 0.0789  0.046 *  
# nutr  -0.17787 -0.98405 0.0391  0.217    

plot (ef_rand, col = 'red', p.max = 0.05)

# apply modified permutation test on envfit
ef_modif <- envfit_cwm (DCA, mCIV)
ef_modif
#           DCA1     DCA2     r2 Pr(>r)    
# light  0.53152  0.84705 0.6988  0.001 ***
# temp   0.36380  0.93148 0.5836  0.002 ** 
# moist -0.90057  0.43471 0.9146  0.001 ***
# react -0.74996  0.66148 0.4543  0.022 *  
# nutr  -0.99859  0.05300 0.8730  0.001 ***

ordiplot (DCA)
plot (ef_modif, p.max = 0.05)

civ_rand <- apply (civ, 2, sample)
mCIV_rand <- cwm (com = com_pa, traits = civ_rand)
ef_rand_modif <- envfit_cwm (DCA, mCIV_rand)
ef_rand_modif
#           DCA1     DCA2     r2 Pr(>r)
# light  0.43496 -0.90045 0.1383  0.477
# temp  -0.09566  0.99541 0.1339  0.469
# moist -0.39343  0.91936 0.0604  0.730
# react -0.38905  0.92122 0.0648  0.719
# nutr   0.75924  0.65081 0.1967  0.322

plot (ef_rand_modif, col = 'red', p.max = 0.05)  # nothing plotted as nothing is significant

## Modified permutation test with qualitative intrinsic env. variable (vegetation type) ----
vegtype <- vltava$env$GROUP  # classified by Ward algorithm and Euclidean distance applied on log-transformed community data

NMDS <- metaMDS (dist (log1p (com))) # NMDS ordination - to illustrate the pattern of clusers
ordiplot (NMDS, type = 'n')
points (NMDS, col = vegtype, pch = vegtype)

# ANOVA with modified permutation test
civ_vegtype <- test_cwm (cwm = mCIV, env = as.factor (vegtype), method = 'aov', test = c('parametric', 'modified'))
civ_vegtype
plot (civ_vegtype)
