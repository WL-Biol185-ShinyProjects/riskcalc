library(shiny)

ui <- navbarPage(
  title = "RiskCalc",
  id = "navbar",

  # Custom CSS for clean medical look
  header = tags$head(
    tags$style(HTML("
      body { background-color: #f5f7fa; font-family: 'Segoe UI', sans-serif; }
      .navbar { background-color: #2C7BB6 !important; }
      .navbar-brand, .navbar-nav > li > a { color: white !important; }
      .navbar-nav > li > a:hover { background-color: #1a5f94 !important; }
      .well { background-color: #ffffff; border: 1px solid #dde3ea; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.06); }
      .result-box { background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-top: 10px; }
      .section-label { font-size: 11px; font-weight: 700; color: #888; text-transform: uppercase; letter-spacing: 0.05em; margin-top: 14px; margin-bottom: 4px; }
      .btn-calc { width: 100%; margin-top: 10px; font-weight: 600; }
      .disclaimer { font-size: 12px; color: #999; margin-top: 12px; }
      h4.tab-title { color: #2C7BB6; font-weight: 700; margin-bottom: 4px; }
      .home-card { background: #fff; border-radius: 10px; padding: 20px; text-align: center;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.07); height: 100%; }
      .home-card h5 { color: #2C7BB6; margin-top: 10px; }
      .home-card p { color: #888; font-size: 13px; }
    "))
  ),

  # ── HOME ──────────────────────────────────────────────────────────────────
  tabPanel("Home",
    div(class = "container mt-4",
      div(class = "row justify-content-center",
        div(class = "col-md-9 text-center",
          h2("Chronic Disease Risk Calculator", style = "font-weight:700; color:#2C7BB6;"),
          p("Estimate your personal risk for four major chronic diseases using clinically-informed inputs.",
            style = "color:#666; font-size:16px;"),
          tags$hr(),
          fluidRow(
            column(3, div(class = "home-card", tags$h1("🧠"), h5("Alzheimer's"),
                          p("Cognitive decline risk"))),
            column(3, div(class = "home-card", tags$h1("🫘"), h5("Kidney Disease"),
                          p("Chronic kidney disease risk"))),
            column(3, div(class = "home-card", tags$h1("🚶"), h5("Parkinson's"),
                          p("Neurological disease risk"))),
            column(3, div(class = "home-card", tags$h1("💉"), h5("Diabetes"),
                          p("Type 2 diabetes risk")))
          ),
          div(class = "disclaimer mt-4",
            "⚠️ This tool is for educational purposes only. Always consult a healthcare professional.")
        )
      )
    )
  ),

  # ── ALZHEIMER'S ───────────────────────────────────────────────────────────
  tabPanel("Alzheimer's",
    div(class = "container mt-4",
      h4(class = "tab-title", "🧠 Alzheimer's Disease Risk"),
      p("Adjust your profile below and click Calculate.", style = "color:#666;"),
      fluidRow(
        column(4,
          wellPanel(
            p(class = "section-label", "Demographics"),
            sliderInput("alz_age", "Age (years)", 20, 90, 55),
            selectInput("alz_gender", "Gender", choices = c("Male" = 0, "Female" = 1)),
            selectInput("alz_ethnicity", "Ethnicity",
                        choices = c("Caucasian" = 0, "African American" = 1, "Asian" = 2, "Other" = 3)),
            selectInput("alz_edu", "Education Level",
                        choices = c("None" = 0, "High School" = 1, "Bachelor's" = 2, "Higher" = 3)),
            p(class = "section-label", "Lifestyle"),
            sliderInput("alz_bmi", "BMI", 15, 40, 25, step = 0.5),
            selectInput("alz_smoking", "Smoking", choices = c("No" = 0, "Yes" = 1)),
            sliderInput("alz_alcohol", "Alcohol (units/week)", 0, 20, 5),
            sliderInput("alz_physical", "Physical Activity (hrs/week)", 0, 10, 3),
            sliderInput("alz_diet", "Diet Quality (0-10)", 0, 10, 5),
            sliderInput("alz_sleep", "Sleep Quality (4-10)", 4, 10, 7),
            actionButton("calc_alz", "Calculate Risk", class = "btn btn-primary btn-calc")
          )
        ),
        column(8, uiOutput("alz_result_ui"),
          p(class = "disclaimer", "Estimated from a logistic regression model trained on the Alzheimer's dataset.")
        )
      )
    )
  ),

  # ── CHRONIC KIDNEY DISEASE ────────────────────────────────────────────────
  tabPanel("Kidney Disease",
    div(class = "container mt-4",
      h4(class = "tab-title", "🫘 Chronic Kidney Disease Risk"),
      p("Adjust your profile below and click Calculate.", style = "color:#666;"),
      fluidRow(
        column(4,
          wellPanel(
            p(class = "section-label", "Demographics"),
            sliderInput("ckd_age", "Age (years)", 20, 90, 55),
            selectInput("ckd_gender", "Gender", choices = c("Male" = 0, "Female" = 1)),
            selectInput("ckd_ethnicity", "Ethnicity",
                        choices = c("Caucasian" = 0, "African American" = 1, "Asian" = 2, "Other" = 3)),
            p(class = "section-label", "Lifestyle"),
            sliderInput("ckd_bmi", "BMI", 15, 40, 25, step = 0.5),
            selectInput("ckd_smoking", "Smoking", choices = c("No" = 0, "Yes" = 1)),
            sliderInput("ckd_alcohol", "Alcohol (units/week)", 0, 20, 5),
            sliderInput("ckd_physical", "Physical Activity (hrs/week)", 0, 10, 3),
            sliderInput("ckd_diet", "Diet Quality (0-10)", 0, 10, 5),
            p(class = "section-label", "Medical History"),
            selectInput("ckd_fam_kidney", "Family Hx: Kidney Disease", choices = c("No" = 0, "Yes" = 1)),
            selectInput("ckd_fam_htn", "Family Hx: Hypertension", choices = c("No" = 0, "Yes" = 1)),
            selectInput("ckd_fam_diabetes", "Family Hx: Diabetes", choices = c("No" = 0, "Yes" = 1)),
            selectInput("ckd_prev_aki", "Previous Acute Kidney Injury", choices = c("No" = 0, "Yes" = 1)),
            selectInput("ckd_uti", "Urinary Tract Infections", choices = c("No" = 0, "Yes" = 1)),
            p(class = "section-label", "Cholesterol"),
            sliderInput("ckd_chol_total", "Total Cholesterol (mg/dL)", 150, 300, 200),
            sliderInput("ckd_chol_ldl",   "LDL (mg/dL)", 50, 200, 100),
            sliderInput("ckd_chol_hdl",   "HDL (mg/dL)", 20, 100, 50),
            sliderInput("ckd_chol_trig",  "Triglycerides (mg/dL)", 50, 400, 150),
            actionButton("calc_ckd", "Calculate Risk", class = "btn btn-info btn-calc")
          )
        ),
        column(8, uiOutput("ckd_result_ui"),
          p(class = "disclaimer", "Estimated from a logistic regression model trained on the CKD dataset.")
        )
      )
    )
  ),

  # ── PARKINSON'S ───────────────────────────────────────────────────────────
  tabPanel("Parkinson's",
    div(class = "container mt-4",
      h4(class = "tab-title", "🚶 Parkinson's Disease Risk"),
      p("Adjust your profile below and click Calculate.", style = "color:#666;"),
      fluidRow(
        column(4,
          wellPanel(
            p(class = "section-label", "Demographics"),
            sliderInput("pk_age", "Age (years)", 20, 90, 55),
            selectInput("pk_gender", "Gender", choices = c("Male" = 0, "Female" = 1)),
            selectInput("pk_ethnicity", "Ethnicity",
                        choices = c("Caucasian" = 0, "African American" = 1, "Asian" = 2, "Other" = 3)),
            p(class = "section-label", "Lifestyle"),
            sliderInput("pk_bmi", "BMI", 15, 40, 25, step = 0.5),
            selectInput("pk_smoking", "Smoking", choices = c("No" = 0, "Yes" = 1)),
            sliderInput("pk_alcohol", "Alcohol (units/week)", 0, 20, 5),
            sliderInput("pk_physical", "Physical Activity (hrs/week)", 0, 10, 3),
            sliderInput("pk_diet", "Diet Quality (0-10)", 0, 10, 5),
            actionButton("calc_pk", "Calculate Risk", class = "btn btn-warning btn-calc")
          )
        ),
        column(8, uiOutput("pk_result_ui"),
          p(class = "disclaimer", "Estimated from a logistic regression model trained on the Parkinson's dataset.")
        )
      )
    )
  ),

  # ── DIABETES ──────────────────────────────────────────────────────────────
  tabPanel("Diabetes",
    div(class = "container mt-4",
      h4(class = "tab-title", "💉 Type 2 Diabetes Risk"),
      p("Adjust your profile below and click Calculate.", style = "color:#666;"),
      fluidRow(
        column(4,
          wellPanel(
            p(class = "section-label", "Demographics"),
            sliderInput("db_age", "Age (years)", 20, 90, 55),
            selectInput("db_gender", "Gender", choices = c("Male" = 0, "Female" = 1)),
            selectInput("db_ethnicity", "Ethnicity",
                        choices = c("Caucasian" = 0, "African American" = 1, "Asian" = 2, "Other" = 3)),
            p(class = "section-label", "Lifestyle"),
            sliderInput("db_bmi", "BMI", 15, 40, 25, step = 0.5),
            selectInput("db_smoking", "Smoking", choices = c("No" = 0, "Yes" = 1)),
            sliderInput("db_alcohol", "Alcohol (units/week)", 0, 20, 5),
            sliderInput("db_physical", "Physical Activity (hrs/week)", 0, 10, 3),
            sliderInput("db_diet", "Diet Quality (0-10)", 0, 10, 5),
            actionButton("calc_db", "Calculate Risk", class = "btn btn-danger btn-calc")
          )
        ),
        column(8, uiOutput("db_result_ui"),
          p(class = "disclaimer", "Estimated from a logistic regression model trained on the Diabetes dataset.")
        )
      )
    )
  ),

  # ── ABOUT ─────────────────────────────────────────────────────────────────
  tabPanel("About",
    div(class = "container mt-4",
      div(class = "row justify-content-center",
        div(class = "col-md-7",
          h4("About RiskCalc", style = "color:#2C7BB6; font-weight:700;"),
          p("RiskCalc is a Shiny app developed for BIOL 185. It estimates risk for
             four major chronic diseases using logistic regression models trained
             on publicly available Kaggle datasets."),
          tags$hr(),
          h5("Team"),
          p("jkim-3 · acordova7 · diassshym · ishaanbhadouria"),
          div(style = "background:#fff8e1; border-left: 4px solid #f0ad4e; padding:12px; border-radius:4px; margin-top:16px;",
            tags$b("Disclaimer: "),
            "This application is for educational purposes only and does not constitute medical advice."
          )
        )
      )
    )
  )
)
