library(shiny)

ui <- navbarPage(
  title = "RiskCalc",
  id = "navbar",

  header = tags$head(
    tags$style(HTML("
      body { background-color: #f5f7fa; font-family: 'Segoe UI', times-new-roman; }
      .navbar { background-color: #283867 !important; }
      .navbar-brand, .navbar-nav > li > a { color: white !important; }
      .navbar-nav > li > a:hover { background-color: #2C7BB6 !important; }
      .well { background-color: #ffffff; border: 1px solid #dde3ea; border-radius: 8px;
              box-shadow: 0 2px 6px rgba(0,0,0,0.06); }
      .section-label { font-size: 11px; font-weight: 700; color: #888;
                       text-transform: uppercase; letter-spacing: 0.05em;
                       margin-top: 14px; margin-bottom: 4px; }
      .btn-calc { width: 100%; margin-top: 10px; font-weight: 600; }
      .disclaimer { font-size: 12px; color: #999; margin-top: 12px; }
      h4.tab-title { color: #2C7BB6; font-weight: 700; margin-bottom: 4px; }
      .home-card { background: #fff; border-radius: 10px; padding: 20px; text-align: center;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.07); height: 100%; }
      .home-card h5 { color: #2C7BB6; margin-top: 10px; }
      .home-card p  { color: #888; font-size: 13px; }
    "))
  ),

  # ── HOME ────────────────────────────────────────────────────────────────────
  tabPanel("Home",
           div(class = "container mt-4",
               div(class = "row justify-content-center",
                   div(class = "col-md-12 text-center",
                       h2("Chronic Disease Risk Calculator", style = "font-weight:700; color:#2C7BB6;"),
                       p("Estimate risk for four major chronic diseases using clinically-informed inputs.",
                         style = "color:#666; font-size:16px;"),
                       tags$hr(),
                       fluidRow(style="margin-bottom:10px;",
                                column(6,
                                       div(style = "border:1px solid #ddd; border-radius:10px; padding:60px 15px; text-align:center; height:300px; cursor:pointer; margin:0px 5px; background:white;",
                                           onclick = "document.querySelector('[data-value=\"Alzheimer\\'s\"]').click();",
                                           tags$h1("🧠", style="font-size:75px; margin-top:-20px;"),
                                           h5("Alzheimer's Disease", style="color:#2C7BB6; font-weight:700; font-size:30px"),
                                           p("Alzheimer’s disease is a progressive, irreversible neurological disorder (the most common cause of dementia) that destroys memory, thinking skills, and eventually the ability to perform simple tasks.", style="color:#888; font-size:16.5px;")
                                       )
                                ),
                                column(6,
                                       div(style = "border:1px solid #ddd; border-radius:10px; padding:60px 15px; text-align:center; height:300px; cursor:pointer; margin:0px 5px; background:white;",
                                           onclick = "document.querySelector('[data-value=\"Kidney Disease\"]').click();",
                                           tags$h1("🫘", style="font-size:75px; margin-top:-20px;"),
                                           h5("Kidney Disease", style="color:#2C7BB6; font-weight:700; font-size:30px"),
                                           p("Kidney disease is the long-term, gradual loss of kidney function, preventing them from filtering waste, toxins, and excess fluid from the blood", style="color:#888; font-size:16.5px;")
                                       )
                                )
                       ),
                       fluidRow(
                         column(6,
                                div(style = "border:1px solid #ddd; border-radius:10px; padding:60px 15px; text-align:center; height:300px; cursor:pointer; margin:0px 5px; background:white;",
                                    onclick = "document.querySelector('[data-value=\"Parkinson\\'s\"]').click();",
                                    tags$h1("🚶", style="font-size:75px; margin-top:-20px;"),
                                    h5("Parkinson's Disease", style="color:#2C7BB6; font-weight:700; font-size:30px"),
                                    p("Parkinson’s disease is a progressive, neurodegenerative movement disorder of the central nervous system caused by the loss of dopamine-producing brain cells.", style="color:#888; font-size:16.5px;")
                                )
                         ),
                         column(6,
                                div(style = "border:1px solid #ddd; border-radius:10px; padding:60px 15px; text-align:center; height:300px; cursor:pointer; margin:0px 5px; background:white;",
                                    onclick = "document.querySelector('[data-value=\"Diabetes\"]').click();",
                                    tags$h1("💉", style="font-size:75px; margin-top:-20px;"),
                                    h5("Type 2 Diabetes", style="color:#2C7BB6; font-weight:700; font-size:30px"),
                                    p("Type 2 diabetes is a chronic condition where the body resists the effects of insulin or fails to produce enough, causing high blood sugar (glucose) levels.", style="color:#888; font-size:16.5px;")
                                )
                         )
                       ),
                       br(),
                       div(class = "disclaimer mt-3",
                           "⚠️ This tool is for educational purposes only. Always consult a healthcare professional."
                       )
                   )
               )
           )
  ),

  # ── ALZHEIMER'S ─────────────────────────────────────────────────────────────
  # Key predictors: FunctionalAssessment, ADL, MemoryComplaints, MMSE,
  #                 BehavioralProblems, SleepQuality, EducationLevel, Age, BMI, Smoking
  tabPanel("Alzheimer's",
    div(class = "container mt-4",
      h4(class = "tab-title", "🧠 Alzheimer's Disease Risk"),
      p("Adjust your profile below and click Calculate.", style = "color:#666;"),
      fluidRow(
        column(4,
          wellPanel(
            p(class = "section-label", "Cognitive & Functional"),
            sliderInput("alz_functional", "Functional Assessment Score (0–10)", 0, 10, 5, step = 0.1),
            sliderInput("alz_adl",        "Activities of Daily Living - ADL (0–10)", 0, 10, 5, step = 0.1),
            sliderInput("alz_mmse",       "MMSE Score (0–30)", 0, 30, 15, step = 0.5),
            selectInput("alz_memory",     "Memory Complaints", choices = c("No" = 0, "Yes" = 1)),
            selectInput("alz_behavioral", "Behavioral Problems", choices = c("No" = 0, "Yes" = 1)),
            p(class = "section-label", "Lifestyle & Demographics"),
            sliderInput("alz_sleep", "Sleep Quality (4–10)", 4, 10, 7, step = 0.1),
            selectInput("alz_edu",   "Education Level",
                        choices = c("None" = 0, "High School" = 1, "Bachelor's" = 2, "Higher" = 3)),
            sliderInput("alz_age",  "Age (years)", 20, 90, 55),
            sliderInput("alz_bmi",  "BMI", 15, 40, 25, step = 0.5),
            selectInput("alz_smoking", "Smoking", choices = c("No" = 0, "Yes" = 1)),
            actionButton("calc_alz", "Calculate Risk", class = "btn btn-primary btn-calc")
          )
        ),
        column(8,
          uiOutput("alz_result_ui"),
          p(class = "disclaimer", "Estimated using a GLM (logistic regression) model trained on the Alzheimer's dataset.")
        )
      )
    )
  ),

  # ── CHRONIC KIDNEY DISEASE ──────────────────────────────────────────────────
  # Key predictors: SerumCreatinine, GFR, Itching, FastingBloodSugar, MuscleCramps,
  #                 BUNLevels, ProteinInUrine, SystolicBP, HbA1c, BMI
  tabPanel("Kidney Disease",
    div(class = "container mt-4",
      h4(class = "tab-title", "🫘 Chronic Kidney Disease Risk"),
      p("Adjust your profile below and click Calculate.", style = "color:#666;"),
      fluidRow(
        column(4,
          wellPanel(
            p(class = "section-label", "Lab Values"),
            sliderInput("ckd_creatinine",  "Serum Creatinine (0.5–5.0 mg/dL)", 0.5, 5.0, 1.0, step = 0.1),
            sliderInput("ckd_gfr",         "GFR (15–120 mL/min)", 15, 120, 75),
            sliderInput("ckd_fasting_bg",  "Fasting Blood Sugar (70–200 mg/dL)", 70, 200, 100),
            sliderInput("ckd_bun",         "BUN Levels (5–50 mg/dL)", 5, 50, 15, step = 0.5),
            sliderInput("ckd_protein",     "Protein in Urine (0–5 g/day)", 0, 5, 0.5, step = 0.1),
            sliderInput("ckd_hba1c",       "HbA1c (%)", 4, 10, 5.5, step = 0.1),
            p(class = "section-label", "Symptoms"),
            sliderInput("ckd_itching",     "Itching Severity (0–10)", 0, 10, 2, step = 0.5),
            sliderInput("ckd_cramps",      "Muscle Cramps (0–7 times/week)", 0, 7, 1, step = 0.5),
            p(class = "section-label", "Vitals & Body"),
            sliderInput("ckd_systolicbp",  "Systolic BP (90–180 mmHg)", 90, 180, 120),
            sliderInput("ckd_bmi",         "BMI", 15, 40, 25, step = 0.5),
            actionButton("calc_ckd", "Calculate Risk", class = "btn btn-info btn-calc")
          )
        ),
        column(8,
          uiOutput("ckd_result_ui"),
          p(class = "disclaimer", "Estimated using a GLM (logistic regression) model trained on the CKD dataset.")
        )
      )
    )
  ),

  # ── PARKINSON'S ─────────────────────────────────────────────────────────────
  # Key predictors: UPDRS, Tremor, FunctionalAssessment, Rigidity, Bradykinesia,
  #                 MoCA, PosturalInstability, Age, Depression, Diabetes
  tabPanel("Parkinson's",
    div(class = "container mt-4",
      h4(class = "tab-title", "🚶 Parkinson's Disease Risk"),
      p("Adjust your profile below and click Calculate.", style = "color:#666;"),
      fluidRow(
        column(4,
          wellPanel(
            p(class = "section-label", "Motor Symptoms"),
            sliderInput("pk_updrs",    "UPDRS Score (0–200)", 0, 200, 50),
            selectInput("pk_tremor",   "Tremor Present",      choices = c("No" = 0, "Yes" = 1)),
            selectInput("pk_rigidity", "Rigidity Present",    choices = c("No" = 0, "Yes" = 1)),
            selectInput("pk_brady",    "Bradykinesia Present",choices = c("No" = 0, "Yes" = 1)),
            selectInput("pk_postural", "Postural Instability",choices = c("No" = 0, "Yes" = 1)),
            p(class = "section-label", "Cognitive & Functional"),
            sliderInput("pk_functional", "Functional Assessment (0–10)", 0, 10, 5, step = 0.1),
            sliderInput("pk_moca",       "MoCA Score (0–30)", 0, 30, 20, step = 0.5),
            p(class = "section-label", "Demographics & History"),
            sliderInput("pk_age",        "Age (years)", 20, 90, 65),
            selectInput("pk_depression", "Depression",  choices = c("No" = 0, "Yes" = 1)),
            selectInput("pk_diabetes",   "Diabetes",    choices = c("No" = 0, "Yes" = 1)),
            actionButton("calc_pk", "Calculate Risk", class = "btn btn-warning btn-calc")
          )
        ),
        column(8,
          uiOutput("pk_result_ui"),
          p(class = "disclaimer", "Estimated using a GLM (logistic regression) model trained on the Parkinson's dataset.")
        )
      )
    )
  ),

  # ── DIABETES ────────────────────────────────────────────────────────────────
  # Key predictors: FastingBloodSugar, HbA1c, FrequentUrination, Hypertension,
  #                 ExcessiveThirst, UnexplainedWeightLoss, Smoking, BMI, FamilyHistoryDiabetes
  tabPanel("Diabetes",
    div(class = "container mt-4",
      h4(class = "tab-title", "💉 Type 2 Diabetes Risk"),
      p("Adjust your profile below and click Calculate.", style = "color:#666;"),
      fluidRow(
        column(4,
          wellPanel(
            p(class = "section-label", "Lab Values"),
            sliderInput("db_fasting_bg", "Fasting Blood Sugar (70–200 mg/dL)", 70, 200, 100),
            sliderInput("db_hba1c",      "HbA1c (%)", 4, 10, 5.5, step = 0.1),
            p(class = "section-label", "Symptoms"),
            selectInput("db_freq_urine",  "Frequent Urination",       choices = c("No" = 0, "Yes" = 1)),
            selectInput("db_thirst",      "Excessive Thirst",         choices = c("No" = 0, "Yes" = 1)),
            selectInput("db_weight_loss", "Unexplained Weight Loss",  choices = c("No" = 0, "Yes" = 1)),
            p(class = "section-label", "Medical History & Lifestyle"),
            selectInput("db_hypertension", "Hypertension",            choices = c("No" = 0, "Yes" = 1)),
            selectInput("db_fam_diabetes", "Family History: Diabetes",choices = c("No" = 0, "Yes" = 1)),
            selectInput("db_smoking",      "Smoking",                 choices = c("No" = 0, "Yes" = 1)),
            sliderInput("db_bmi",          "BMI", 15, 40, 25, step = 0.5),
            actionButton("calc_db", "Calculate Risk", class = "btn btn-danger btn-calc")
          )
        ),
        column(8,
          uiOutput("db_result_ui"),
          p(class = "disclaimer", "Estimated using a GLM (logistic regression) model trained on the Diabetes dataset.")
        )
      )
    )
  ),

  # ── ABOUT ───────────────────────────────────────────────────────────────────
  tabPanel("About",
  div(class = "container mt-4",
    div(class = "row justify-content-center",
      div(class = "col-md-7",
        h4("About RiskCalc", style = "color:#2C7BB6; font-weight:700; font-size:18.5px;"),
        p("RiskCalc is a Shiny app developed for BIOL 185. It estimates risk for four major chronic diseases using GLM logistic regression models trained on publicly available Kaggle datasets."),
        tags$hr(),
        h5("Team", style = "color:#2C7BB6; font-weight:700; font-size:18.5px;"),
        br(),
        fluidRow(
          column(3, style = "text-align:center;",
            img(src="aaronpfp.jpeg", style="width:150px; height:150px; border-radius:50%; object-fit:cover;"),
            p(style="margin:0; line-height:1.6;", "Aaron Cordova", tags$br(), "W&L '27")
          ),
          column(3, style = "text-align:center;",
            img(src="ishaanpfp.jpeg", style="width:150px; height:150px; border-radius:50%; object-fit:cover;"),
            p(style="margin:0; line-height:1.6;", "Ishaan Bhadouria", tags$br(), "W&L '27")
          ),
          column(3, style = "text-align:center;",
            img(src="jaehunpfp.jpeg", style="width:150px; height:150px; border-radius:50%; object-fit:cover;"),
            p(style="margin:0; line-height:1.6;", "Jaehun Kim", tags$br(), "W&L '27")
          ),
          column(3, style = "text-align:center;",
            img(src="diaspfp.jpeg", style="width:150px; height:150px; border-radius:50%; object-fit:cover;"),
            p(style="margin:0; line-height:1.6;", "Dias Shymbay", tags$br(), "W&L '27")
          )
        ),
        br(),
        tags$hr(),
        # --- BIOS ---
        h5("Aaron Cordova", style="color:#2C7BB6; font-weight:700; font-size:18.5px;"),
        p(style="font-size:13px; color:#555;", "Student-athlete at Washington & Lee University pursuing a Neuroscience Major. Aaron plays Varsity Men's Soccer and has gained hands-on experience in coaching, leadership, and community engagement. He also holds CPR/BLS Training certification in Healthcare and has interned at the Platte City Area Chamber of Commerce."),
        p(style="font-size:13px; color:#555;", tags$b("Email: "), "acordova@mail.wlu.edu"),
        br(),
        h5("Ishaan Bhadouria", style="color:#2C7BB6; font-weight:700; font-size:18.5px;"),
        p(style="font-size:13px; color:#555;", "Student-athlete at Washington & Lee University pursuing a Neuroscience Major with an Entrepreneurship Minor. Ishaan competes on the basketball team while staying actively involved on campus as a Career Fellow, University Ambassador, and Community Assistant, with a passion for the healthcare field."),
        p(style="font-size:13px; color:#555;", tags$b("Email: "), "ibhadouria@mail.wlu.edu"),
        br(),
        h5("Jaehun Kim", style="color:#2C7BB6; font-weight:700; font-size:18.5px;"),
        p(style="font-size:13px; color:#555;", "Student at Washington & Lee University with experience in education and hospitality. Jaehun served as a Resident Teaching Assistant at Northwestern University's Center for Talent Development and previously worked as a Barista at W&L's Cafe 77, developing strong skills in customer service and team management."),
        p(style="font-size:13px; color:#555;", tags$b("Email: "), "jkim@mail.wlu.edu"),
        br(),
        h5("Dias Shymbay", style="color:#2C7BB6; font-weight:700; font-size:18.5px;"),
        p(style="font-size:13px; color:#555;", "Student at Washington & Lee University pursuing a BS in Neuroscience. Dias is actively involved in research, currently studying liposome-based chemotherapeutic treatments for brain cancer. He also serves as a Peer Tutor, Student Assistant at the Student Health and Counseling Center, and has completed internships in contract management and education volunteering internationally."),
        p(style="font-size:13px; color:#555;", tags$b("Email: "), "dshymbay@mail.wlu.edu"),
        br(),
        tags$hr(),
        # --- DISCLAIMER ---
        div(style = "background:#fff8e1; border-left:4px solid #f0ad4e; padding:12px; border-radius:4px; margin-top:16px;",
          tags$b("Disclaimer: "),
          "This app is for educational purposes only and does not constitute medical advice."
        )
      )
    )
  )
),
)