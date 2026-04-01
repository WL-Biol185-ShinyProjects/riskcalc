library(shiny)

# ── Load datasets and fit GLM models on startup ───────────────────────────────
alz <- read.csv("data/alzheimers_disease_data.csv")
ckd <- read.csv("data/Chronic_Kidney_Dsease_data.csv")
db  <- read.csv("data/diabetes_data.csv")
pk  <- read.csv("data/parkinsons_disease_data.csv")

# ── Variable Label Mappings for Heat Maps ──────────────────────────────────
var_labels <- list(
  # Alzheimer's
  FunctionalAssessment = "Functional Score",
  ADL = "ADL Score",
  MemoryComplaints = "Memory Complaints",
  MMSE = "MMSE Score",
  BehavioralProblems = "Behavioral Problems",
  EducationLevel = "Education Level",
  
  # Kidney Disease
  SerumCreatinine = "Serum Creatinine",
  GFR = "GFR",
  Itching = "Itching",
  FastingBloodSugar = "Fasting Blood Sugar",
  MuscleCramps = "Muscle Cramps",
  BUNLevels = "BUN Levels",
  ProteinInUrine = "Protein in Urine",
  SystolicBP = "Systolic BP",
  HbA1c = "HbA1c",
  BMI = "BMI",
  Edema = "Edema",
  
  # Parkinson's
  UPDRS = "UPDRS Score",
  Tremor = "Tremor",
  Rigidity = "Rigidity",
  Bradykinesia = "Bradykinesia",
  MoCA = "MoCA Score",
  PosturalInstability = "Postural Instability",
  Age = "Age",
  Depression = "Depression",
  Diabetes = "Diabetes",
  TraumaticBrainInjury = "Brain Injury",
  SleepDisorders = "Sleep Disorders",
  
  # Diabetes
  FrequentUrination = "Frequent Urination",
  Hypertension = "Hypertension",
  ExcessiveThirst = "Excessive Thirst",
  UnexplainedWeightLoss = "Weight Loss",
  Smoking = "Smoking",
  BlurredVision = "Blurred Vision"
)

# Alzheimer's GLM
# Top predictors: FunctionalAssessment, ADL, MemoryComplaints, MMSE,
#                 BehavioralProblems, SleepQuality, EducationLevel, Age, BMI, Smoking
alz_model <- glm(Diagnosis ~ FunctionalAssessment + ADL + MemoryComplaints + MMSE +
                   BehavioralProblems + EducationLevel,
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
                  ExcessiveThirst + UnexplainedWeightLoss + Smoking,
                data   = db,
                family = binomial)

