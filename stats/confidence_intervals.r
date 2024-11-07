# AUTHOR: aryanthepain
library(shiny)

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
                    "Calculate and visualize the confidence interval for the mean of a standard normal distribution, allowing you to specify whether the population standard deviation is known or unknown. You can change the tail probabilities to get different confidence intervals. You can also prove that the smallest interval is symmetric about mean by changing one of the bounds."
                ),
                div(
                    class = "section inputs",
                    sliderInput("alpha", "Tail Probability (α):", min = 0.01, max = 0.2, value = 0.05),
                    radioButtons("sigma_option", "Sample variance:",
                        choices = list("Known" = "known", "Unknown" = "unknown"),
                        selected = "known"
                    ),
                    numericInput("sample_size", "Sample Size (n, for unknown σ):", value = 30, min = 2),
                    uiOutput("left_shift_slider"),
                    helpText("Set α to adjust the confidence level. Choose between known or unknown sigma and observe the interval comparisons. Modify the lower bound to demonstrate that the shortest interval is symmetric around the mean.")
                ),
                h4("Interval Length Comparison"),
                textOutput("ci_centered"),
                textOutput("ci_shifted"),
                textOutput("length_comparison"),
                plotOutput("ci_plot")
            )
        )
    )
)


server <- function(input, output, session) {
    # Reactive calculation for critical value based on sigma option
    critical_value <- reactive({
        if (input$sigma_option == "known") {
            qnorm(1 - input$alpha / 2)
        } else {
            qt(1 - input$alpha / 2, input$sample_size - 1)
        }
    })

    # Update left endpoint slider based on critical value
    output$left_shift_slider <- renderUI({
        sliderInput("left_shift", "Lower bound:",
            min = -4, max = -0.1, value = -critical_value(),
        )
    })

    output$ci_centered <- renderText({
        z_alpha <- critical_value()
        ci_centered <- c(-z_alpha, z_alpha)
        paste(
            "Centered Confidence Interval:",
            "[", round(ci_centered[1], 2), ", ", round(ci_centered[2], 2), "]",
            "(Length:", round(diff(ci_centered), 2), ")"
        )
    })

    output$ci_shifted <- renderText({
        z_alpha <- critical_value()
        centered_area <- if (input$sigma_option == "known") {
            pnorm(z_alpha) - pnorm(-z_alpha)
        } else {
            pt(z_alpha, input$sample_size - 1) - pt(-z_alpha, input$sample_size - 1)
        }

        left_endpoint <- input$left_shift

        if (input$sigma_option == "known") {
            cumulative_prob <- pnorm(left_endpoint) + centered_area
            if (cumulative_prob < 1) {
                right_endpoint <- qnorm(cumulative_prob)
                ci_shifted <- c(left_endpoint, right_endpoint)
                paste(
                    "Shifted Confidence Interval:",
                    "[", round(ci_shifted[1], 2), ", ", round(ci_shifted[2], 2), "]",
                    "(Length:", round(diff(ci_shifted), 2), ")"
                )
            } else {
                "The shifted interval cannot be computed with these parameters. Please adjust the lower bound or alpha."
            }
        } else {
            cumulative_prob <- pt(left_endpoint, input$sample_size - 1) + centered_area
            if (cumulative_prob < 1) {
                right_endpoint <- qt(cumulative_prob, input$sample_size - 1)
                ci_shifted <- c(left_endpoint, right_endpoint)
                paste(
                    "Shifted Confidence Interval:",
                    "[", round(ci_shifted[1], 2), ", ", round(ci_shifted[2], 2), "]",
                    "(Length:", round(diff(ci_shifted), 2), ")"
                )
            } else {
                "The shifted interval cannot be computed with these parameters. Please adjust the lower bound or alpha."
            }
        }
    })

    output$length_comparison <- renderText({
        paste("(Centered interval is shorter)")
    })

    output$ci_plot <- renderPlot({
        z_alpha <- critical_value()
        centered_area <- if (input$sigma_option == "known") {
            pnorm(z_alpha) - pnorm(-z_alpha)
        } else {
            pt(z_alpha, input$sample_size - 1) - pt(-z_alpha, input$sample_size - 1)
        }

        left_endpoint <- input$left_shift
        if (input$sigma_option == "known") {
            cumulative_prob <- pnorm(left_endpoint) + centered_area
            if (cumulative_prob < 1) {
                right_endpoint <- qnorm(cumulative_prob)
                plot_interval(z_alpha, left_endpoint, right_endpoint, "Z")
            } else {
                plot.new()
                text(0.5, 0.5, "The shifted interval cannot be computed with these parameters. Please adjust the lower bound or alpha.")
            }
        } else {
            cumulative_prob <- pt(left_endpoint, input$sample_size - 1) + centered_area
            if (cumulative_prob < 1) {
                right_endpoint <- qt(cumulative_prob, input$sample_size - 1)
                plot_interval(z_alpha, left_endpoint, right_endpoint, "t", input$sample_size - 1)
            } else {
                plot.new()
                text(0.5, 0.5, "The shifted interval cannot be computed with these parameters. Please adjust the lower bound or alpha.")
            }
        }
    })

    plot_interval <- function(crit_value, left_endpoint, right_endpoint, dist_type, df = NULL) {
        x_vals <- seq(-4, 4, length.out = 1000)
        y_vals <- if (dist_type == "Z") dnorm(x_vals) else dt(x_vals, df)

        ci_centered <- c(-crit_value, crit_value)
        ci_shifted <- c(left_endpoint, right_endpoint)

        plot(x_vals, y_vals,
            type = "l", lwd = 2, col = "black",
            xlab = "Z-score / t-score", ylab = "Density",
            main = "Effect of Shifting Lower Bound on Interval Length"
        )

        polygon(c(ci_centered[1], seq(ci_centered[1], ci_centered[2], length.out = 100), ci_centered[2]),
            c(0, dnorm(seq(ci_centered[1], ci_centered[2], length.out = 100)), 0),
            col = rgb(0, 1, 1, 0.2), border = NA
        )

        polygon(c(ci_shifted[1], seq(ci_shifted[1], ci_shifted[2], length.out = 100), ci_shifted[2]),
            c(0, dnorm(seq(ci_shifted[1], ci_shifted[2], length.out = 100)), 0),
            col = rgb(1, 1, 0, 0.2), border = NA
        )

        abline(v = ci_centered, col = rgb(0, 1, 1), lty = 2, lwd = 2)
        abline(v = ci_shifted, col = rgb(1, 1, 0), lty = 2, lwd = 2)

        legend("topright",
            legend = c("Centered Interval", "Shifted Interval"),
            col = c(rgb(1, 1, 0), rgb(0, 1, 1)), lwd = 2, lty = 2, bty = "n"
        )
    }
}

shinyApp(ui = ui, server = server)
