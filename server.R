library(shiny)

# ── Load datasets and fit GLM models on startup ───────────────────────────────
alz <- read.csv("data/alzheimers_disease_data.csv")
ckd <- read.csv("data/Chronic_Kidney_Dsease_data.csv")
db  <- read.csv("data/diabetes_data.csv")
pk  <- read.csv("data/parkinsons_disease_data.csv")

# Alzheimer's GLM
# Top predictors: FunctionalAssessment, ADL, MemoryComplaints, MMSE,
#                 BehavioralProblems, SleepQuality, EducationLevel, Age, BMI, Smoking
alz_model <- glm(Diagnosis ~ FunctionalAssessment + ADL + MemoryComplaints + MMSE +
                   BehavioralProblems + SleepQuality + EducationLevel + Age + BMI + Smoking,
                 data   = alz,
                 family = binomial)

# Chronic Kidney Disease GLM
# Top predictors: SerumCreatinine, GFR, Itching, FastingBloodSugar, MuscleCramps,
#                 BUNLevels, ProteinInUrine, SystolicBP, HbA1c, BMI
ckd_model <- glm(Diagnosis ~ SerumCreatinine + GFR + Itching + FastingBloodSugar +
                   MuscleCramps + BUNLevels + ProteinInUrine + SystolicBP + HbA1c + BMI,
                 data   = ckd,
                 family = binomial)

# Parkinson's GLM
# Top predictors: UPDRS, Tremor, FunctionalAssessment, Rigidity, Bradykinesia,
#                 MoCA, PosturalInstability, Age, Depression, Diabetes
pk_model <- glm(Diagnosis ~ UPDRS + Tremor + FunctionalAssessment + Rigidity +
                  Bradykinesia + MoCA + PosturalInstability + Age + Depression + Diabetes,
                data   = pk,
                family = binomial)

# Diabetes GLM
# Top predictors: FastingBloodSugar, HbA1c, FrequentUrination, Hypertension,
#                 ExcessiveThirst, UnexplainedWeightLoss, Smoking, BMI, FamilyHistoryDiabetes
db_model <- glm(Diagnosis ~ FastingBloodSugar + HbA1c + FrequentUrination + Hypertension +
                  ExcessiveThirst + UnexplainedWeightLoss + Smoking + BMI + FamilyHistoryDiabetes,
                data   = db,
                family = binomial)

# ── Result card renderer ──────────────────────────────────────────────────────
result_card <- function(prob, disease) {
  pct       <- round(prob * 100, 1)
  level     <- if (pct < 30) "Low" else if (pct < 60) "Moderate" else "High"
  bar_color <- if (pct < 30) "success" else if (pct < 60) "warning" else "danger"
  hex_color <- switch(bar_color, success = "#27ae60", warning = "#f39c12", danger = "#e74c3c")
  bg_color  <- switch(bar_color, success = "#eafaf1", warning = "#fef9e7", danger = "#fdedec")
  txt_color <- switch(bar_color, success = "#1e8449", warning = "#b7770d", danger = "#c0392b")
  border    <- paste0("border-left:4px solid ", hex_color, ";")
  msg <- switch(level,
    "Low"      = "Your inputs suggest a relatively low risk. Keep maintaining healthy habits!",
    "Moderate" = "Your inputs suggest a moderate risk. Consider discussing lifestyle changes with your doctor.",
    "High"     = "Your inputs suggest an elevated risk. We strongly recommend consulting a healthcare provider."
  )

  div(class = "result-box",
    style = "background:#fff; border-radius:8px; padding:24px; box-shadow:0 2px 8px rgba(0,0,0,0.08); margin-top:10px;",
    h4(paste("Estimated", disease, "Risk"), style = "color:#444; margin-bottom:4px;"),
    h1(paste0(pct, "%"), style = paste0("font-weight:800; color:", hex_color, ";")),
    tags$div(class = "progress", style = "height:22px; border-radius:6px; margin-bottom:12px;",
      tags$div(class = paste0("progress-bar bg-", bar_color),
               role = "progressbar",
               style = paste0("width:", pct, "%; font-size:14px; font-weight:600;"),
               paste0(pct, "%"))
    ),
    tags$div(
      style = paste0("padding:12px; border-radius:6px; font-size:13px; background:", bg_color,
                     "; color:", txt_color, "; ", border),
      tags$b(paste0(level, " Risk — ")), msg
    )
  )
}

