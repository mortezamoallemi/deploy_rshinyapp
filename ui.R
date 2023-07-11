#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinycssloaders)
library("tm")
library("wordcloud")
library("RColorBrewer")
library("ggplot2")
library("stringr")
library(plotly)
library(shiny)
library(shinyWidgets) # useShinydashboard()


fluidPage(
  tags$h2("Classic shiny"),
  
  # use this in non shinydashboard app
  # setBackgroundColor(color = "ghostwhite"),
  useShinydashboard(),
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(width = 4,
          title = "Most Repeated Words",
          withSpinner(plotOutput("word_cloud")),
          withSpinner(plotlyOutput("repeated_words", height = 250)),
          sliderInput("n_words",
                      "Number of words:",
                      min = 5,
                      max = 50,
                      value = 30)),
      box(width = 4,
          title = "Overall Sentiment",
          withSpinner(plotOutput("overall_sentiment"))),
      box(width = 4,
          withSpinner(plotlyOutput("different_sentiments", height = 250))
          )
    )
  )
# )
