library(shiny)

server <- function(input, output, session) {

  # Helper: render a "waiting" card before the user clicks Calculate
  waiting_card <- function(color = "primary") {
    div(class = paste0("alert alert-", color, " mt-3"),
        icon("circle-info"), " Fill in your profile and click ",
        tags$b("Calculate Risk"), " to see your estimated risk.")
  }

  # Helper: render a result card once probability is known
  result_card <- function(prob, disease, color) {
    pct   <- round(prob * 100, 1)
    level <- if (pct < 30) "Low" else if (pct < 60) "Moderate" else "High"
    bar_color <- if (pct < 30) "success" else if (pct < 60) "warning" else "danger"

    div(
      div(class = paste0("card border-", bar_color, " shadow-sm mt-3"),
        div(class = paste0("card-header bg-", bar_color, " text-white"),
          tags$b(paste("Estimated", disease, "Risk:"), level)
        ),
        div(class = "card-body",
          h2(paste0(pct, "%"), class = paste0("text-", bar_color)),
          div(class = "progress mb-3", style = "height: 20px;",
            div(class = paste0("progress-bar bg-", bar_color),
                role = "progressbar",
                style = paste0("width: ", pct, "%;"),
                paste0(pct, "%"))
          ),
          p(class = "text-muted small",
            icon("circle-info"),
            switch(level,
              "Low"      = "Your inputs suggest a relatively low risk. Keep maintaining healthy habits!",
              "Moderate" = "Your inputs suggest a moderate risk. Consider discussing lifestyle changes with your doctor.",
              "High"     = "Your inputs suggest an elevated risk. We strongly recommend consulting a healthcare provider."
            )
          )
        )
      )
    )
  }

  # ── Alzheimer's ────────────────────────────────────────────────────────────
  output$alz_result_ui <- renderUI({ waiting_card("primary") })

  observeEvent(input$calc_alz, {
    output$alz_result_ui <- renderUI({
      # TODO: replace with real model prediction once model is loaded
      # prob <- predict(alz_model, newdata = ..., type = "response")
      prob <- 0.5  # placeholder
      result_card(prob, "Alzheimer's", "primary")
    })
  })

  # ── Chronic Kidney Disease ─────────────────────────────────────────────────
  output$ckd_result_ui <- renderUI({ waiting_card("info") })

  observeEvent(input$calc_ckd, {
    output$ckd_result_ui <- renderUI({
      # TODO: replace with real model prediction
      prob <- 0.5  # placeholder
      result_card(prob, "Chronic Kidney Disease", "info")
    })
  })

  # ── Parkinson's ────────────────────────────────────────────────────────────
  output$pk_result_ui <- renderUI({ waiting_card("warning") })

  observeEvent(input$calc_pk, {
    output$pk_result_ui <- renderUI({
      # TODO: replace with real model prediction
      prob <- 0.5  # placeholder
      result_card(prob, "Parkinson's", "warning")
    })
  })

  # ── Diabetes ───────────────────────────────────────────────────────────────
  output$db_result_ui <- renderUI({ waiting_card("danger") })

  observeEvent(input$calc_db, {
    output$db_result_ui <- renderUI({
      # TODO: replace with real model prediction
      prob <- 0.5  # placeholder
      result_card(prob, "Diabetes", "danger")
    })
  })
}