waiting_card <- function() {
  div(style = "background:#f0f4f8; border-radius:8px; padding:30px; text-align:center;
               color:#888; margin-top:10px;",
    tags$h3("📊", style = "font-size:48px; margin-bottom:8px;"),
    p("Fill in your profile and click ", tags$b("Calculate Risk"),
      " to see your estimated probability.")
  )
}

# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  # ── Alzheimer's ─────────────────────────────────────────────────────────────
  output$alz_result_ui <- renderUI({ waiting_card() })

  observeEvent(input$calc_alz, {
    output$alz_result_ui <- renderUI({
      new_data <- data.frame(
        FunctionalAssessment = input$alz_functional,
        ADL                  = input$alz_adl,
        MemoryComplaints     = as.numeric(input$alz_memory),
        MMSE                 = input$alz_mmse,
        BehavioralProblems   = as.numeric(input$alz_behavioral),
        SleepQuality         = input$alz_sleep,
        EducationLevel       = as.numeric(input$alz_edu),
        Age                  = input$alz_age,
        BMI                  = input$alz_bmi,
        Smoking              = as.numeric(input$alz_smoking)
      )
      prob <- predict(alz_model, newdata = new_data, type = "response")
      result_card(prob, "Alzheimer's Disease")
    })
  })

  # ── Chronic Kidney Disease ───────────────────────────────────────────────────
  output$ckd_result_ui <- renderUI({ waiting_card() })

  observeEvent(input$calc_ckd, {
    output$ckd_result_ui <- renderUI({
      new_data <- data.frame(
        SerumCreatinine  = input$ckd_creatinine,
        GFR              = input$ckd_gfr,
        Itching          = input$ckd_itching,
        FastingBloodSugar= input$ckd_fasting_bg,
        MuscleCramps     = input$ckd_cramps,
        BUNLevels        = input$ckd_bun,
        ProteinInUrine   = input$ckd_protein,
        SystolicBP       = input$ckd_systolicbp,
        HbA1c            = input$ckd_hba1c,
        BMI              = input$ckd_bmi
      )
      prob <- predict(ckd_model, newdata = new_data, type = "response")
      result_card(prob, "Chronic Kidney Disease")
    })
  })

  # ── Parkinson's ──────────────────────────────────────────────────────────────
  output$pk_result_ui <- renderUI({ waiting_card() })

  observeEvent(input$calc_pk, {
    output$pk_result_ui <- renderUI({
      new_data <- data.frame(
        UPDRS                = input$pk_updrs,
        Tremor               = as.numeric(input$pk_tremor),
        FunctionalAssessment = input$pk_functional,
        Rigidity             = as.numeric(input$pk_rigidity),
        Bradykinesia         = as.numeric(input$pk_brady),
        MoCA                 = input$pk_moca,
        PosturalInstability  = as.numeric(input$pk_postural),
        Age                  = input$pk_age,
        Depression           = as.numeric(input$pk_depression),
        Diabetes             = as.numeric(input$pk_diabetes)
      )
      prob <- predict(pk_model, newdata = new_data, type = "response")
      result_card(prob, "Parkinson's Disease")
    })
  })

  # ── Diabetes ─────────────────────────────────────────────────────────────────
  output$db_result_ui <- renderUI({ waiting_card() })

  observeEvent(input$calc_db, {
    output$db_result_ui <- renderUI({
      new_data <- data.frame(
        FastingBloodSugar    = input$db_fasting_bg,
        HbA1c                = input$db_hba1c,
        FrequentUrination    = as.numeric(input$db_freq_urine),
        Hypertension         = as.numeric(input$db_hypertension),
        ExcessiveThirst      = as.numeric(input$db_thirst),
        UnexplainedWeightLoss= as.numeric(input$db_weight_loss),
        Smoking              = as.numeric(input$db_smoking),
        BMI                  = input$db_bmi,
        FamilyHistoryDiabetes= as.numeric(input$db_fam_diabetes)
      )
      prob <- predict(db_model, newdata = new_data, type = "response")
      result_card(prob, "Type 2 Diabetes")
    })
  })
}
