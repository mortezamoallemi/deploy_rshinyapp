FROM rocker/shiny:4.2.1
RUN install2.r rsconnect shinydashboard  shinycssloaders shinyWidgets
RUN install2.r plotly
RUN install2.r wordcloud RColorBrewer SnowballC tm
# Name or path of the app on shinyapp.io should be entered after "/home/"
WORKDIR /home/news_sentiment_analysis
COPY ui.R ui.R 
COPY server.R server.R 
COPY data.RDS data.RDS
COPY deploy.R deploy.R
CMD Rscript deploy.R
