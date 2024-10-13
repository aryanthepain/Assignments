# author: Aryanthepain
# we need to prove theorems of statistics via graphs, let's go

# setting up libraries
install.packages("shiny")
install.packages("ggplot2")

library(shiny)
library(ggplot2)

# Define User Interface
ui <- fluidPage(
  titlePanel(
    div(class = "title-panel", "DA241- Proving Statistical Theorems")
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
  .theorem-description {
    margin-bottom: 20px;
    padding: 15px;
    background-color: #e9ecef;
    border-radius: 5px;
  }
  .theorem-section {
    width: 100%;
    text-align: center;
    padding: 15px;
    margin-bottom: 30px;
    border: 1px solid #dee2e6;
    border-radius: 5px;
    background-color: #ffffff;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
  }
  .main-panel {
    width: 100%;
    max-width: 100%;
    flex-grow: 1;
  }
  "))),
  fluidRow(
    column(
      12,
      div(
        class = "theorem-section",
        h3("Weak Law of Large Numbers"),
        div(class = "theorem-description", "The Weak Law of Large Numbers (WLLN) states that as the sample size increases, the sample mean converges to the population mean. With small samples, the sample mean may fluctuate significantly from the population mean. However, as the sample size grows, these fluctuations diminish, and the sample mean stabilizes, providing a more accurate estimate of the population mean."),
        sliderInput("n_wlln", "Sample Size (WLLN):", min = 10, max = 1000, value = 100),
        plotOutput("wllnPlot")
      ),
      div(
        class = "theorem-section",
        h3("Central Limit Theorem"),
        div(class = "theorem-description", "The Central Limit Theorem (CLT) states that the distribution of sample means approximates a normal distribution as the sample size increases, regardless of the population distribution. Increasing the sample size makes the histogram of sample means smoother and more normally distributed. More simulations provide a clearer, more accurate histogram, enhancing the visibility of the normal distribution."),
        sliderInput("n_clt", "Sample Size (CLT):", min = 10, max = 1000, value = 100),
        sliderInput("num_simulations_clt", "Number of Simulations:", min = 100, max = 5000, value = 1000),
        plotOutput("cltPlot")
      )
    )
  )
)

# Define Server Logic
server <- function(input, output) {
  output$wllnPlot <- renderPlot({
    sample_size <- input$n_wlln
    samples <- rnorm(sample_size) # generate random numbers
    sample_means <- cumsum(samples) / (1:sample_size)

    ggplot(data.frame(x = 1:sample_size, y = sample_means), aes(x = x, y = y)) +
      geom_line(color = "blue") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      labs(title = "Weak Law of Large Numbers", x = "Sample Size", y = "Sample Mean") +
      theme_minimal()
  })

  output$cltPlot <- renderPlot({
    sample_size <- input$n_clt
    num_simulations <- input$num_simulations_clt
    means <- replicate(num_simulations, mean(rnorm(sample_size)))

    ggplot(data.frame(means), aes(x = means)) +
      geom_histogram(binwidth = 0.1, fill = "blue", alpha = 0.7) +
      labs(title = "Central Limit Theorem", x = "Sample Mean", y = "Frequency") +
      theme_minimal()
  })
}

# Run the App
shinyApp(ui = ui, server = server)
