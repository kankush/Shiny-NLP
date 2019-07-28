#Kavya Ankush-11915080
#Madhuri Chinta - 11915055
#Siddartha Tallapragada- 11915026


Ui<-shinyUI( 
  fluidPage(
    titlePanel("NLP"),
    sidebarLayout(
      sidebarPanel(
        fileInput("new", "text file here"),
        checkboxGroupInput("check", label = h3("Upos selection"), choices = list("Adjective" = "ADJ", "Noun" = "NOUN" , "Proper Noun" = "PROPN", "Adverb" = "ADV", "Verb" = "VERB"), selected = c('ADJ', 'NOUN', 'PROPN'))),

      mainPanel(tabsetPanel(type = "tabs",
                tabPanel("Description", br(), 
                         p('This app performs standard NLP functionalities on the text file.', align="justify"),
                         br(),
                         p("Standard NLP is performed on the text file using udpipe in R and the document is displayed in the annotataed document tab.", align="justify"),
                         p("Two wordclouds will be displayed in the next tab with all the frequently used nous and  frquently used verbs."),
                         p("The last tab displays top-30 co-occurences."),
                         br(),
                h3(p('To Use this App')),
                p("Click on browse button in 'text file here' field and upload a text file.", align="justify")),
                tabPanel("Annotated document",dataTableOutput('table'),
                         downloadButton("downloadfile", "Download Annotated Data")),
                tabPanel("Wordclouds", h2("NounCloud"),
                         plotOutput('Nouns', height = 300, width = 300),
                         h2("VerbCloud"),
                         plotOutput('Verbs', height = 300, width = 300)),
                tabPanel("Co-occurences",plotOutput('coplot'))
                )
      )
  )
))