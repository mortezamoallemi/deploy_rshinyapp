library(shiny)
library(shinydashboard)
library(shinycssloaders)


dashboardPage(
  dashboardHeader(title = "News Sentiment Analysis"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(width = 8,
          withSpinner(plotlyOutput("different_sentiments", height = 250))),
      box(width = 4,
          withSpinner(plotOutput("bar_plot", height = 250))),
      
      box(width = 4,
        title = "Most Repeated Words",
        withSpinner(plotOutput("word_cloud")),
        sliderInput("n_words",
                    "Number of words:",
                    min = 5,
                    max = 50,
                    value = 30)
      )
    )
  )
)
