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
        FastingBloodSugar     = input$db_fasting_bg,
        HbA1c                 = input$db_hba1c,
        FrequentUrination     = as.numeric(input$db_freq_urine),
        Hypertension          = as.numeric(input$db_hypertension),
        ExcessiveThirst       = as.numeric(input$db_thirst),
        UnexplainedWeightLoss = as.numeric(input$db_weight_loss),
        Smoking               = as.numeric(input$db_smoking),
        BMI                   = input$db_bmi,
        FamilyHistoryDiabetes = as.numeric(input$db_fam_diabetes)
      )
      prob <- predict(db_model, newdata = new_data, type = "response")
      
      tagList(
        result_card(prob, "Type 2 Diabetes"),
        
        # ── Collapsible box plot section ────────────────────────────────────────
        tags$div(style = "margin-top:16px;",
                 tags$button(
                   class = "btn btn-outline-secondary btn-sm",
                   `data-toggle` = "collapse",
                   `data-target` = "#db_boxplot_section",
                   "📦 Show / Hide Variable Distributions"
                 ),
                 tags$div(id = "db_boxplot_section", class = "collapse",
                          tags$div(style = "margin-top:12px; background:#fff; border-radius:8px;
                            padding:16px; box-shadow:0 2px 8px rgba(0,0,0,0.08);",
                                   h5("Your Values vs. Population Distribution",
                                      style = "color:#444; margin-bottom:4px;"),
                                   p("Red dashed line = your value. Blue = No Diabetes, Red = Diabetes.",
                                     style = "color:#888; font-size:12px; margin-bottom:12px;"),
                                   fluidRow(
                                     column(6, plotOutput("db_box_fbs",  height = "220px")),
                                     column(6, plotOutput("db_box_hba1c", height = "220px"))
                                   ),
                                   fluidRow(
                                     column(6, plotOutput("db_box_bmi",  height = "220px")),
                                     column(6, plotOutput("db_box_blank", height = "220px"))
                                   )
                          )
                 )
        )
      )
    })
    
    # ── Box plot renderers ──────────────────────────────────────────────────────
    user_vals <- list(
      fbs   = input$db_fasting_bg,
      hba1c = input$db_hba1c,
      bmi   = input$db_bmi
    )
    
    db_plot <- db
    db_plot$DiagnosisLabel <- ifelse(db_plot$Diagnosis == 1, "Diabetes", "No Diabetes")
    db_plot$DiagnosisLabel <- factor(db_plot$DiagnosisLabel, levels = c("No Diabetes", "Diabetes"))
    
    make_db_boxplot <- function(col, user_val, xlabel) {
      par(mar = c(5, 4, 3, 1))
      boxplot(
        db_plot[[col]] ~ db_plot$DiagnosisLabel,
        col        = c("#5b9bd5", "#e74c3c"),
        main       = xlabel,
        xlab       = "",
        ylab       = xlabel,
        outline    = FALSE,
        cex.main   = 0.95,
        cex.axis   = 0.85,
        border     = c("#2176ae", "#c0392b")
      )
      abline(h = user_val, col = "#c0392b", lwd = 2, lty = 2)
      legend("topright", legend = "Your value",
             col = "#c0392b", lwd = 2, lty = 2, cex = 0.75, bty = "n")
    }
    
    output$db_box_fbs <- renderPlot({
      make_db_boxplot("FastingBloodSugar", user_vals$fbs, "Fasting Blood\nSugar (mg/dL)")
    })
    
    output$db_box_hba1c <- renderPlot({
      make_db_boxplot("HbA1c", user_vals$hba1c, "HbA1c (%)")
    })
    
    output$db_box_bmi <- renderPlot({
      make_db_boxplot("BMI", user_vals$bmi, "BMI")
    })
    
    output$db_box_blank <- renderPlot({
      par(mar = c(0,0,0,0))
      plot.new()
      text(0.5, 0.5,
           "Tip: Fasting Blood Sugar ≥ 126 mg/dL\nand HbA1c ≥ 6.5% are clinical\nthresholds for diabetes diagnosis.",
           cex = 1.0, col = "#666", adj = 0.5)
    })
  })
  # ── QUIZ LOGIC ──────────────────────────────────────────────────────────────
  
  # Quiz questions database - tailored to YOUR specific models and risk factors
  quiz_questions <- list(
    
    # === ALZHEIMER'S QUESTIONS ===
    list(
      question = "Which cognitive assessment score is used in the Alzheimer's risk calculator?",
      options = c(
        "MoCA (Montreal Cognitive Assessment)",
        "MMSE (Mini-Mental State Examination)",
        "ACE-R (Addenbrooke's Cognitive Examination)",
        "CDR (Clinical Dementia Rating)"
      ),
      correct = 2,
      explanation = "The MMSE (Mini-Mental State Examination) is a 30-point test used in our Alzheimer's calculator. Lower MMSE scores indicate greater cognitive impairment and higher Alzheimer's risk. Scores below 24 typically suggest cognitive decline."
    ),
    
    list(
      question = "In our Alzheimer's model, which assessment measures your ability to perform everyday tasks?",
      options = c(
        "Functional Assessment Score",
        "Activities of Daily Living (ADL) Score",
        "Both A and B",
        "Neither - we don't measure this"
      ),
      correct = 3,
      explanation = "Our calculator uses BOTH Functional Assessment and ADL (Activities of Daily Living) scores. These measure your ability to perform tasks like bathing, dressing, cooking, and managing finances - crucial indicators of Alzheimer's progression."
    ),
    
    list(
      question = "According to our model, which lifestyle factor is included as an Alzheimer's risk predictor?",
      options = c(
        "Diet quality",
        "Sleep quality",
        "Physical activity hours",
        "Alcohol consumption"
      ),
      correct = 2,
      explanation = "Sleep quality is a key predictor in our Alzheimer's model! Poor sleep is linked to increased amyloid-beta accumulation in the brain. The calculator uses a sleep quality score from 4-10, with higher scores indicating better sleep."
    ),
    
    # === KIDNEY DISEASE QUESTIONS ===
    list(
      question = "What is GFR and why is it critical for kidney disease assessment?",
      options = c(
        "Glucose Filtration Rate - measures blood sugar",
        "Glomerular Filtration Rate - measures how well kidneys filter waste",
        "General Function Rating - overall kidney health score",
        "Glucose-Free Range - safe blood sugar levels"
      ),
      correct = 2,
      explanation = "GFR (Glomerular Filtration Rate) measures how well your kidneys filter waste from blood. Our calculator uses GFR from 15-120 mL/min. Normal is 90+, and values below 60 for 3+ months indicate chronic kidney disease."
    ),
    
    list(
      question = "Which lab value in our kidney disease calculator measures protein waste in the blood?",
      options = c(
        "Serum creatinine",
        "BUN (Blood Urea Nitrogen) levels",
        "Both A and B",
        "HbA1c"
      ),
      correct = 3,
      explanation = "Our model uses BOTH serum creatinine and BUN levels! These measure protein waste products. High creatinine (>1.3 mg/dL) and high BUN (>20 mg/dL) indicate your kidneys aren't filtering waste properly."
    ),
    
    list(
      question = "Which symptom tracked in our kidney disease calculator is a common sign of kidney problems?",
      options = c(
        "Tremor",
        "Memory complaints",
        "Itching severity",
        "Excessive thirst"
      ),
      correct = 3,
      explanation = "Itching (pruritus) is included in our kidney calculator! When kidneys fail to remove toxins, they build up in the blood and cause severe itching. Our calculator rates itching severity from 0-10."
    ),
    
    # === PARKINSON'S QUESTIONS ===
    list(
      question = "What does UPDRS measure in our Parkinson's risk calculator?",
      options = c(
        "Brain imaging results",
        "Unified Parkinson's Disease Rating Scale - motor and non-motor symptoms",
        "Ultrasound Parkinson's Detection Rate",
        "Urban Pollution Disease Risk Score"
      ),
      correct = 2,
      explanation = "UPDRS (Unified Parkinson's Disease Rating Scale) is a comprehensive assessment of Parkinson's symptoms. Our calculator uses scores from 0-200, with higher scores indicating more severe symptoms and disability."
    ),
    
    list(
      question = "Which THREE motor symptoms are specifically tracked in our Parkinson's calculator?",
      options = c(
        "Tremor, Rigidity, Bradykinesia",
        "Tremor, Memory Loss, Confusion",
        "Rigidity, Itching, Muscle Cramps",
        "Bradykinesia, ADL, MMSE"
      ),
      correct = 1,
      explanation = "The classic Parkinson's triad: Tremor (shaking), Rigidity (stiffness), and Bradykinesia (slowness of movement). Our calculator tracks all three as yes/no indicators. These result from dopamine loss in the brain."
    ),
    
    list(
      question = "Which cognitive test is used in the Parkinson's calculator to assess mental function?",
      options = c(
        "MMSE",
        "MoCA (Montreal Cognitive Assessment)",
        "Functional Assessment",
        "ADL Score"
      ),
      correct = 2,
      explanation = "MoCA (Montreal Cognitive Assessment) is used in our Parkinson's model. It's scored 0-30 and is more sensitive than MMSE for detecting mild cognitive impairment in Parkinson's patients. Scores below 26 suggest cognitive decline."
    ),
    
    # === DIABETES QUESTIONS ===
    list(
      question = "What does HbA1c measure, and why is it in both our diabetes AND kidney disease calculators?",
      options = c(
        "Current blood sugar - it only affects diabetes",
        "Average blood sugar over 2-3 months - both diseases are linked",
        "Hemoglobin count - unrelated to either disease",
        "Hormone levels - affects metabolism only"
      ),
      correct = 2,
      explanation = "HbA1c measures average blood sugar over 2-3 months. It's in BOTH calculators because diabetes damages kidneys! HbA1c ≥6.5% indicates diabetes. Uncontrolled diabetes (high HbA1c) is a major cause of kidney disease."
    ),
    
    list(
      question = "Which THREE symptoms in our diabetes calculator indicate classic diabetes warning signs?",
      options = c(
        "Frequent urination, Excessive thirst, Unexplained weight loss",
        "Tremor, Rigidity, Bradykinesia",
        "Itching, Muscle cramps, Memory complaints",
        "Behavioral problems, Sleep issues, Depression"
      ),
      correct = 1,
      explanation = "The classic diabetes triad! High blood sugar causes: (1) Frequent urination (body tries to flush excess glucose), (2) Excessive thirst (from dehydration), (3) Weight loss (cells can't use glucose for energy). Our model tracks all three."
    ),
    
    list(
      question = "According to our diabetes model, which condition increases your diabetes risk?",
      options = c(
        "Depression",
        "Postural instability",
        "Hypertension (high blood pressure)",
        "Memory complaints"
      ),
      correct = 3,
      explanation = "Hypertension is a key predictor in our diabetes calculator! High blood pressure and diabetes often occur together (metabolic syndrome). Both damage blood vessels and increase risk for heart disease, stroke, and kidney disease."
    ),
    
    # === CROSS-DISEASE QUESTIONS ===
    list(
      question = "Which risk factor appears in ALL FOUR disease calculators?",
      options = c(
        "Age",
        "BMI",
        "Smoking",
        "Family history"
      ),
      correct = 2,
      explanation = "BMI appears in all four models! Obesity (BMI ≥30) increases risk for Alzheimer's, kidney disease, Parkinson's, and diabetes. It causes inflammation, insulin resistance, and vascular damage affecting multiple organs."
    ),
    
    list(
      question = "Which two diseases in our calculator share 'Functional Assessment' as a predictor?",
      options = c(
        "Alzheimer's and Diabetes",
        "Alzheimer's and Parkinson's",
        "Parkinson's and Kidney Disease",
        "Diabetes and Kidney Disease"
      ),
      correct = 2,
      explanation = "Both Alzheimer's and Parkinson's use Functional Assessment scores (0-10)! These neurodegenerative diseases progressively impair your ability to function independently. Lower scores indicate greater disability and disease severity."
    ),
    
    list(
      question = "Diabetes is a risk factor in which OTHER disease calculator?",
      options = c(
        "Alzheimer's only",
        "Parkinson's only",
        "Both Parkinson's and Kidney Disease (as comorbidity)",
        "Neither - diabetes only affects blood sugar"
      ),
      correct = 3,
      explanation = "Diabetes appears in the Parkinson's model! High blood sugar damages blood vessels in the brain, reduces blood flow, and increases neuroinflammation - raising risk for neurodegenerative diseases. It's also linked to kidney disease progression."
    )
  )
  
  # Reactive values for quiz state
  quiz_state <- reactiveValues(
    started = FALSE,
    current_q = 1,
    score = 0,
    answered = FALSE,
    selected = NULL,
    completed = FALSE,
    answers = rep(NA, 15)
  )
  
  # Reset quiz
  observeEvent(input$start_quiz, {
    quiz_state$started <- TRUE
    quiz_state$current_q <- 1
    quiz_state$score <- 0
    quiz_state$answered <- FALSE
    quiz_state$selected <- NULL
    quiz_state$completed <- FALSE
    quiz_state$answers <- rep(NA, 15)
  })
  
  observeEvent(input$restart_quiz, {
    quiz_state$started <- FALSE
    quiz_state$current_q <- 1
    quiz_state$score <- 0
    quiz_state$answered <- FALSE
    quiz_state$selected <- NULL
    quiz_state$completed <- FALSE
    quiz_state$answers <- rep(NA, 15)
  })
  
  # Quiz intro
  output$quiz_intro_ui <- renderUI({
    if (!quiz_state$started && !quiz_state$completed) {
      div(
        style = "background: white; border-radius: 10px; padding: 40px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.08);",
        tags$h1("🎯", style = "font-size: 64px; margin: 0;"),
        h3("Ready to Test Your Knowledge?", style = "color: #2C7BB6; margin-top: 10px;"),
        p("Answer 15 questions about the risk factors used in our disease calculators.", style = "color: #666; font-size: 15px;"),
        tags$ul(
          style = "text-align: left; display: inline-block; color: #555; font-size: 14px;",
          tags$li("Questions cover Alzheimer's, Kidney Disease, Parkinson's, and Diabetes"),
          tags$li("Immediate feedback with detailed explanations"),
          tags$li("Learn the science behind each risk factor"),
          tags$li("Track your score and earn achievement badges!")
        ),
        br(), br(),
        actionButton("start_quiz", "Start Quiz", class = "btn btn-primary btn-lg", style = "padding: 12px 40px; font-size: 16px;")
      )
    }
  })
  
  # Quiz question display
  output$quiz_question_ui <- renderUI({
    if (quiz_state$started && !quiz_state$completed) {
      q <- quiz_questions[[quiz_state$current_q]]
      
      option_buttons <- lapply(1:length(q$options), function(i) {
        is_correct <- (i == q$correct)
        is_selected <- (!is.null(quiz_state$selected) && quiz_state$selected == i)
        
        class_name <- "quiz-option"
        if (quiz_state$answered) {
          class_name <- paste(class_name, "disabled")
          if (is_selected && is_correct) class_name <- paste(class_name, "correct")
          if (is_selected && !is_correct) class_name <- paste(class_name, "incorrect")
          if (!is_selected && is_correct) class_name <- paste(class_name, "correct")
        }
        
        icon <- ""
        if (quiz_state$answered) {
          if (is_selected && is_correct) icon <- "✓ "
          if (is_selected && !is_correct) icon <- "✗ "
          if (!is_selected && is_correct) icon <- "✓ "
        }
        
        div(
          class = class_name,
          onclick = if (!quiz_state$answered) sprintf("Shiny.setInputValue('quiz_answer', %d, {priority: 'event'})", i) else "",
          paste0(icon, q$options[i])
        )
      })
      
      div(
        style = "background: white; border-radius: 10px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.08);",
        div(style = "color: #888; font-size: 12px; font-weight: 600; margin-bottom: 8px;",
            sprintf("QUESTION %d OF %d", quiz_state$current_q, length(quiz_questions))
        ),
        h4(q$question, style = "color: #333; margin-bottom: 20px; font-size: 18px; line-height: 1.6;"),
        option_buttons,
        
        # Explanation (shown after answering)
        if (quiz_state$answered) {
          div(
            class = "explanation-box",
            tags$b("💡 Did you know? "), q$explanation
          )
        },
        
        # Next button
        if (quiz_state$answered) {
          div(
            style = "margin-top: 20px; text-align: right;",
            actionButton(
              "next_question",
              if (quiz_state$current_q < length(quiz_questions)) "Next Question →" else "See Results",
              class = "btn btn-primary"
            )
          )
        }
      )
    }
  })
  
  # Progress bar
  output$quiz_progress_ui <- renderUI({
    if (quiz_state$started && !quiz_state$completed) {
      progress_pct <- (quiz_state$current_q - 1) / length(quiz_questions) * 100
      
      div(
        style = "margin-top: 20px;",
        div(
          style = "display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 13px; color: #666;",
          span(paste("Score:", quiz_state$score, "/", length(quiz_questions))),
          span(paste("Progress:", quiz_state$current_q - 1, "/", length(quiz_questions)))
        ),
        div(
          class = "progress",
          style = "height: 8px; border-radius: 4px;",
          div(
            class = "progress-bar bg-info",
            role = "progressbar",
            style = sprintf("width: %s%%;", progress_pct)
          )
        )
      )
    }
  })
  
  # Handle answer selection
  observeEvent(input$quiz_answer, {
    if (!quiz_state$answered) {
      quiz_state$selected <- input$quiz_answer
      quiz_state$answered <- TRUE
      quiz_state$answers[quiz_state$current_q] <- input$quiz_answer
      
      # Check if correct
      if (input$quiz_answer == quiz_questions[[quiz_state$current_q]]$correct) {
        quiz_state$score <- quiz_state$score + 1
      }
    }
  })
  
  # Handle next question
  observeEvent(input$next_question, {
    if (quiz_state$current_q < length(quiz_questions)) {
      quiz_state$current_q <- quiz_state$current_q + 1
      quiz_state$answered <- FALSE
      quiz_state$selected <- NULL
    } else {
      quiz_state$completed <- TRUE
      quiz_state$started <- FALSE
    }
  })
  
  # Final results
  output$quiz_results_ui <- renderUI({
    if (quiz_state$completed) {
      score_pct <- (quiz_state$score / length(quiz_questions)) * 100
      
      # Determine performance level
      if (score_pct >= 90) {
        badge_color <- "#27ae60"
        badge_text <- "🏆 Expert"
        message <- "Outstanding! You have excellent knowledge of chronic disease risk factors!"
      } else if (score_pct >= 70) {
        badge_color <- "#2C7BB6"
        badge_text <- "⭐ Proficient"
        message <- "Great job! You have a solid understanding of disease prevention."
      } else if (score_pct >= 50) {
        badge_color <- "#f39c12"
        badge_text <- "📚 Learning"
        message <- "Good effort! Review the RiskCalc tabs to strengthen your knowledge."
      } else {
        badge_color <- "#e74c3c"
        badge_text <- "🌱 Beginner"
        message <- "Keep learning! Explore each disease tab to learn more about risk factors."
      }
      
      div(
        style = "background: white; border-radius: 10px; padding: 40px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.08);",
        tags$h1("🎉", style = "font-size: 64px; margin: 0;"),
        h3("Quiz Complete!", style = "color: #2C7BB6; margin-top: 10px;"),
        
        div(
          style = sprintf("display: inline-block; background: %s; color: white; padding: 8px 20px; border-radius: 20px; font-weight: 600; margin: 15px 0;", badge_color),
          badge_text
        ),
        
        h1(
          paste0(quiz_state$score, "/", length(quiz_questions)),
          style = "color: #333; font-weight: 800; font-size: 48px; margin: 10px 0;"
        ),
        
        div(
          class = "progress",
          style = "height: 30px; margin: 20px auto; max-width: 400px; border-radius: 15px;",
          div(
            class = "progress-bar",
            role = "progressbar",
            style = sprintf("width: %s%%; background: %s; font-size: 16px; font-weight: 600;", score_pct, badge_color),
            paste0(round(score_pct), "%")
          )
        ),
        
        p(message, style = "color: #666; font-size: 15px; margin: 20px 0;"),
        
        br(),
        actionButton("restart_quiz", "Try Again", class = "btn btn-primary btn-lg", style = "padding: 12px 40px;")
      )
    }
  })
}
