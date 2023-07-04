# Authenticate
rsconnect::setAccountInfo(name = Sys.getenv("SHINY_ACCOUNT_NAME"),
               token = Sys.getenv("SHINY_TOKEN"),
               secret = Sys.getenv("SHINY_SECRET"))
# Deploy
#rsconnect::deployApp(appFiles = c("ui.R", "server.R", "likes.rds"))
rsconnect::deployApp(appFiles = c("ui.R", "server.R"))
