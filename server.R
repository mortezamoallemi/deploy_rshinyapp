# rm(list = ls())
# Load
library("wordcloud")
library("RColorBrewer")
library("ggplot2")
library("stringr")
library(plotly)
library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

  #######################################################################3
  ######## generate word cloud ##############################################
  #######################################################################3
  data <- readRDS("data.RDS")
  
  #######################################################################3
  ######## Plot the most frequent words ##############################################
  #######################################################################3
  
  output$bar_plot <- renderPlot({
    
    term_frequency <- data$term_frequency
    
  barplot(term_frequency[1:5,]$freq, 
          las = 2, 
          names.arg = term_frequency[1:5,]$word,
          col ="lightgreen", 
          main ="Top 5 most frequent words",
          ylab = "Word frequencies")
  })
  
  #######################################################################3
  ######## generate word cloud ##############################################
  #######################################################################3
  
  set.seed(1234)
  output$word_cloud <- renderPlot({
    
    term_frequency <- data$term_frequency
    
  wordcloud(words = term_frequency$word, 
            freq = term_frequency$freq, 
            min.freq = 2,
            max.words=input$n_words, 
            random.order=FALSE, 
            rot.per=0.40, 
            colors=brewer.pal(8, "Dark2"))
  })
  #######################################################################3
  ######## Different Sentiments ##############################################
  #######################################################################3
  output$different_sentiments <- renderPlotly({
  
    sentiments_summary <- data$sentiments_summary[1:8,] %>%
      mutate(percent = count * 100 / sum(count),
             sentiment = str_to_title(sentiment))
    
    sentiments_summary %>%
      plot_ly() %>%
      add_trace(x = ~sentiment,
                y = ~percent,
                type = "bar",
                color = ~sentiment) %>%
      layout(
        yaxis = list(title = "%"),
        xaxis = list(title = "Sentiment"),
        showlegend = F
      )

    # quickplot(sentiment, 
    #           data=sentiments_summary, 
    #           weight=percent, 
    #           geom="bar", 
    #           fill=sentiment, 
    #           ylab="%") + 
    #   ggtitle("Sentiments")
  })

}
