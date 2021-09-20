# CWM approach in functional trait ecology - R workshop at #IAVS2021

*This website contains materials related to the workshop organized during the 63rd Annual Symposium of the International Association for Vegetation Science*

**Lecturer:** [David Zelený](https://www.davidzeleny.net) (National Taiwan University, email: zeleny@ntu.edu.tw, Twitter: [@zdealveindy](https://twitter.com/zdealveindy))   
**Technical Assistant:** Po-Yu Lin (National Taiwan University)

## Description
Relating community-level functional traits to the environment is one of the fundamental tasks in functional ecology. One way to do so is to calculate community weighted means (CWM) of species traits, weighted by species abundances, and relate them to environmental variables. However, traditional parametric tests inflate Type I errors. In this workshop, participants will learn how to use the recently developed R package weimea, which contains tools suitable for running the permutation tests that overcome this problem within the CWM approach.

## Program of the workshop (starts at 14:00 CEST)
### A. Theoretical part (50 minutes)
1. Introduction of the problem of Type I error rate inflation in the CWM approach (download the presentation [here](https://github.com/zdealveindy/IAVS2021_weimea_workshop/raw/main/CWM_workshop_IAVS2021_slides.pdf))
2. Solution - max permutation test, how it works
3. Is the test always inflated? It depends on which question are you asking and what are your assumptions.
4. Q&A part

### B. Practical part (50 minutes)
1. Overview of <tt>weimea</tt> library, main features
2. Running two simple examples to show how main functions work (using [Vltava dataset](https://anadat-r.davidzeleny.net/doku.php/en:data:vltava), namely CWM approach and projecting EIVs onto ordination diagram. Download the file with examples [WM_workshop_IAVS2021_examples.R](https://github.com/zdealveindy/IAVS2021_weimea_workshop/blob/main/CWM_workshop_IAVS2021_examples.R).
3. Q&A part

## Before we start
Please make sure that your computer is running the latest version of R (4.1.1 or newer) and RStudio (1.4.1717 or newer). With older versions of R we cannot guarantee the full functionality of the R code and <tt>weimea</tt> package. For detailed instructions how to install R & RStudio and update packages, visit [AnadatR website](https://anadat-r.davidzeleny.net/doku.php/en:r).

## If you never worked with R before
For this workshop, we expect that you will have intermediate level of R coding skills, and if you never worked with R, you may have difficulties to catch up. But if you have time to spare, you may walk through the series of five [Quick R Introduction tutorials](https://www.davidzeleny.net/wiki/doku.php/quickr:start), prepared for - yeah, quick R introduction. Each video (ca 30-40 minutes long) will walk you through the main features of R and RStudio. This may be also a good choice if you are familiar with R, but have not used it for a while.

## Install <tt>weimea</tt> package
The package <tt>weimea</tt> (community __wei__ghted __mea__n approach, Zelený 2018) is focused on relating community-level species attributes (traits, indicator values) to sample attribute (environmental variables). The current distribution (in beta release) is on GitHub (https://github.com/zdealveindy/weimea).

To install current stable release on your computer, see the installation instructions below (different for Windows, Mac OS and Linux).

### Windows
Download the Windows binary [here](https://anadat-r.davidzeleny.net/lib/exe/fetch.php/en:data:weimea_0.1.18.zip) and install it (in RStudio go to Packages > Install > Install from: Package archive file (.zip; .tar.gz)). You can also use the following code directly:

```
download.file ('https://anadat-r.davidzeleny.net/lib/exe/fetch.php/en:data:weimea_0.1.18.zip', 'weimea.zip')
install.packages (paste (getwd (), 'weimea.zip', sep = '/'), repos = NULL, type = 'win.binary')
```
 Try <tt>library (weimea)</tt> to open the package. If you get the error message *Error: package or namespace load failed for ‘weimea’... there is no package called ‘RcppArmadillo’*, then you need to <tt>install.packages (“RcppArmadillo”)</tt> and try <tt>library (weimea)</tt> again. If you get another error message, you may be missing yet another library on which <tt>weimea</tt> depends - follow error messages and install them one by one manually using <tt>install.packages</tt> function. To ensure the library is correctly installed, you should not get any error message once you type <tt>library (weimea)</tt>. You can try to run some of the example codes, e.g. <tt>example (test_cwm)</tt>, to see whether the package works.

Alternatively, you can install the package directly from GitHub. **For this, you need to have the latest version of Rtools.exe, compatible with your R version, installed on your computer and added to your program path (check [[here]](https://anadat-r.davidzeleny.net/doku.php/en:r#installing_from_github) for details)**, and that you installed the latest version of the package devtools. Use the following code:

```
devtools::install_github ('zdealveindy/weimea')
```

### MacOS ###
Download the MacOS binary [here](https://anadat-r.davidzeleny.net/lib/exe/fetch.php/en:data:macos:weimea_0.1.18.tgz) and install it (thanks a lot to Cheng-Tao Lin from National Chiyai University, Taiwan, for help with compiling it!).

To install the package, close R and RStudio and install the package through terminal (you can follow [these instructions](http://www.ryantmoore.org/files/ht/htrtargz.pdf) to install the package from terminal. Make sure that the access you type in the terminal code is the real access of the downloaded file, e.g. using ```{R CMD INSTALL Desktop/weimea_0.1.18.tgz}```). 

Make also sure to install packages <tt>vegan</tt> and <tt>RcppArmadillo</tt> in your R. If you are getting weird messages, make sure you have the latest version of R (4.1.1) and RStudio (1.4.1717 or newer).

### Linux ###
Download the Linux binary [here](https://anadat-r.davidzeleny.net/lib/exe/fetch.php/en:data:linux:weimea_0.1.18_r_x86_64-pc-linux-gnu.tar.gz) and install on your computer (thanks a lot to Cheng-Tao Lin from National Chiyai University, Taiwan, for help with compiling it!)

## Suggested reading
* Peres-Neto, P. R., S. Dray, and C. J. F. ter Braak. 2017. Linking trait variation to the environment: Critical issues with community-weighted mean correlation resolved by the fourth-corner approach. Ecography 40:806–816. https://doi.org/10.1111/ecog.02302 (free to read)
* ter Braak, C. J. F, P. Peres-Neto, and S. Dray. 2018. Simple parametric tests for trait-environment association. Journal of Vegetation Science 29:801–811. https://doi.org/10.1111/jvs.12666 (open access) 
* Zelený, D. 2018. Which results of the standard test for community weighted mean approach are too optimistic? Journal of Vegetation Science 29: 953–966. https://doi.org/10.1111/jvs.12688 (free to read)
