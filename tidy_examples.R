# See http://tidytextmining.com/

library(dplyr)

# Charachter vector
text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

# Transform to DF --> Tibble df; does not convert str to factors, don't use row names
text_df <- data_frame(line = 1:4, text = text)
glimpse(text_df) # similar to str()

# Tokenization and transform to tidy data structure 
# One token per line
# token = "words" default. Can use ngram (3gram)
library(tidytext)

# unnest_tokens: strip punctuations, retain orig df's row#
text_df %>%
  unnest_tokens(output = words, input = text, token = "ngrams") # Split a col into tokens using tokeinezers package, splitting the table into one-token-per-row
  

################################################
# 1.3 Tidying the works of Jane Austen
library(janeaustenr) # contains the complete text of Jane Austen's 6 completed, published novels, formatted to be convenient for text analysis
library(dplyr)
library(stringr) # simple, consistence wrappers for common string operations

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(), # rank
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()

# One token per line

tidy_books <- original_books %>%
  unnest_tokens(word, text)

# Stopwords
data("stop_words")

# Find the most common words by freq
tidy_books %>%
  count(word, sort = TRUE)

#plot(c$n, xlim = (c(0,200)), xlab = "Words", ylab = "counts", type = "l", main = "Word Frequencies")

# Visualize

tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 5000) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

# Remove stopwords

tidy_books <- tidy_books %>%
  anti_join(stop_words, by = "word")

tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

################### GUTENBERG
# 1.4
library(gutenbergr)
hgwells <- gutenberg_download(gutenberg_id = c(35, 36, 5230, 159)) # col: id, text

tidy_hgwells <- hgwells %>%
  unnest_tokens(word, text) %>% #tokenize
  anti_join(stop_words) #remove stopwords

# What are the most frequent words?
tidy_hgwells %>%
  count(word, sort = TRUE)

bronte <- gutenberg_download(c(1260, 768, 969, 9182, 767))

tidy_bronte <- bronte %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_bronte %>%
  count(word, sort = TRUE)

# Calculate freq for each word for Jane Austen, Bronte and H.G Wells
# Bind the DFs

# note str_extract should be done when matched against stopwords too..
frequency <- bind_rows(mutate(tidy_bronte, author = "Brontë Sisters"), # add col "author"
                       mutate(tidy_hgwells, author = "H.G. Wells"),  # and stack on top of each other
                       mutate(tidy_books, author = "Jane Austen")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% # in cases where we have markup for e.g. _initialization_
  count(author, word) %>% # count number of words with each author
  group_by(author) %>%
  mutate(proportion = n / sum(n)) %>% # proportion of words for given author
  select(-n) %>% # select all but col 'n'
  spread(author, proportion) %>% #reshape long format to wide format
  gather(author, proportion, `Brontë Sisters`:`H.G. Wells`) # reshape

library(scales)

ggplot(frequency, aes(x = proportion, y = `Jane Austen`, color = abs(`Jane Austen` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Jane Austen", x = NULL)


############## More Gutenberg #############
# https://ropensci.org/tutorials/gutenbergr_tutorial/
# Gutenberg metadata --> contain various info about the datasets

danish_guten_meta <- gutenberg_metadata %>% filter(language == "da")
danish_books <- gutenberg_download(danish_guten_meta$gutenberg_id)

# Word frequencies
tidy_danish <- danish_books %>%
  unnest_tokens(word, text)

# Remove stopwords
library(tm)

tidy_danish <- anti_join(tidy_danish, data_frame(word = stopwords(kind = "da")))

tidy_danish_freq <- tidy_danish %>%
  count(word, sort = TRUE)

############# Norwegian
norw_guten_meta <- gutenberg_metadata %>% filter(language == "no")
norwegian_books <- gutenberg_download(norw_guten_meta$gutenberg_id, )

# Word frequencies
tidy_norw <- norwegian_books %>%
  unnest_tokens(word, text)

# Remove stopwords

tidy_norw <- anti_join(tidy_norw, data_frame(word = stopwords(kind = "no")))

tidy_norw_freq <- tidy_norw %>%
  count(word, sort = TRUE)

######## Wordcloud
library(wordcloud)

tidy_norw %>%
  anti_join(data_frame(word = stopwords(kind = "da")))
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))
