install.packages('rstudioapi')
install.packages("readr")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("stringr")

library(rstudioapi)
library(readr)
library(tidyverse)
library(dplyr)
library(stringr)
library(data.table)

current_path = rstudioapi::getActiveDocumentContext()$path
# Set the working directory
setwd("C:\\Users\\swtan\\OneDrive - Sunway Education Group\\Big Data")

# Print the current working directory to verify
print(getwd())

# Read dataset 
books_data <- read_csv("C:\\Users\\swtan\\OneDrive - Sunway Education Group\\Big Data\\R\\Books_rating.csv", n_max = 4000000)

# Check the frequency of each book
title_count <- books_data %>%
  group_by(Title) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

# Extract top 10000 most popular book titles
top_titles <- books_data %>%
  group_by(Title) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  slice_head(n = 10000) %>%
  pull(Title)

# Subset books_data to include only rows with titles in top_titles, and select the 'review/text' column
BR_text10k <- subset(books_data, Title %in% top_titles)[, "review/text"]

# Write dataset into .csv file
write_csv(BR_text10k, "BR_text10k.csv")

# Testing ----
BR_text10ktest <- BR_text10k %>%
  slice(1:floor(n() * 0.01))

# wordcount ----

# Function to remove punctuation
rpunct <- function(x) {
  x <- gsub("[[:punct:]\\$]", "", x)h   
  return(x)
}

# Apply function
text <- paste(BR_text10k, collapse = " ")
ctext <- rpunct(text)

words <- unlist(str_split(ctext, "\\s+"))

words1 <- data.table(word = words)
words1 <- words1[word != ""]  # Remove empty strings

# Group and count words
br10k_wc_r <- words1[, .(count = .N), by = word][order(-count)]
br10k_wc_r <- as.data.frame(br10k_wc_r)


