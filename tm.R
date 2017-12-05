library(tm)
# http://www.sc.ehu.es/ccwbayes/members/inaki/tmp/Yvan-teaching-material/tm-textprocessing-Tutorial.pdf
# Example with 20news

# setwd('F:/My Documents/My texts') #sets R's working directory to near where my files are
# a  <-Corpus(DirSource("/My Documents/My texts"), readerControl = list(language="lat")) #specifies the exact folder where my text file(s) is for analysis with tm.
# make a folder with text files, e.g. 100 folder for each class
# Identify language

###########################
# Figure with distribution over classes
# List over things todo - involve
# List over future tools, English, etc.

##################################################
# Read doc of each subdir and load into a volatile corpora structure
path <- "Data/20news-bydate/20news-bydate-train"
sci.elec = VCorpus(DirSource(paste0(path, "/sci.electronics/")), readerControl = list(language = "en"))
talk.religion = VCorpus(DirSource(paste0(path, "/talk.religion.misc/")),readerControl = list(language="en"))

# Explore..
sci.elec #dim
inspect(sci.elec[1]) # details about first document of the corpus, or sci.elec.train[[1]]
inspect(sci.elec[1:3]) # first three documents of the corpus

# allow meta function to access and modify
meta(sci.elec[[1]])

## Transformation
# applied via tm_map, applies/map a function to all elements of the corpus
?getTransformations

sci.rel = c(sci.elec,talk.religion)# merge corpus with c()
sci.rel.trans = tm_map(sci.rel,removeNumbers)
sci.rel.trans = tm_map(sci.rel.trans,removePunctuation)
sci.rel.trans = tm_map(sci.rel.trans, content_transformer(tolower)) # convert to lowercase
stopwords("english") # list of english stopwords
sci.rel.trans = tm_map(sci.rel.trans, removeWords, stopwords("english")) # A character vector giving the words to be removed
sci.rel.trans = tm_map(sci.rel.trans, stripWhitespace)
library(SnowballC) # to access Porter's word stemming algorithm
sci.rel.trans = tm_map(sci.rel.trans, stemDocument) # Stem words in a text document using Porter's stemming algorithm.

# Document term matrix
sci.rel.dtm = DocumentTermMatrix(sci.rel.trans)
dim(sci.rel.dtm) # doc * voc
head(sci.rel.dtm$dimnames$Terms)
inspect(sci.rel.dtm[15:25,1040:1044]) # inspecting a subset of the matrix
findFreqTerms(sci.rel.dtm, 15)
findAssocs(sci.rel.dtm,term="young",corlimit=0.7)

