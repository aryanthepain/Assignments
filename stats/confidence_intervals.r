# Install and load necessary packages
# install.packages("shiny")
# install.packages("ggplot2")

library(shiny)
library(ggplot2)

# Define the UI (User Interface)
ui <- fluidPage(
  titlePanel(
    div(class = "title-panel", "Confidence Interval for Mean of Normal Distribution")
  ),
  h4("~By Aryan Gupta", align = "center"),
  tags$head(tags$style(HTML("
  body {
    font-family: Arial, sans-serif;
    background-color: #f8f9fa;
  }
  h3 {
    text-decoration: underline;
    text-align: center;
  }
  .title-panel {
    color: #007bff;
    font-size: 2em;
    font-weight: bold;
    text-align: center;
    padding: 20px;
  }
  .description {
    margin-bottom: 20px;
    padding: 15px;
    background-color: #e9ecef;
    border-radius: 5px;
  }
  .section {
    width: 100%;
    text-align: center;
    padding: 15px;
    margin-bottom: 30px;
    border: 1px solid #dee2e6;
    border-radius: 5px;
    background-color: #ffffff;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
  }
  .inputs {
    display: flex;
    flex-wrap: wrap;
    gap: 30px;
    justify-content: space-around;
  }
  "))),
  fluidRow(
    column(
      12,
      div(
        class = "section",
        h3("Confidence Interval Calculation"),
        div(
          class = "description",
          "This app calculates and visualizes the confidence interval for the mean of a normal distribution, allowing you to specify whether the population standard deviation is known or unknown."
        ),
        h4("Inputs for Finding Confidence Intervals"),
        div(
          class = "section inputs",
          numericInput("n", "Sample Size (n):", min = 2, max = 100, value = 30),
          numericInput("mean", "Sample Mean (x̄):", min = -10, max = 10, value = 0),
          numericInput("sigma", "Population Standard Deviation (σ):", min = 0.1, max = 10, value = 1),
          numericInput("sd", "Sample Standard Deviation (s):", min = 0.1, max = 10, value = 1),
          sliderInput("alpha", "Tail Probability (α):", min = 0.01, max = 0.20, value = 0.05),
          selectInput("type", "Confidence Interval Type:", choices = c("Known σ", "Unknown σ"))
        ),
        plotOutput("ciPlot"),
        verbatimTextOutput("ciText")
      )
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  output$ciPlot <- renderPlot({
    alpha <- input$alpha
    n <- input$n
    mean <- input$mean
    sigma <- input$sigma
    sd <- input$sd
    type <- input$type

    # Determine the critical value and calculate confidence interval
    if (type == "Known σ") {
      se <- sigma / sqrt(n)
      z_value <- qnorm(1 - alpha / 2)
      lower <- mean - z_value * se
      upper <- mean + z_value * se
    } else {
      se <- sd / sqrt(n)
      t_value <- qt(1 - alpha / 2, df = n - 1)
      lower <- mean - t_value * se
      upper <- mean + t_value * se
    }

    # Create normal distribution data for the plot
    x <- seq(mean - 4 * sigma, mean + 4 * sigma, length = 100)
    y <- dnorm(x, mean, sigma)

    ggplot(data.frame(x = x, y = y), aes(x = x, y = y)) +
      geom_line() +
      geom_vline(xintercept = c(lower, upper), linetype = "dashed", color = "red") +
      labs(title = "Confidence Interval for Mean", x = "Value", y = "Density") +
      theme_minimal() +
      xlim(min(x), max(x))
  })

  output$ciText <- renderPrint({
    alpha <- input$alpha
    n <- input$n
    mean <- input$mean
    sigma <- input$sigma
    sd <- input$sd
    type <- input$type

    # Calculate the confidence interval
    if (type == "Known σ") {
      se <- sigma / sqrt(n)
      z_value <- qnorm(1 - alpha / 2)
      lower <- mean - z_value * se
      upper <- mean + z_value * se
    } else {
      se <- sd / sqrt(n)
      t_value <- qt(1 - alpha / 2, df = n - 1)
      lower <- mean - t_value * se
      upper <- mean + t_value * se
    }

    cat("Confidence Interval:\n")
    cat("Lower Bound:", lower, "\n")
    cat("Upper Bound:", upper, "\n")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
