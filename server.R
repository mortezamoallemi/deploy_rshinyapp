# rm(list = ls())
# Load


# Define server logic required to draw a histogram
function(input, output, session) {

  #######################################################################3
  ######## generate word cloud ##############################################
  #######################################################################3
  data <- readRDS("data.RDS")
  
  #######################################################################3
  ######## Overall Sentiments ##############################################
  #######################################################################3
  output$overall_sentiment <- renderPlot({
    
    overall_sentiment <- data$sentiments_summary[9:10,]
    
    sentiment_score <- overall_sentiment$count[2]/sum(overall_sentiment$count)
    
    if(overall_sentiment$count[2] > overall_sentiment$count[1]){
      sentiment <- "Positive"
    } else if (overall_sentiment$count[2] < overall_sentiment$count[1]){
      sentiment <- "Negative"
    } else {
      sentiment <- "Netural"
    }
    
    gg.gauge <- function(score,
                         sentiment,
                         breaks=c(0,25,50,75,100)) {
      require(ggplot2)
      get.poly <- function(a,b,r1=0.5,r2=1.0) {
        th.start <- pi*(1-a/100)
        th.end   <- pi*(1-b/100)
        th       <- seq(th.start,th.end,length=100)
        x        <- c(r1*cos(th),rev(r2*cos(th)))
        y        <- c(r1*sin(th),rev(r2*sin(th)))
        return(data.frame(x,y))
      }
      ggplot()+ 
        geom_polygon(data=get.poly(breaks[1],breaks[2]),aes(x,y),fill="red")+
        geom_polygon(data=get.poly(breaks[2],breaks[3]),aes(x,y),fill="gold")+
        geom_polygon(data=get.poly(breaks[3],breaks[4]),aes(x,y),fill="lightgreen")+
        geom_polygon(data=get.poly(breaks[4],breaks[5]),aes(x,y),fill="forestgreen")+
        geom_polygon(data=get.poly(score-1,score+1,0.2),aes(x,y))+
        geom_text(data=as.data.frame(breaks), size=5, fontface="bold", vjust=0,
                  aes(x=1.1*cos(pi*(1-breaks/100)),y=1.1*sin(pi*(1-breaks/100)),label=paste0(breaks,"%")))+
        annotate("text",x=0,y=0,label=sentiment,vjust=0,size=8,fontface="bold")+
        coord_fixed()+
        theme_bw()+
        theme(axis.text=element_blank(),
              axis.title=element_blank(),
              axis.ticks=element_blank(),
              panel.grid=element_blank(),
              panel.border=element_blank()) 
    }
    gg.gauge(score = sentiment_score * 100,
             sentiment = sentiment)
    
    
  })
  
  #######################################################################3
  ######## Plot the most frequent words ##############################################
  #######################################################################3
  
  output$repeated_words <- renderPlotly({
    
    term_frequency <- data$term_frequency %>%
      mutate(word = str_to_title(word))
    
  term_frequency[1:5,] %>%
    plot_ly() %>%
    add_trace(x = ~word,
              y = ~freq,
              type = "bar",
              color = ~word) %>%
    layout(
      yaxis = list(title = "Frequency"),
      xaxis = list(title = "Word"),
      showlegend = F
    )
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

  })

}
