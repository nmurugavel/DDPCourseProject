# load required packages
library(shiny)
library(ggplot2)

# data set for analysis
data(ToothGrowth)

# shiny server function
shinyServer(
    function(input, output) {
        
        # selected supplement type
        output$supp <- renderText({input$supp})
        
        # selected dose
        output$dose <- renderText(
            if(is.null(input$dose))
                "ALL"
            else
                {input$dose}
            )
        
        # subset data based on selections
        # supplement type:
        #       ALL - include all records
        #       other - include only those records
        # dose:
        #       none - include all records
        #       one or more values - include only those records
        datasetInput <- reactive(
            # ALL supplement type is selected
            if({input$supp} == "ALL") {
                # dose is not selected
                if(is.null({input$dose})) {
                    ToothGrowth
                }
                # one or more doses are selected
                else {
                    ToothGrowth[ToothGrowth$dose %in% as.numeric({input$dose}), ]
                }
            }
            # a particular supplement type is selected
            else {
                # dose is not selected
                if(is.null({input$dose})) {
                    ToothGrowth[ToothGrowth$supp == {input$supp}, ]
                }
                # one or more doses are selected
                else {
                    ToothGrowth[ToothGrowth$supp == {input$supp} & ToothGrowth$dose %in% as.numeric({input$dose}), ]
                }
            }
        )

        # calculate the mean and s.d. for supplement type and dose
        output$mean <- renderTable({
            data1 <- datasetInput()
            a <- cbind(aggregate(data1[, 1], list(data1$supp, data1$dose), mean), aggregate(data1[, 1], list(data1$supp, data1$dose), sd))
            a <- a[, c(1:3, 6)]
            colnames(a) <- c("supp", "dose", "len_mean", "len_sd")
            a
        })

        # make a boxplot
        output$g <- renderPlot({
            data <- datasetInput()
            g <- ggplot(data, aes(x = dose, y = len))
            g <- g + geom_boxplot(aes(group = dose))
            g <- g + facet_grid(. ~ supp)
            g <- g + ggtitle("Growth for dosage / supplement type") + xlab("Dose") + ylab("Tooth Length")
            g
        })
    }
)
