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
      
      .quiz-option { 
        background: white; 
        border: 2px solid #ddd; 
        border-radius: 8px; 
        padding: 15px; 
        margin: 8px 0; 
        cursor: pointer; 
        transition: all 0.2s;
        font-size: 14px;
      }
      .quiz-option:hover { 
        border-color: #2C7BB6; 
        background: #f8fbff; 
      }
      .quiz-option.correct { 
        border-color: #27ae60; 
        background: #eafaf1; 
      }
      .quiz-option.incorrect { 
        border-color: #e74c3c; 
        background: #fdedec; 
      }
      .quiz-option.disabled {
        cursor: not-allowed;
        opacity: 0.6;
      }
      .explanation-box {
        background: #fff8e1;
        border-left: 4px solid #f39c12;
        padding: 15px;
        border-radius: 6px;
        margin-top: 15px;
        font-size: 13px;
      }
      
      /* 🔥 HIDE INFO TABS + CALCULATOR TABS FROM NAVBAR */
      li a[data-value='alz_info'],
      li a[data-value='ckd_info'],
      li a[data-value='pk_info'],
      li a[data-value='db_info'],
      li a[data-value='Alzheimer\\'s'],
      li a[data-value='Kidney Disease'],
      li a[data-value='Parkinson\\'s'],
      li a[data-value='Diabetes'] {
        display: none !important;
      }
      
      /* 🎨 INFO PAGE HERO SECTIONS */
      .info-hero {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 60px 40px;
        border-radius: 12px;
        margin-bottom: 30px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        text-align: center;
      }
      .info-hero.alz { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
      .info-hero.ckd { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
      .info-hero.pk { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
      .info-hero.db { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
      
      .info-hero h1 { 
        font-size: 72px; 
        margin: 0; 
        text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
      }
      .info-hero h2 { 
        font-size: 36px; 
        font-weight: 700; 
        margin: 15px 0 10px 0;
        text-shadow: 1px 1px 3px rgba(0,0,0,0.2);
      }
      .info-hero p { 
        font-size: 18px; 
        opacity: 0.95; 
        max-width: 800px; 
        margin: 0 auto 25px auto;
        line-height: 1.6;
      }
      
      .info-section {
        background: white;
        border-radius: 10px;
        padding: 30px;
        margin-bottom: 25px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      }
      
      .info-section h3 {
        color: #2C7BB6;
        font-weight: 700;
        font-size: 24px;
        margin-top: 0;
        margin-bottom: 15px;
      }
      
      .info-section p {
        color: #555;
        font-size: 15px;
        line-height: 1.7;
        margin-bottom: 12px;
      }
      
      .stat-box {
        background: #f8f9fa;
        border-left: 4px solid #2C7BB6;
        padding: 20px;
        border-radius: 8px;
        margin: 15px 0;
      }
      
      .stat-box h4 {
        color: #2C7BB6;
        font-size: 32px;
        font-weight: 800;
        margin: 0 0 5px 0;
      }
      
      .stat-box p {
        color: #666;
        font-size: 14px;
        margin: 0;
      }
      
      .risk-factor-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin-top: 15px;
      }
      
      .risk-factor-card {
        background: #f8f9fa;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        padding: 15px;
        text-align: center;
        transition: all 0.2s;
      }
      
      .risk-factor-card:hover {
        border-color: #2C7BB6;
        background: #f0f7ff;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(44, 123, 182, 0.15);
      }
      
      .risk-factor-card .icon {
        font-size: 32px;
        margin-bottom: 8px;
      }
      
      .risk-factor-card .label {
        color: #333;
        font-size: 13px;
        font-weight: 600;
      }
      
      .cta-button {
        display: inline-block;
        background: white;
        color: #764ba2;
        padding: 15px 40px;
        border-radius: 8px;
        font-size: 18px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        transition: all 0.2s;
      }
      
      .cta-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(0,0,0,0.2);
      }
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
                                       div(style = "border:1px solid #ddd; border-radius:10px; padding:60px 15px; text-align:center; height:300px; cursor:pointer; margin:0px 5px; background:white; transition: all 0.2s;",
                                           onmouseover = "this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 16px rgba(0,0,0,0.15)';",
                                           onmouseout = "this.style.transform='translateY(0)'; this.style.boxShadow='none';",
                                           onclick = "Shiny.setInputValue('go_alz_info', Math.random())",
                                           tags$h1("🧠", style="font-size:75px; margin-top:-20px;"),
                                           h5("Alzheimer's Disease", style="color:#2C7BB6; font-weight:700; font-size:30px"),
                                           p("Progressive neurological disorder affecting memory, thinking, and daily function.", style="color:#888; font-size:16.5px;")
                                       )
                                ),
                                column(6,
                                       div(style = "border:1px solid #ddd; border-radius:10px; padding:60px 15px; text-align:center; height:300px; cursor:pointer; margin:0px 5px; background:white; transition: all 0.2s;",
                                           onmouseover = "this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 16px rgba(0,0,0,0.15)';",
                                           onmouseout = "this.style.transform='translateY(0)'; this.style.boxShadow='none';",
                                           onclick = "Shiny.setInputValue('go_ckd_info', Math.random())",
                                           tags$h1("🫘", style="font-size:75px; margin-top:-20px;"),
                                           h5("Kidney Disease", style="color:#2C7BB6; font-weight:700; font-size:30px"),
                                           p("Gradual loss of kidney function preventing filtration of waste and toxins from blood.", style="color:#888; font-size:16.5px;")
                                       )
                                )
                       ),
                       fluidRow(
                         column(6,
                                div(style = "border:1px solid #ddd; border-radius:10px; padding:60px 15px; text-align:center; height:300px; cursor:pointer; margin:0px 5px; background:white; transition: all 0.2s;",
                                    onmouseover = "this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 16px rgba(0,0,0,0.15)';",
                                    onmouseout = "this.style.transform='translateY(0)'; this.style.boxShadow='none';",
                                    onclick = "Shiny.setInputValue('go_pk_info', Math.random())",
                                    tags$h1("🚶", style="font-size:75px; margin-top:-20px;"),
                                    h5("Parkinson's Disease", style="color:#2C7BB6; font-weight:700; font-size:30px"),
                                    p("Progressive movement disorder caused by loss of dopamine-producing brain cells.", style="color:#888; font-size:16.5px;")
                                )
                         ),
                         column(6,
                                div(style = "border:1px solid #ddd; border-radius:10px; padding:60px 15px; text-align:center; height:300px; cursor:pointer; margin:0px 5px; background:white; transition: all 0.2s;",
                                    onmouseover = "this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 16px rgba(0,0,0,0.15)';",
                                    onmouseout = "this.style.transform='translateY(0)'; this.style.boxShadow='none';",
                                    onclick = "Shiny.setInputValue('go_db_info', Math.random())",
                                    tags$h1("💉", style="font-size:75px; margin-top:-20px;"),
                                    h5("Type 2 Diabetes", style="color:#2C7BB6; font-weight:700; font-size:30px"),
                                    p("Chronic condition where the body resists insulin or fails to produce enough, causing high blood sugar.", style="color:#888; font-size:16.5px;")
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
  
  # ── ALZHEIMER'S INFO PAGE ───────────────────────────────────────────────────
  tabPanel("alz_info",
           div(class = "container mt-4",
               # Hero Section
               div(class = "info-hero alz",
                   h1("🧠"),
                   h2("Alzheimer's Disease"),
                   p("The most common cause of dementia, affecting 6.9 million Americans aged 65+. Alzheimer's progressively destroys memory, thinking skills, and the ability to perform simple tasks."),
                   actionButton("go_alz_calc", "Assess Your Risk →", class = "cta-button")
               ),
               
               div(class = "row",
                   div(class = "col-md-8",
                       # Statistics
                       div(class = "info-section",
                           h3("📊 Key Statistics"),
                           div(class = "row",
                               div(class = "col-md-6",
                                   div(class = "stat-box",
                                       h4("6.9M"),
                                       p("Americans living with Alzheimer's (2024)")
                                   )
                               ),
                               div(class = "col-md-6",
                                   div(class = "stat-box",
                                       h4("7th"),
                                       p("Leading cause of death in the United States")
                                   )
                               )
                           ),
                           p("By 2050, the number of people aged 65+ with Alzheimer's may reach 13 million. Every 65 seconds, someone in the U.S. develops Alzheimer's dementia.")
                       ),
                       
                       # What We Assess
                       div(class = "info-section",
                           h3("🔍 What Our Calculator Assesses"),
                           p("Our Alzheimer's risk calculator uses validated clinical assessments to estimate your current risk profile:"),
                           
                           div(class = "risk-factor-grid",
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🧩"),
                                   div(class = "label", "MMSE Score")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "📋"),
                                   div(class = "label", "ADL Assessment")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🎯"),
                                   div(class = "label", "Functional Score")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "💭"),
                                   div(class = "label", "Memory Complaints")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "😟"),
                                   div(class = "label", "Behavioral Changes")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "👤"),
                                   div(class = "label", "Age & Demographics")
                               )
                           )
                       ),
                       
                       # Understanding Risk
                       div(class = "info-section",
                           h3("⚡ Understanding Your Risk"),
                           p(tags$b("Cognitive Tests:"), " The MMSE (Mini-Mental State Examination) is a 30-point test assessing memory, attention, and language. Scores below 24 suggest cognitive impairment."),
                           p(tags$b("Functional Assessment:"), " Measures your ability to manage daily activities like cooking, managing finances, and self-care. Decline in these areas is an early warning sign."),
                           p(tags$b("Age Factor:"), " Risk doubles every 5 years after age 65. However, cognitive test scores are more predictive than age alone in symptomatic individuals."),
                           tags$div(style="background:#fff3cd; border-left:4px solid #ffc107; padding:12px; border-radius:4px; margin-top:15px;",
                                    tags$b("Important:"), " This calculator assesses current symptom-based risk, not long-term prevention factors like midlife exercise or diet."
                           )
                       )
                   ),
                   
                   div(class = "col-md-4",
                       # Quick Facts
                       div(class = "info-section",
                           h3("💡 Quick Facts"),
                           tags$ul(style="color:#555; font-size:14px; line-height:1.8;",
                                   tags$li("Alzheimer's accounts for 60-80% of dementia cases"),
                                   tags$li("Women are more likely to develop Alzheimer's"),
                                   tags$li("Early-onset (before 65) affects ~200,000 Americans"),
                                   tags$li("No cure exists, but early detection helps planning"),
                                   tags$li("Brain changes begin 20+ years before symptoms")
                           )
                       ),
                       
                       # Warning Signs
                       div(class = "info-section",
                           h3("⚠️ Warning Signs"),
                           tags$ul(style="color:#555; font-size:14px; line-height:1.8;",
                                   tags$li("Memory loss disrupting daily life"),
                                   tags$li("Difficulty completing familiar tasks"),
                                   tags$li("Confusion with time or place"),
                                   tags$li("Problems with words in speaking/writing"),
                                   tags$li("Poor judgment and decision-making"),
                                   tags$li("Withdrawal from social activities")
                           )
                       )
                   )
               ),
               
               # CTA Bottom
               div(style="text-align:center; margin:40px 0;",
                   actionButton("go_alz_calc2", "Start Alzheimer's Assessment →", class = "btn btn-primary btn-lg", style="padding:15px 50px; font-size:18px;")
               )
           )
  ),
  
  # ── KIDNEY DISEASE INFO PAGE ────────────────────────────────────────────────
  tabPanel("ckd_info",
           div(class = "container mt-4",
               # Hero Section
               div(class = "info-hero ckd",
                   h1("🫘"),
                   h2("Chronic Kidney Disease"),
                   p("Over 37 million Americans have CKD, but 90% don't know it. Kidneys filter waste and excess fluid from blood—when they fail, toxins build up, leading to serious complications."),
                   actionButton("go_ckd_calc", "Assess Your Risk →", class = "cta-button")
               ),
               
               div(class = "row",
                   div(class = "col-md-8",
                       # Statistics
                       div(class = "info-section",
                           h3("📊 Key Statistics"),
                           div(class = "row",
                               div(class = "col-md-6",
                                   div(class = "stat-box",
                                       h4("37M+"),
                                       p("Americans with chronic kidney disease")
                                   )
                               ),
                               div(class = "col-md-6",
                                   div(class = "stat-box",
                                       h4("90%"),
                                       p("Don't know they have kidney disease")
                                   )
                               )
                           ),
                           p("CKD is the 9th leading cause of death in the U.S. Diabetes and high blood pressure cause 2 out of 3 cases.")
                       ),
                       
                       # What We Assess
                       div(class = "info-section",
                           h3("🔍 What Our Calculator Assesses"),
                           p("Our kidney disease calculator combines laboratory values with clinical symptoms to evaluate kidney function:"),
                           
                           div(class = "risk-factor-grid",
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🧪"),
                                   div(class = "label", "Serum Creatinine")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "📉"),
                                   div(class = "label", "GFR (Filtration Rate)")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "💧"),
                                   div(class = "label", "Protein in Urine")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🩺"),
                                   div(class = "label", "Blood Pressure")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "💢"),
                                   div(class = "label", "Itching & Cramps")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🫧"),
                                   div(class = "label", "Edema (Swelling)")
                               )
                           )
                       ),
                       
                       # Understanding Risk
                       div(class = "info-section",
                           h3("⚡ Understanding Your Risk"),
                           p(tags$b("GFR (Glomerular Filtration Rate):"), " Measures how well kidneys filter. Normal is 90+. Below 60 for 3+ months = CKD. Below 15 = kidney failure."),
                           p(tags$b("Creatinine & BUN:"), " Waste products that build up when kidneys fail. High creatinine (>1.3 mg/dL) and BUN (>20 mg/dL) signal impaired function."),
                           p(tags$b("Edema:"), " Swelling in legs, ankles, or feet occurs when kidneys can't remove excess fluid. A classic warning sign of declining kidney function."),
                           tags$div(style="background:#fff3cd; border-left:4px solid #ffc107; padding:12px; border-radius:4px; margin-top:15px;",
                                    tags$b("Important:"), " Early CKD has no symptoms. Regular testing (creatinine, GFR) is crucial for people with diabetes or hypertension."
                           )
                       )
                   ),
                   
                   div(class = "col-md-4",
                       # Quick Facts
                       div(class = "info-section",
                           h3("💡 Quick Facts"),
                           tags$ul(style="color:#555; font-size:14px; line-height:1.8;",
                                   tags$li("Kidneys filter 200 quarts of blood daily"),
                                   tags$li("Diabetes causes 38% of kidney failure cases"),
                                   tags$li("High BP causes 26% of kidney failure cases"),
                                   tags$li("African Americans are 3x more at risk"),
                                   tags$li("CKD increases heart disease risk by 2-5x")
                           )
                       ),
                       
                       # Warning Signs
                       div(class = "info-section",
                           h3("⚠️ Warning Signs"),
                           tags$ul(style="color:#555; font-size:14px; line-height:1.8;",
                                   tags$li("Fatigue and weakness"),
                                   tags$li("Swollen ankles, feet, or hands"),
                                   tags$li("Shortness of breath"),
                                   tags$li("Foamy or bloody urine"),
                                   tags$li("Frequent urination, especially at night"),
                                   tags$li("Severe itching and muscle cramps")
                           )
                       )
                   )
               ),
               
               # CTA Bottom
               div(style="text-align:center; margin:40px 0;",
                   actionButton("go_ckd_calc2", "Start Kidney Disease Assessment →", class = "btn btn-success btn-lg", style="padding:15px 50px; font-size:18px;")
               )
           )
  ),
  
  # ── PARKINSON'S INFO PAGE ───────────────────────────────────────────────────
  tabPanel("pk_info",
           div(class = "container mt-4",
               # Hero Section
               div(class = "info-hero pk",
                   h1("🚶"),
                   h2("Parkinson's Disease"),
                   p("Nearly 1 million Americans live with Parkinson's, a progressive disorder affecting movement, balance, and coordination. Caused by loss of dopamine-producing neurons in the brain."),
                   actionButton("go_pk_calc", "Assess Your Risk →", class = "cta-button")
               ),
               
               div(class = "row",
                   div(class = "col-md-8",
                       # Statistics
                       div(class = "info-section",
                           h3("📊 Key Statistics"),
                           div(class = "row",
                               div(class = "col-md-6",
                                   div(class = "stat-box",
                                       h4("~1M"),
                                       p("Americans living with Parkinson's")
                                   )
                               ),
                               div(class = "col-md-6",
                                   div(class = "stat-box",
                                       h4("60,000"),
                                       p("New diagnoses each year in the U.S.")
                                   )
                               )
                           ),
                           p("Men are 1.5x more likely to develop Parkinson's than women. Average onset age is 60, but 10% are diagnosed before age 50 (young-onset Parkinson's).")
                       ),
                       
                       # What We Assess
                       div(class = "info-section",
                           h3("🔍 What Our Calculator Assesses"),
                           p("Our Parkinson's calculator evaluates motor symptoms, cognitive function, and key risk factors:"),
                           
                           div(class = "risk-factor-grid",
                               div(class = "risk-factor-card",
                                   div(class = "icon", "📊"),
                                   div(class = "label", "UPDRS Score")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🤝"),
                                   div(class = "label", "Tremor")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🥶"),
                                   div(class = "label", "Rigidity")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🐌"),
                                   div(class = "label", "Bradykinesia")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "⚖️"),
                                   div(class = "label", "Balance Issues")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🧠"),
                                   div(class = "label", "MoCA Cognitive Test")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "😴"),
                                   div(class = "label", "Sleep Disorders")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🤕"),
                                   div(class = "label", "Brain Injury History")
                               )
                           )
                       ),
                       
                       # Understanding Risk
                       div(class = "info-section",
                           h3("⚡ Understanding Your Risk"),
                           p(tags$b("Classic Triad:"), " Tremor (shaking), Rigidity (stiffness), and Bradykinesia (slowness) are hallmark motor symptoms caused by dopamine loss."),
                           p(tags$b("UPDRS Score:"), " Unified Parkinson's Disease Rating Scale (0-200) comprehensively assesses motor and non-motor symptoms. Higher scores indicate greater disability."),
                           p(tags$b("Sleep Disorders:"), " REM sleep behavior disorder can appear years before motor symptoms and is a strong early predictor of Parkinson's."),
                           tags$div(style="background:#fff3cd; border-left:4px solid #ffc107; padding:12px; border-radius:4px; margin-top:15px;",
                                    tags$b("Important:"), " There's no cure, but early diagnosis enables treatment to manage symptoms and slow progression."
                           )
                       )
                   ),
                   
                   div(class = "col-md-4",
                       # Quick Facts
                       div(class = "info-section",
                           h3("💡 Quick Facts"),
                           tags$ul(style="color:#555; font-size:14px; line-height:1.8;",
                                   tags$li("Parkinson's is the 2nd most common neurological disorder"),
                                   tags$li("Symptoms appear when 80% of dopamine neurons are lost"),
                                   tags$li("Actor Michael J. Fox diagnosed at age 29"),
                                   tags$li("Not fatal itself, but complications can be serious"),
                                   tags$li("Deep brain stimulation can help severe cases")
                           )
                       ),
                       
                       # Warning Signs
                       div(class = "info-section",
                           h3("⚠️ Warning Signs"),
                           tags$ul(style="color:#555; font-size:14px; line-height:1.8;",
                                   tags$li("Tremor in hands, arms, legs, or jaw"),
                                   tags$li("Muscle stiffness or rigidity"),
                                   tags$li("Slowed movement (bradykinesia)"),
                                   tags$li("Impaired balance and posture"),
                                   tags$li("Small, cramped handwriting"),
                                   tags$li("Loss of smell, sleep issues, constipation")
                           )
                       )
                   )
               ),
               
               # CTA Bottom
               div(style="text-align:center; margin:40px 0;",
                   actionButton("go_pk_calc2", "Start Parkinson's Assessment →", class = "btn btn-warning btn-lg", style="padding:15px 50px; font-size:18px;")
               )
           )
  ),
  
  # ── DIABETES INFO PAGE ──────────────────────────────────────────────────────
  tabPanel("db_info",
           div(class = "container mt-4",
               # Hero Section
               div(class = "info-hero db",
                   h1("💉"),
                   h2("Type 2 Diabetes"),
                   p("38 million Americans have diabetes (11.6% of the population), with 90-95% having type 2. High blood sugar damages blood vessels, nerves, and organs throughout the body."),
                   actionButton("go_db_calc", "Assess Your Risk →", class = "cta-button")
               ),
               
               div(class = "row",
                   div(class = "col-md-8",
                       # Statistics
                       div(class = "info-section",
                           h3("📊 Key Statistics"),
                           div(class = "row",
                               div(class = "col-md-6",
                                   div(class = "stat-box",
                                       h4("38M"),
                                       p("Americans have diabetes (1 in 10)")
                                   )
                               ),
                               div(class = "col-md-6",
                                   div(class = "stat-box",
                                       h4("97.6M"),
                                       p("Adults have prediabetes (1 in 3)")
                                   )
                               )
                           ),
                           p("Diabetes is the 8th leading cause of death and the #1 cause of kidney failure, lower-limb amputations, and adult blindness in the U.S.")
                       ),
                       
                       # What We Assess
                       div(class = "info-section",
                           h3("🔍 What Our Calculator Assesses"),
                           p("Our diabetes calculator combines blood glucose measurements with classic symptoms:"),
                           
                           div(class = "risk-factor-grid",
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🩸"),
                                   div(class = "label", "Fasting Blood Sugar")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "📊"),
                                   div(class = "label", "HbA1c (3-mo avg)")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🚽"),
                                   div(class = "label", "Frequent Urination")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "💧"),
                                   div(class = "label", "Excessive Thirst")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "⚖️"),
                                   div(class = "label", "Weight Loss")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "👁️"),
                                   div(class = "label", "Blurred Vision")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🩺"),
                                   div(class = "label", "Hypertension")
                               ),
                               div(class = "risk-factor-card",
                                   div(class = "icon", "🚬"),
                                   div(class = "label", "Smoking Status")
                               )
                           )
                       ),
                       
                       # Understanding Risk
                       div(class = "info-section",
                           h3("⚡ Understanding Your Risk"),
                           p(tags$b("HbA1c:"), " Measures average blood sugar over 2-3 months. Normal: <5.7%. Prediabetes: 5.7-6.4%. Diabetes: ≥6.5%. Our model uses this key predictor."),
                           p(tags$b("Classic Triad:"), " Frequent urination, excessive thirst, and unexplained weight loss occur when blood sugar exceeds kidney filtering capacity (~180 mg/dL)."),
                           p(tags$b("Blurred Vision:"), " High blood sugar damages retinal blood vessels (diabetic retinopathy), a leading cause of blindness. Included as a highly significant predictor in our model."),
                           tags$div(style="background:#fff3cd; border-left:4px solid #ffc107; padding:12px; border-radius:4px; margin-top:15px;",
                                    tags$b("Important:"), " Type 2 diabetes is often reversible through weight loss, exercise, and diet changes—especially if caught early."
                           )
                       )
                   ),
                   
                   div(class = "col-md-4",
                       # Quick Facts
                       div(class = "info-section",
                           h3("💡 Quick Facts"),
                           tags$ul(style="color:#555; font-size:14px; line-height:1.8;",
                                   tags$li("90-95% of diabetes cases are type 2 (preventable)"),
                                   tags$li("Diabetes costs the U.S. $327 billion/year"),
                                   tags$li("38% of adults have prediabetes, most don't know it"),
                                   tags$li("Losing 5-7% body weight cuts risk by 58%"),
                                   tags$li("Diabetes doubles heart attack and stroke risk")
                           )
                       ),
                       
                       # Warning Signs
                       div(class = "info-section",
                           h3("⚠️ Warning Signs"),
                           tags$ul(style="color:#555; font-size:14px; line-height:1.8;",
                                   tags$li("Frequent urination, especially at night"),
                                   tags$li("Excessive thirst and hunger"),
                                   tags$li("Unexplained weight loss"),
                                   tags$li("Blurred vision"),
                                   tags$li("Slow-healing cuts or sores"),
                                   tags$li("Tingling or numbness in hands/feet")
                           )
                       )
                   )
               ),
               
               # CTA Bottom
               div(style="text-align:center; margin:40px 0;",
                   actionButton("go_db_calc2", "Start Diabetes Assessment →", class = "btn btn-danger btn-lg", style="padding:15px 50px; font-size:18px;")
               )
           )
  ),
  
  
  # ── ALZHEIMER'S CALCULATOR ──────────────────────────────────────────────────
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
                          selectInput("alz_edu",   "Education Level",
                                      choices = c("None" = 0, "High School" = 1, "Bachelor's" = 2, "Higher" = 3)),
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
  
  # ── CHRONIC KIDNEY DISEASE CALCULATOR ───────────────────────────────────────
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
                          selectInput("ckd_edema",       "Edema (Swelling)", choices = c("No" = 0, "Yes" = 1)),
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
  
  # ── PARKINSON'S CALCULATOR ──────────────────────────────────────────────────
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
                          selectInput("pk_sleepdisorders", "Sleep Disorder", choices = c("No" = 0, "Yes" = 1)),
                          selectInput("pk_traumaticbraininjury", "Traumatic Brain Injury", choices = c("No" = 0, "Yes" = 1)),
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
  
  # ── DIABETES CALCULATOR ─────────────────────────────────────────────────────
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
                          selectInput("db_blurred_vision", "Blurred Vision",        choices = c("No" = 0, "Yes" = 1)),
                          p(class = "section-label", "Medical History & Lifestyle"),
                          selectInput("db_hypertension", "Hypertension",            choices = c("No" = 0, "Yes" = 1)),
                          selectInput("db_smoking",      "Smoking",                 choices = c("No" = 0, "Yes" = 1)),
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
  
  # ── QUIZ ────────────────────────────────────────────────────────────────────
  tabPanel("Quiz",
           div(class = "container mt-4",
               h4(class = "tab-title", "🧠 Test Your Knowledge"),
               p("Challenge yourself with questions about chronic disease risk factors!", style = "color:#666;"),
               
               # Quiz intro card
               uiOutput("quiz_intro_ui"),
               
               # Quiz question card
               uiOutput("quiz_question_ui"),
               
               # Progress and score
               uiOutput("quiz_progress_ui"),
               
               # Final results
               uiOutput("quiz_results_ui")
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