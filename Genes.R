devtools::install_github('cran/RVenn')
install.packages('rlist', repos='http://cran.rstudio.com/')
library(tidyverse)
library(RVenn)
library(rlist)
library(knitr)

## Load data from GitHub server
## The scread_db.rdata contains scREAD database DEGs data, a function named 'calc_overlap_list' to perform the analysis

load(
  url(
    'https://github.com/OSU-BMBL/scread-protocol/raw/master/overlapping_genes/scread_db.rdata'
  )
)
## If all the above links are not available, please contact the author.

REGION_LIST <- sort(unique(dataset$region))
CT_LIST <- sort(unique(cell_type_meta$cell_type))
CT_SHORT_LIST <- CT_LIST
CT_SHORT_LIST[CT_LIST=="Oligodendrocyte precursor cells"] <- "opc"
CT_SHORT_LIST <- tolower(substr(CT_SHORT_LIST, 1, 3))

list(brain_region=REGION_LIST, cell_type=CT_LIST, short_name=CT_SHORT_LIST)

# We use top 100 DE genes in each AD vs control comparison
TOP <- 100

# Species should be either 'Human' or 'Mouse'
this_species <- 'Human'

# Specify our brain region of interest, here we selected the 5th brain region in REGION_LIST variable, i.e, Entorhinal Cortex'
this_region <- REGION_LIST[5]

# DE direction should either 'up' or 'down', 'up' means we select DE genes that are expessed higher in the disease dataset (the first group)
this_direction <- 'up'

# The OVERLAP_THRES should be manually defined based on your interest and total number of comparisons in scREAD. 
# For example, scREAD have 4 total AD vs control datasets comparisons, we set the threshold to 3, meaning that we want to find overlapping genes that are at least appeared in 3 comparisons
OVERLAP_THRES <- 3

# Now, we can calculate the overlapping genes based on the parameters above, the results are stored in a list variable:
result <- calc_overlap_list()


kable(result$list)

kable(result$rank[,c(1:6,9)])

REGION_LIST