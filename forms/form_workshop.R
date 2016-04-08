library("shiny")
library("shinythemes")
# devtools::install_github("daattali/shinyforms")
# devtools::install_github("fozy81/shinyforms", ref = "input-type") # for other
library("shinyforms")

# http://stackoverflow.com/questions/19341554/regular-expression-in-base-r-regex-to-identify-email-address
email_regex <- "^[[:alnum:].-]+@[[:alnum:].-]+$"

# Define the first form: basic information
basicInfoForm <- list(
  id = "basicinfo",
  questions = list(
    list(id = "email", type = "text", title = "Email address", mandatory = TRUE),
    list(id = "half_day1", type = "radio", title = "May 26, morning", mandatory = TRUE,
         choices = c("Absent" = "FALSE",
                     "Present" = "TRUE")),
    list(id = "half_day2", type = "radio", title = "May 26, afternoon", mandatory = TRUE,
         choices = c("Absent" = "FALSE",
                     "Present" = "TRUE")),
    list(id = "half_day3", type = "radio", title = "May 27, morning", mandatory = TRUE,
         choices = c("Absent" = "FALSE",
                     "Present" = "TRUE")),
    list(id = "laptop", type = "radio", title = "Bring my laptop", mandatory = TRUE,
         choices = c("Yes" = "TRUE",
                     "No" = "FALSE")),
    list(id = "comment", type = "text", title = "Comment", hint = "Anything to ease the organization")
  ),
  storage = list(
    type = STORAGE_TYPES$FLATFILE,
    path = "answers"
  ),
  name = "",
  password = "francis",
  reset = TRUE,
  validations = list(
    list(condition = "grepl('^[[:alnum:].-]+@[[:alnum:].-]+$', input$email) == TRUE",
         message = "email not valid")
  ),
  multiple = FALSE
)

ui <- fluidPage(theme = shinytheme("cosmo"),
  h2("R workshop registration"),
  formUI(basicInfoForm)
)

server <- function(input, output, session) {
  formServer(basicInfoForm)
}

shinyApp(ui = ui, server = server)
