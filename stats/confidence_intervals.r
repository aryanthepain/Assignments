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
        h4("Inputs for finding Confidence Intervals"),
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
        h4("Inputs to check smallest Confidence Interval"),
        div(
          class = "section inputs",
          sliderInput("z1", "Lower bound z1", min = -4, max = -0.01, value = -1.96),
          sliderInput("z2", "Upper bound z2", min = 0.01, max = 4, value = 1.96)
        ),
        plotOutput("standardPlot"),
        verbatimTextOutput("ciText")
      )
    )
  )
)

# Define the server logic# Define the server logic
server <- function(input, output) {
  # Define global variables
  z1 <<- -1.96
  z2 <<- 1.96

  observeEvent(input$z1, {
    z1 <<- input$z1
    z2 <<- qnorm(input$alpha + pnorm(z1))
  })

  observeEvent(input$z2, {
    z2 <<- input$z2
    z1 <<- qnorm(pnorm(z2) - input$alpha)
  })

  observeEvent(input$alpha, {
    z_value <- qnorm(1 - input$alpha / 2)
    z1 <<- -z_value
    z2 <<- z_value
  })

  output$ciPlot <- renderPlot({
    alpha <- input$alpha
    n <- input$n
    mean <- input$mean
    sigma <- input$sigma
    sd <- input$sd
    type <- input$type

    z_value <- qnorm(1 - alpha / 2)
    t_value <- qt(1 - alpha / 2, df = n - 1)

    if (type == "Known σ") {
      se <- sigma / sqrt(n)
      lower <- mean - z_value * se
      upper <- mean + z_value * se
    } else {
      se <- sd / sqrt(n)
      lower <- mean - t_value * se
      upper <- mean + t_value * se
    }
    critical_values <- c(lower, upper)

    # Create normal distribution data
    x <- seq(mean - 4 * sigma, mean + 4 * sigma, length = 100)
    y <- dnorm(x, mean, sigma)

    data <- data.frame(x = c(lower, upper), y = c(0, 0))

    ggplot(data, aes(x = x, y = y)) +
      geom_line(data = data.frame(x = x, y = y), aes(x = x, y = y)) +
      geom_vline(xintercept = critical_values, linetype = "dashed", color = "red") +
      labs(title = "Confidence Interval for Mean", x = "Value", y = "Density") +
      theme_minimal() +
      xlim(min(x), max(x))
  })

  output$standardPlot <- renderPlot({
    # Create normal distribution data
    x <- seq(-5, 5, length = 100)
    y <- dnorm(x, 0, 1)

    data <- data.frame(x = c(z1, z2), y = c(0, 0))

    ggplot(data, aes(x = x, y = y)) +
      geom_line(data = data.frame(x = x, y = y), aes(x = x, y = y)) +
      geom_vline(xintercept = c(z1, z2), linetype = "dashed", color = "red") +
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

    z_value <- qnorm(1 - alpha / 2)
    t_value <- qt(1 - alpha / 2, df = n - 1)

    if (type == "Known σ") {
      se <- sigma / sqrt(n)
      lower <- mean - z_value * se
      upper <- mean + z_value * se
    } else {
      se <- sd / sqrt(n)
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
