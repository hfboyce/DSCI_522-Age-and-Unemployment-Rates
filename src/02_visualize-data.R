#! /usr/bin/env Rscript 
# 02_visualize_data.R
# Hayley Boyce
# Simon Chiu
# November 22, 2018

# PURPOSE: This script takes the clean dataset and creates exploratory visualizations for target audiences. 
# 
# METHOD:  This script takes 2 arguments: one taking the clean data and the other naming the directory for the newly created figures
# 
# USAGE: Rscript 02_visualize_data.R
#
# RECOMMENDED:  bash Rscript src/02_visualize_data.R "data/unemployment-age-gender-countries-filtered-clean.csv" "img/"


suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(ggplot2))

# read in command line arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
out_pic_dir <- args[2]


# define main function
main <- function(){
  
  # read in data
  clean_unemployment <- read.csv(input_file)
  
  #makes new variables for the age groups
  #young <- clean_unemployment %>% filter (Age.Group == "15-24")
  #med <- clean_unemployment %>% filter (Age.Group == "25-54")
  #old <- clean_unemployment %>% filter (Age.Group == "55-64")
  
  #young_histo <- generate_histro(young)
  
  #med_histo <- generate_histro(med)
  
  #old_histo <- generate_histro(old)
  
  violin <- generate_violin(clean_unemployment)
  
  mean_CI_plot <- generate_CI_plot(clean_unemployment)
  
  #Save the charts
  #ggsave("young_histrogram.png", plot = young_histo, path = out_pic_dir,
  #       width = 6, height = 6)
  #ggsave("med_histrogram.png", plot = med_histo, path = out_pic_dir,
  #       width = 6, height = 6)
  #ggsave("old_histrogram.png", plot = old_histo, path = out_pic_dir,
  #       width = 6, height = 6)
  
  ggsave("violin.png", plot = violin, path = out_pic_dir,
         width = 6, height = 6)
  ggsave("mean_CI.png", plot = mean_CI_plot, path = out_pic_dir,
         width = 6, height = 6)
}

# define the histrogram plot object making function
generate_histro <- function(dataset){
  
  chart <- dataset %>%
    ggplot(aes(x = Value)) + 
    geom_histogram(bins = 40, color = "white", fill = "turquoise" ) +
    xlim(0, 70) +
    #ylim(0, 420) +
    xlab("Unemployment Rate (%)") + 
    ylab("Number of Observation") +
    ggtitle("The Distribution of Unemployment Rates")
  
  return (chart)

}

# define the violin plot object making function
generate_violin <- function(dataset){

  chart <- dataset %>% 
    ggplot(aes(y = Value, x = Age.Group)) +
    geom_violin(adjust = 2, color = "lightblue3", fill = "lightblue") +
    geom_jitter(size = 0.15, color = "cornflowerblue", alpha = 0.6) +
    theme_bw() +
    xlab("Age Group") + 
    ylab("Unemployment Rate (%)") +
    ggtitle("The Distribution of Unemployment Rates") +
    theme(plot.title = element_text(size = 11, face = "bold"))
  
  return (chart)

}

# define the mean/95% confidence interval plot object making function
generate_CI_plot <- function(dataset){
  
  #Group data by age group
  clean_unemployment_Age_gped <- dataset %>%
    group_by(Age.Group) %>%
    summarize(mean = mean(Value),
              n    = length(Value),
              se   = sd(Value) / sqrt(n))
  
  #make the chart
  chart <- clean_unemployment_Age_gped %>% 
    ggplot() +
    geom_point(aes(y = mean, x = Age.Group), colour = "royalblue2") +
    geom_errorbar(aes(ymin = mean + qnorm(0.05/2)*se,
                      ymax = mean - qnorm(0.05/2)*se,
                      x    = Age.Group),
                      colour = "slateblue4",
                      width  = 0.6)+
    theme_bw() +
    xlab("Age Group") + 
    ylab("Average Unemployment Rate (%)") +
    ggtitle("95% Confidence Intervals of the Average Unemployment Rates") +
    theme(plot.title = element_text(size = 11, face = "bold"))
  
  return (chart)
}

# call main function
main()