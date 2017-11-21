# https://www.rstudio.com/resources/cheatsheets/
# Bok : http://r4ds.had.co.nz/
library(dplyr)

tbl_df(diamonds)
# Tibble: useful ot work woth large datasets
################# Data
#devtools::install_github("rstudio/EDAWR")

################# Tidyr: a package that reshapes the layout og tables###############

# Tidy data: Variables in col, observations in rows, each type in a table
library(tidyr)
?gather
# "make observations from variables"
# Key-value pairs
EDAWR::cases
# Value = former cells
# Gather takes data in rectangular format and transfer to key-value pairs
gather(data = EDAWR::cases, key = "year", value = "n", 2:4)
# 2:4 names of columns to collapse. If empty, collapse all
# Here, "country" is already tidy

# Spread: take data in a key-value format and put it into rectangular format
# makes variables from observations
EDAWR::pollution
spread(data = EDAWR::pollution, key = size, value = amount )

############ Split and merge columns with separate() and unite()
#Separate
EDAWR::storms
storm2 = separate(EDAWR::storms, "date", c("year", "month", "day"), sep = "-")
storm2
#Unite - inverse of separate
storm1 = unite(storm2, "dato", year, month, day, sep = "-")

################# dplyr: helps transform tabular data ###########
install.packages("nycflights13")
library(nycflights13)

####### SELECT #######
# can select based on string name contains(), etc..
?select

# Filter
storms %>% filter(wind > 50, name %in% c("Alberto", "Alex"))
# Can use with all kinds of logical tests
xor
any
all
*pipe*´``