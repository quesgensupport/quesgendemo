## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(
    echo = TRUE,
    tidy = FALSE,
    size = "small",
    results = 'hide')
source("./F01-install_my_pkgs.R")

## ----install_packages, message=FALSE, warning=FALSE, paged.print=FALSE----
library(mosaic)
library(gcookbook)
library(tidyverse)

## ----my_files_location---------------------------------------------------
dir("./")

## ----parent_dir----------------------------------------------------------
dir("../")

## ----HospAdminData_import------------------------------------------------
HospAdminData <- readr::read_csv("HospAdminData.csv")

## ----print_HospAdminData-------------------------------------------------
HospAdminData

## ----download_data-------------------------------------------------------
HospAdminData_url <- "https://raw.githubusercontent.com/mjfrigaard/QuesgenDemo/master/HospAdminData.csv"
HospAdminData_destfile <- "HospAdminData.csv"
download.file(HospAdminData_url, HospAdminData_destfile)

## ----check_download------------------------------------------------------
dir("./")

## ----structure-----------------------------------------------------------
str(HospAdminData)

## ----glimpse-------------------------------------------------------------
dplyr::glimpse(HospAdminData)

## ----names---------------------------------------------------------------
HospAdminData %>% names()

## ----nrow----------------------------------------------------------------
HospAdminData %>% base::nrow()

## ------------------------------------------------------------------------
HospAdminData %>% base::ncol()

## ----dim-----------------------------------------------------------------
HospAdminData %>% base::dim()

## ----head----------------------------------------------------------------
HospAdminData %>% Matrix::head()

## ----tail----------------------------------------------------------------
HospAdminData %>% Matrix::tail()

## ----glimpse_is_best-----------------------------------------------------
HospAdminData %>% glimpse()

## ----rename_depression---------------------------------------------------
HospAdminData <- HospAdminData %>% dplyr::rename(depression = BSI18DeprScoreRaw)

## ----check_depression----------------------------------------------------
HospAdminData %>% glimpse()

## ----depression_glimpse--------------------------------------------------
HospAdminData$depression %>% glimpse()

## ----HospAdminData_new_names---------------------------------------------
HospAdminData <- HospAdminData %>% 
    dplyr::select(
        sub_id = SubjectID,
        sex = Sex,
        age = Age,
        pat_type = PatientType,
        depression,
        death_cause = DeathCause,
        death_time = DeathTimeSinceInj)
HospAdminData %>% glimpse()

## ----fix_female----------------------------------------------------------
# If you need to see the named elements of an object, you can use `%$%`.
# test
HospAdminData %$% str_remove(sex,
                             pattern = "2:") %>% head()
# assign
HospAdminData$sex <- HospAdminData %$% str_remove(sex,
                             pattern = "2:")
# verify
HospAdminData$sex %>% head()

## ----fix_male------------------------------------------------------------
# test
HospAdminData %$% str_remove(sex,
                             pattern = "1:") %>% head()
# assign
HospAdminData$sex <- HospAdminData %$% str_remove(sex,
                             pattern = "1:")
# verify
HospAdminData$sex %>% head()

## ----convert_to_factor---------------------------------------------------
HospAdminData$sex <- factor(HospAdminData$sex)
base::is.factor(HospAdminData$sex)

## ----fivenum-------------------------------------------------------------
library(mosaic)
HospAdminData %$% fivenum(depression) # note different pipe

## ----depression_summary--------------------------------------------------
HospAdminData %$% summary(depression)

## ----favstats, warning=FALSE---------------------------------------------
HospAdminData %$% favstats(depression)

## ----ggplot_basics-------------------------------------------------------
HospAdminData %>% ggplot(aes(depression)) +
    geom_histogram()

## ----depression_binwidth-------------------------------------------------
HospAdminData %>% ggplot(aes(depression)) +
    geom_histogram(binwidth = 1)

## ------------------------------------------------------------------------
HospAdminData %>% 
    ggplot(aes(x = depression, 
               fill = sex)) +
            geom_histogram(position = "identity",
                           alpha = 0.4,
                           binwidth = 1)

## ----geom_freqpoly-------------------------------------------------------
HospAdminData %>% 
    ggplot(aes(x = depression, 
               color = sex)) +
            geom_freqpoly(position = "identity", 
                           binwidth = 1)

## ------------------------------------------------------------------------
HospAdminData %>% 
    ggplot(aes(depression, fill = sex)) + # the data and the variables
                geom_histogram(binwidth = 1) + # the geom (histogram) layer
                        facet_wrap(~ sex, 
                                   ncol = 1) # the facet layer

## ----geom_bar_percents---------------------------------------------------
HospAdminData %>% ggplot(aes(x = sex)) +  
        geom_bar(aes(y = (..count..)/sum(..count..))) + 
            scale_y_continuous(labels = scales::percent) + 
            xlab("Patient Sex") +
            ylab("Percent")

## ----ttest_model---------------------------------------------------------
ttest_model <- t.test(depression ~ sex, data = HospAdminData, paired = FALSE)
ttest_model 

## ----create_script-------------------------------------------------------
# knitr::purl("intro_to_rstudio_&_the_tidyverse.Rmd")

