#what is the within genus variation for p50 values in Quercus?
  #hypothesis: there will be great variation globally and within continents
  #the xylem size will play a role in determination of P50 
  #if xylem size = large, then strategy = fast
  #if geographic area = sub/tropics, then expect higher P50
  #if xylem size = small AND geographic area != sub/tropics, expect lower P50

#install packages
install.packages("devtools")
require(devtools)
library(stringr)

#github install
# Install from GitHub
devtools::install_github("billurbektas/tidyTRY")

library(tidyTRY)

#requesting data files
##need to grab spp name
quercus_ids <- read.delim("~/mai_a/260417_quercus_data/260417_quercus_spp_try", header=FALSE)

quercus_id_num <- quercus_ids[,1] |> as.vector()
id_list <- paste(as.character(quercus_id_num), collapse=", ",sep="")
write.csv(id_list, 
          "~/mai_a/260417_quercus_data/260417_id_ls_try.txt")

#GBIF taxon
##Plantae > Tracheophyta > Magnoloiopsida > Fagales> Fagaceae > Quercus

install.packages("rgbif")
library(rgbif)
