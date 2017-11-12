library(dplyr) # a grammar for data manipulation
library(tidyr) # makes it easy to tidy your data
library(purrr) # enhances R’s functional programming (FP) toolkit by providing a complete and consistent set of tools for working with functions and vectors.
library(readr) # fast and  friendly way to read rectangular data (csv, tsv, fwf)
library(tm) # text mining: 


train_folder <- "Data/20news-bydate/20news-bydate-train/"
test_folder <- "Data/20news-bydate/20news-bydate-test/"

# Function to read all the files from a folder into a data frame

read_folder <- function(infolder) {
  data_frame(file = dir(infolder, full.names = TRUE)) %>%
    mutate(text = map(file, read_lines)) %>%
    transmute(id = basename(file), text) %>%
    unnest(text) # tidyr
}

# Read data
raw_text <- data_frame(folder = dir(train_folder, full.names = TRUE)) %>%
  unnest(map(folder, read_folder)) %>%
  transmute(newsgroup = basename(folder), id, text)

library(ggplot2)

raw_text %>%
  group_by(newsgroup) %>%
  summarize(messages = n_distinct(id)) %>%
  ggplot(aes(newsgroup, messages)) +
  geom_col() +
  coord_flip()
