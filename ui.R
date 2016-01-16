# load required packages
library(shiny)

# shiny ui function
shinyUI(fluidPage(

    # set the application title    
    titlePanel("Tooth Growth Analysis"),
    
    sidebarLayout(
        # side bar to accept inputs from user and display the instructions for using the app
        sidebarPanel(
            
            # select supplement type
            # default is ALL
            selectInput("supp", "Supplement type : ", 
                choices = c("Orange Juice" = "OJ", "Vitamin C" = "VC", "ALL" = "ALL"),
                selected = "ALL"
                    ),
            
            # select doses
            # if none are selected then all doses are included in the analysis
            checkboxGroupInput("dose", "Dose (mg/day) :",
                c("0.5", "1.0", "2.0")
            ),
            
            # process only on clicking the button
            submitButton("Analyse"),
            
            # instructions to use the app
            strong("Instructions : "),
            helpText("This application uses the ToothGrowth dataset. It calculates the mean and s.d. for the record groups selected, and displays a boxplot also."),
            helpText("Inputs :"),
            helpText("(1) Supplement type - select one type or ALL"),
            helpText("(2) Dose - select doses to analyse (if none are selected then all doses are included)"),
            helpText("(3) click on Analyse button to process"),
            helpText("Outputs :"),
            helpText("(1) selected supplement types and doses"),
            helpText("(2) table with mean (len_mean) and s.d. (len_sd) of tooth length"),
            helpText("(3) boxplot of tooth length.")
        ),
        
        # main panel displays the output values
        mainPanel(
            # display supplement types used
            strong("Supplement type : "),
            textOutput('supp'),
            h3(),
            
            # display dose used
            strong("Dose : "),
            textOutput('dose'),
            h3(),
            
            # display mean and s.d. table
            strong("Mean and Standard Deviation : "),
            tableOutput('mean'),
            h3(),
            
            # plot the boxplot
            strong("Boxplot : "),
            plotOutput('g')
        )
    )
))
