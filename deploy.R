# Authenticate
setAccountInfo(name = Sys.getenv("SHINY_ACCOUNT_NAME"),
               token = Sys.getenv("SHINY_TOKEN"),
               secret = Sys.getenv("SHINY_SECRET"))
# Deploy
#deployApp(appFiles = c("ui.R", "server.R", "likes.rds"))
deployApp(appFiles = c("ui.R", "server.R"))