# ── Result card renderer ──────────────────────────────────────────────────────
result_card <- function(prob, disease, plot_id) {
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
      ),
      
      # 🔥 ADD HEAT MAP HERE
      tags$div(style = "margin-top:20px;",
               h5("🔥 What's Driving Your Risk?", style = "color:#444; margin-bottom:10px;"),
               plotOutput(plot_id, height = "350px")
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

# ── Plot helpers ──────────────────────────────────────────────────────────────
make_boxplot <- function(dataset, col, diagnosis_col, user_val, xlabel,
                         no_label = "No", yes_label = "Yes") {
  plot_data <- dataset
  plot_data$DiagnosisLabel <- ifelse(plot_data[[diagnosis_col]] == 1, yes_label, no_label)
  plot_data$DiagnosisLabel <- factor(plot_data$DiagnosisLabel, levels = c(no_label, yes_label))
  par(mar = c(5, 4, 3, 1))
  boxplot(
    plot_data[[col]] ~ plot_data$DiagnosisLabel,
    col = c("#5b9bd5", "#e74c3c"), main = xlabel, xlab = "", ylab = xlabel,
    outline = FALSE, cex.main = 0.95, cex.axis = 0.85, border = c("#2176ae", "#c0392b")
  )
  abline(h = user_val, col = "#c0392b", lwd = 2, lty = 2)
  legend("topright", legend = "Your value", col = "#c0392b", lwd = 2, lty = 2, cex = 0.75, bty = "n")
}

make_barchart <- function(dataset, col, diagnosis_col, user_val, xlabel,
                          disease_label = "Disease") {
  
  n_no    <- sum(dataset[[col]] == 0)
  n_yes   <- sum(dataset[[col]] == 1)
  pct_no  <- mean(dataset[dataset[[col]] == 0, diagnosis_col]) * 100
  pct_yes <- mean(dataset[dataset[[col]] == 1, diagnosis_col]) * 100
  
  ci <- function(p, n) {
    p  <- p / 100
    z  <- 1.96
    centre <- (p + z^2 / (2*n)) / (1 + z^2 / n)
    margin <- (z * sqrt(p*(1-p)/n + z^2/(4*n^2))) / (1 + z^2/n)
    c(max(0, centre - margin), min(1, centre + margin)) * 100
  }
  
  ci_no  <- ci(pct_no,  n_no)
  ci_yes <- ci(pct_yes, n_yes)
  
  par(mar = c(5, 4, 4, 1))
  bp <- barplot(
    c(pct_no, pct_yes),
    names.arg = c(paste("No", xlabel), paste("Yes", xlabel)),
    col    = c("#5b9bd5", "#e74c3c"),
    border = c("#2176ae", "#c0392b"),
    main   = xlabel,
    ylab   = paste0("% with ", disease_label),
    ylim   = c(0, 115),
    cex.main = 0.95, cex.axis = 0.85, cex.names = 0.8
  )
  
  # error bars
  arrows(bp, c(ci_no[1],  ci_yes[1]),
         bp, c(ci_no[2],  ci_yes[2]),
         angle = 90, code = 3, length = 0.08, lwd = 1.5, col = "#333")
  
  # % labels — white box behind text so they never clash with error bars
  label_y <- c(ci_no[2], ci_yes[2]) + 6
  rect(bp - 0.4, label_y - 3, bp + 0.4, label_y + 3,   # ← white bg box
       col = "white", border = NA)
  text(bp, label_y,
       labels = paste0(round(c(pct_no, pct_yes), 1), "%"),
       cex = 0.8, col = "#222", font = 2)                # ← bold dark text
  
  # "your group" highlight — gold/yellow outline, clearly visible on both bars
  user_bar <- if (user_val == 1) 2 else 1
  rect(bp[user_bar] - 0.5, 0, bp[user_bar] + 0.5, c(pct_no, pct_yes)[user_bar],
       border = "#f0a500", lwd = 3, col = NA)             # ← gold instead of red
  
  legend("topright",
         legend = c("Your group", "95% CI"),
         col    = c("#f0a500", "#333"),                   # ← gold in legend too
         lwd    = c(3, 1.5),
         cex    = 0.75, bty = "n")
}


# ── Variable Contribution Heat Map ──────────────────────────────────────────
make_contribution_heatmap <- function(model, user_data, dataset, var_labels) {
  # Get coefficients (excluding intercept)
  coefs <- coef(model)[-1]
  
  # Get dataset means for each predictor
  predictor_names <- names(coefs)
  dataset_means <- sapply(predictor_names, function(var) mean(dataset[[var]], na.rm = TRUE))
  
  # Calculate raw contributions (coefficient × deviation from mean)
  user_vals <- unlist(user_data[predictor_names])
  deviations <- user_vals - dataset_means
  raw_contributions <- coefs * deviations
  
  # Convert to absolute contributions and normalize to percentages
  abs_contributions <- abs(raw_contributions)
  total <- sum(abs_contributions)
  pct_contributions <- if(total > 0) (abs_contributions / total) * 100 else rep(0, length(abs_contributions))
  
  # Determine if variable increases (+) or decreases (-) risk
  direction <- ifelse(raw_contributions > 0, "+", "-")
  
  # Create data frame for plotting
  contrib_df <- data.frame(
    Variable = var_labels[predictor_names],
    Value = round(user_vals, 2),
    Contribution = round(pct_contributions, 1),
    Direction = direction,
    stringsAsFactors = FALSE
  )
  
  # Sort by contribution (descending)
  contrib_df <- contrib_df[order(-contrib_df$Contribution), ]
  
  # Create color palette (red = increases risk, blue = decreases risk)
  colors <- ifelse(contrib_df$Direction == "+", 
                   rgb(0.8, 0.2, 0.2, alpha = contrib_df$Contribution/100),  # Red
                   rgb(0.2, 0.4, 0.8, alpha = contrib_df$Contribution/100))  # Blue
  
  # Plot
  par(mar = c(5, 10, 3, 2))
  barplot(
    contrib_df$Contribution,
    names.arg = contrib_df$Variable,
    horiz = TRUE,
    las = 1,
    col = colors,
    border = NA,
    xlab = "Contribution to Risk Score (%)",
    main = "Variable Importance Heat Map",
    xlim = c(0, max(contrib_df$Contribution) * 1.1),
    cex.names = 0.8,
    cex.main = 0.95
  )
  
  # Add percentage labels
  text(contrib_df$Contribution + 2, 
       seq(0.7, by = 1.2, length.out = nrow(contrib_df)),
       paste0(contrib_df$Contribution, "%"),
       pos = 4, cex = 0.75, col = "#333")
  
  # Add legend
  legend("bottomright", 
         legend = c("Increases Risk", "Decreases Risk"),
         fill = c(rgb(0.8, 0.2, 0.2, 0.7), rgb(0.2, 0.4, 0.8, 0.7)),
         border = NA,
         cex = 0.75,
         bty = "n")
}


render_disease_plots <- function(prefix, cfg, input, output) {
  ds       <- eval(cfg$dataset)
  all_vars <- c(cfg$continuous, cfg$binary)
  plot_ids <- paste0(prefix, "_p_", seq_along(all_vars))
  pairs    <- split(plot_ids, ceiling(seq_along(plot_ids) / 2))
  rows     <- lapply(pairs, function(pair) {
    do.call(fluidRow, lapply(pair, function(id) column(6, plotOutput(id, height = "220px"))))
  })
  dist_ui <- tags$div(style = "margin-top:16px;",
                      tags$button(class = "btn btn-outline-secondary btn-sm",
                                  `data-toggle` = "collapse",
                                  `data-target` = paste0("#", cfg$collapse_id),
                                  "📊 Show / Hide Variable Distributions"),
                      tags$div(id = cfg$collapse_id, class = "collapse",
                               tags$div(style = "margin-top:12px; background:#fff; border-radius:8px;
                        padding:16px; box-shadow:0 2px 8px rgba(0,0,0,0.08);",
                                        h5("Your Values vs. Population Distribution", style = "color:#444; margin-bottom:4px;"),
                                        p("Boxplots: red dashed = your value. Bar charts: red outline = your group.",
                                          style = "color:#888; font-size:12px; margin-bottom:12px;"),
                                        rows
                               )
                      )
  )
  n_cont <- length(cfg$continuous)
  for (i in seq_along(cfg$continuous)) {
    local({
      v  <- cfg$continuous[[i]]
      id <- paste0(prefix, "_p_", i)
      output[[id]] <- renderPlot({
        make_boxplot(ds, v$col, cfg$diagnosis_col,
                     eval(v$input, list(input = input)), v$label,
                     no_label = cfg$no_label, yes_label = cfg$yes_label)
      })
    })
  }
  for (i in seq_along(cfg$binary)) {
    local({
      v  <- cfg$binary[[i]]
      id <- paste0(prefix, "_p_", n_cont + i)
      output[[id]] <- renderPlot({
        make_barchart(ds, v$col, cfg$diagnosis_col,
                      as.numeric(eval(v$input, list(input = input))), v$label,
                      disease_label = cfg$disease_label)
      })
    })
  }
  dist_ui
}

# ── Disease config ────────────────────────────────────────────────────────────
disease_config <- list(
  alz = list(
    dataset = quote(alz), diagnosis_col = "Diagnosis",
    no_label = "No Alzheimer's", yes_label = "Alzheimer's",
    disease_label = "Alzheimer's", collapse_id = "alz_plots_section",
    continuous = list(
      list(col = "FunctionalAssessment", input = quote(input$alz_functional), label = "Functional Assessment"),
      list(col = "ADL",                  input = quote(input$alz_adl),        label = "ADL Score"),
      list(col = "MMSE",                 input = quote(input$alz_mmse),       label = "MMSE Score")
    ),
    binary = list(
      list(col = "MemoryComplaints",   input = quote(input$alz_memory),     label = "Memory Complaints"),
      list(col = "BehavioralProblems", input = quote(input$alz_behavioral), label = "Behavioral Problems")
    )
  ),
  ckd = list(
    dataset = quote(ckd), diagnosis_col = "Diagnosis",
    no_label = "No CKD", yes_label = "CKD",
    disease_label = "CKD", collapse_id = "ckd_plots_section",
    continuous = list(
      list(col = "SerumCreatinine",   input = quote(input$ckd_creatinine),  label = "Serum Creatinine (mg/dL)"),
      list(col = "GFR",               input = quote(input$ckd_gfr),         label = "GFR (mL/min)"),
      list(col = "FastingBloodSugar", input = quote(input$ckd_fasting_bg),  label = "Fasting Blood Sugar (mg/dL)"),
      list(col = "BUNLevels",         input = quote(input$ckd_bun),         label = "BUN Levels (mg/dL)"),
      list(col = "ProteinInUrine",    input = quote(input$ckd_protein),     label = "Protein in Urine (g/day)"),
      list(col = "HbA1c",             input = quote(input$ckd_hba1c),       label = "HbA1c (%)"),
      list(col = "Itching",           input = quote(input$ckd_itching),     label = "Itching Severity"),
      list(col = "MuscleCramps",      input = quote(input$ckd_cramps),      label = "Muscle Cramps (times/week)"),
      list(col = "SystolicBP",        input = quote(input$ckd_systolicbp),  label = "Systolic BP (mmHg)")
    ),
    binary = list()
  ),
  pk = list(
    dataset = quote(pk), diagnosis_col = "Diagnosis",
    no_label = "No Parkinson's", yes_label = "Parkinson's",
    disease_label = "Parkinson's", collapse_id = "pk_plots_section",
    continuous = list(
      list(col = "UPDRS",                input = quote(input$pk_updrs),      label = "UPDRS Score"),
      list(col = "FunctionalAssessment", input = quote(input$pk_functional), label = "Functional Assessment"),
      list(col = "MoCA",                 input = quote(input$pk_moca),       label = "MoCA Score"),
      list(col = "Age",                  input = quote(input$pk_age),        label = "Age (years)")
    ),
    binary = list(
      list(col = "Tremor",              input = quote(input$pk_tremor),      label = "Tremor"),
      list(col = "Rigidity",            input = quote(input$pk_rigidity),    label = "Rigidity"),
      list(col = "Bradykinesia",        input = quote(input$pk_brady),       label = "Bradykinesia"),
      list(col = "PosturalInstability", input = quote(input$pk_postural),    label = "Postural Instability"),
      list(col = "Depression",          input = quote(input$pk_depression),  label = "Depression"),
      list(col = "Diabetes",            input = quote(input$pk_diabetes),    label = "Diabetes"),
      list(col = "SleepDisorders",      input = quote(input$pk_diabetes),    label = "Sleep Disorders"),
      list(col = "TraumaticBrainInjury",input = quote(input$pk_diabetes),    label = "Traumatic Brain Injury")
    )
  ),
  db = list(
    dataset = quote(db), diagnosis_col = "Diagnosis",
    no_label = "No Diabetes", yes_label = "Diabetes",
    disease_label = "Diabetes", collapse_id = "db_plots_section",
    continuous = list(
      list(col = "FastingBloodSugar", input = quote(input$db_fasting_bg), label = "Fasting Blood Sugar (mg/dL)"),
      list(col = "HbA1c",            input = quote(input$db_hba1c),       label = "HbA1c (%)"),
      list(col = "BMI",              input = quote(input$db_bmi),         label = "BMI")
    ),
    binary = list(
      list(col = "FrequentUrination",     input = quote(input$db_freq_urine),   label = "Frequent Urination"),
      list(col = "Hypertension",          input = quote(input$db_hypertension), label = "Hypertension"),
      list(col = "ExcessiveThirst",       input = quote(input$db_thirst),       label = "Excessive Thirst"),
      list(col = "UnexplainedWeightLoss", input = quote(input$db_weight_loss),  label = "Unexplained Weight Loss"),
      list(col = "Smoking",               input = quote(input$db_smoking),      label = "Smoking")
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {
  
nav_from_button <- reactiveVal(FALSE)
  
observeEvent(input$navbar, ignoreInit = TRUE, {
  
  # 🛑 If navigation came from a button → DO NOTHING
  if (nav_from_button()) {
    nav_from_button(FALSE)
    return()
  }
  
  if (input$navbar == "Alzheimer's") {
    updateNavbarPage(session, "navbar", selected = "alz_info")
  }
  
  if (input$navbar == "Kidney Disease") {
    updateNavbarPage(session, "navbar", selected = "ckd_info")
  }
  
  if (input$navbar == "Parkinson's") {
    updateNavbarPage(session, "navbar", selected = "pk_info")
  }
  
  if (input$navbar == "Diabetes") {
    updateNavbarPage(session, "navbar", selected = "db_info")
  }
})
  
  
  # NAVIGATION FLOW
  observeEvent(input$go_alz_info, {
    updateNavbarPage(session, "navbar", selected = "alz_info")
  })
  observeEvent(input$go_ckd_info, {
    updateNavbarPage(session, "navbar", selected = "ckd_info")
  })
  observeEvent(input$go_pk_info, {
    updateNavbarPage(session, "navbar", selected = "pk_info")
  })
  observeEvent(input$go_db_info, {
    updateNavbarPage(session, "navbar", selected = "db_info")
  })
  
  observeEvent(input$go_alz_calc, {
    nav_from_button(TRUE)
    updateNavbarPage(session, "navbar", selected = "Alzheimer's")
  })
  
  observeEvent(input$go_ckd_calc, {
    nav_from_button(TRUE)
    updateNavbarPage(session, "navbar", selected = "Kidney Disease")
  })
  
  observeEvent(input$go_pk_calc, {
    nav_from_button(TRUE)
    updateNavbarPage(session, "navbar", selected = "Parkinson's")
  })
  
  observeEvent(input$go_db_calc, {
    nav_from_button(TRUE)
    updateNavbarPage(session, "navbar", selected = "Diabetes")
  })
  
  observeEvent(input$go_alz_calc2, {
    nav_from_button(TRUE)
    updateNavbarPage(session, "navbar", selected = "Alzheimer's")
  })
  
  observeEvent(input$go_ckd_calc2, {
    nav_from_button(TRUE)
    updateNavbarPage(session, "navbar", selected = "Kidney Disease")
  })
  
  observeEvent(input$go_pk_calc2, {
    nav_from_button(TRUE)
    updateNavbarPage(session, "navbar", selected = "Parkinson's")
  })
  
  observeEvent(input$go_db_calc2, {
    nav_from_button(TRUE)
    updateNavbarPage(session, "navbar", selected = "Diabetes")
  })
  # ── Alzheimer's ──────────────────────────────────────────────────────────────
  output$alz_result_ui <- renderUI({ waiting_card() })
  
  observeEvent(input$calc_alz, {
    output$alz_result_ui <- renderUI({
      new_data <- data.frame(
        FunctionalAssessment = input$alz_functional,
        ADL                  = input$alz_adl,
        MemoryComplaints     = as.numeric(input$alz_memory),
        MMSE                 = input$alz_mmse,
        BehavioralProblems   = as.numeric(input$alz_behavioral),
        EducationLevel       = as.numeric(input$alz_edu)
      )
      prob <- predict(alz_model, newdata = new_data, type = "response")
      
      # 🔥 RENDER HEAT MAP
      output$alz_heatmap <- renderPlot({
        make_contribution_heatmap(alz_model, new_data, alz, var_labels)
      })
      
      tagList(
        result_card(prob, "Alzheimer's Disease", "alz_heatmap"),
        render_disease_plots("alz", disease_config$alz, input, output)
      )
    })
  })
  
  # ── Chronic Kidney Disease ────────────────────────────────────────────────────
  output$ckd_result_ui <- renderUI({ waiting_card() })
  
  observeEvent(input$calc_ckd, {
    output$ckd_result_ui <- renderUI({
      new_data <- data.frame(
        SerumCreatinine   = input$ckd_creatinine,
        GFR               = input$ckd_gfr,
        Itching           = input$ckd_itching,
        FastingBloodSugar = input$ckd_fasting_bg,
        MuscleCramps      = input$ckd_cramps,
        BUNLevels         = input$ckd_bun,
        ProteinInUrine    = input$ckd_protein,
        SystolicBP        = input$ckd_systolicbp,
        HbA1c             = input$ckd_hba1c,
        BMI               = input$ckd_bmi
      )
      prob <- predict(ckd_model, newdata = new_data, type = "response")
      tagList(
        result_card(prob, "Chronic Kidney Disease"),
        render_disease_plots("ckd", disease_config$ckd, input, output)
      )
    })
  })
  
  # ── Parkinson's ───────────────────────────────────────────────────────────────
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
        Diabetes             = as.numeric(input$pk_diabetes),
        SleepDisorders       = as.numeric(input$pk_sleepdisorders),
        TraumaticBrainInjury = as.numeric(input$pk_traumaticbraininjury)
        
        
      )
      prob <- predict(pk_model, newdata = new_data, type = "response")
      tagList(
        result_card(prob, "Parkinson's Disease"),
        render_disease_plots("pk", disease_config$pk, input, output)
      )
    })
  })
  
  # ── Diabetes ──────────────────────────────────────────────────────────────────
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
        Smoking               = as.numeric(input$db_smoking)
      )
      prob <- predict(db_model, newdata = new_data, type = "response")
      tagList(
        result_card(prob, "Type 2 Diabetes"),
        render_disease_plots("db", disease_config$db, input, output)
      )
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


