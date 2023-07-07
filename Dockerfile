FROM rocker/shiny:4.2.1
RUN install2.r rsconnect shinydashboard  shinycssloaders
RUN install2.r plotly tidyverse stringr
RUN install2.r tm wordcloud RColorBrewer
# Name or path of the app on shinyapp.io should be entered after "/home/"
WORKDIR /home/news_sentiment_analysis
COPY ui.R ui.R 
COPY server.R server.R 
COPY data.RDS data.RDS
COPY deploy.R deploy.R
CMD Rscript deploy.R
