# if (require(devtools)) install.packages("devtools")
# devtools::install_github('andrewsali/shinycssloaders')
# devtools::install_github("AnalytixWare/ShinySky")
library(shiny)
library(shinycssloaders)
library(shinysky)

# Define UI
ui <- fluidPage(
  
  # App title
  titlePanel("miRNA .gff intersect"),
  
  # Sidebar layout
  sidebarLayout(
    
    # Sidebar panel
    sidebarPanel(
      


      checkboxInput("header1", "My file containes header", TRUE),
      

      radioButtons("sep1", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = "\t"),
      

      radioButtons("quote1", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = ""),
      

      fileInput("file1", "Choose miRNA File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      

      tags$hr(),
      

      checkboxInput("header2", "My file containes header", FALSE),
      

      radioButtons("sep2", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = "\t"),
      

      radioButtons("quote2", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = ""),
      
      fileInput("file2", "Choose gff File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv",
                           ".gff",
                           ".gff3")),

      
      tags$hr(),
      
        actionButton("goButton", "Generate!"),
        p("Click the button to generate the intersection table and check results in the output tab panel"),


      tags$hr()
      

      
      
    ),
    

    mainPanel(
      

      navbarPage('Tables',
      tabPanel(title = 'input',
               value = "1",
               br(),
               p(strong("Upload"), " files and ", strong("select columns"), " of interest, in order, containing: ", strong("chromosomes, start position, end position"), " and ", strong("orientation")),
               br(),
               DT::dataTableOutput('ex1'),
               verbatimTextOutput('y22'), # tableOutput("contents2")
               br(),      
               br(),
               DT::dataTableOutput('ex2'),
               verbatimTextOutput('y33')
               ),

      tabPanel(title = 'output',
               value = "2",
               br(),
               br(),
               conditionalPanel(
                 condition = "(output.goButton!=0)",
                 busyIndicator(text = "Loading, please wait...", wait = 400), 
                 DT::dataTableOutput('y44')), # %>% withSpinner(color="#A9F5F2", proxy.height = "50px"),
               br()
               ),
      
      id = "tabselected")
      
      
      
      
    )
    
  )
)


server <- function(input, output, session) {
  
  output$ex1 <- DT::renderDataTable({
    
    req(input$file1)
    
      tryCatch(
        {
          df1 <- read.csv(input$file1$datapath,
                         header = input$header1,
                         sep = input$sep1,
                         quote = input$quote1)
        },
        error = function(e) {
          # parsing error
          stop(safeError(e))
        }
      )
    
    DT::datatable(df1, options = list(pageLength = 6), selection = list(target = 'column', selected = c(1)))
    

  })
  

  output$y22 = renderPrint({
    if (!is.na(req(input$file1))[1]) {

      cat("Columns selected: ")
      input$ex1_columns_selected      
    }
  })
  

  
  output$ex2 <- DT::renderDataTable({
    
    req(input$file2)
    
    tryCatch(
      {
        df2 <- read.csv(input$file2$datapath,
                        header = input$header2,
                        sep = input$sep2,
                        quote = input$quote2)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    DT::datatable(df2, options = list(pageLength = 6), selection = list(target = 'column', selected = c(1)))
  })
  

  output$y33 = renderPrint({
    if (!is.na(req(input$file2))[1]) {
      cat("Columns selected: ")
      input$ex2_columns_selected      
    }
    })
  
  ntext <- eventReactive(input$goButton, {
    return(TRUE)
  })
  
  myoutput = reactive({
    if (!is.na(req(input$file2))[1] & (!is.na(req(input$file1))[1]) & ntext()) {
      
      tryCatch(
        {
          mygff <- read.csv(input$file2$datapath,
                          header = input$header2,
                          sep = input$sep2,
                          quote = input$quote2,
                          stringsAsFactors = FALSE)
        },
        error = function(e) {
          # return a safeError if a parsing error occurs
          stop(safeError(e))
        }
      )
      
      tryCatch(
        {
          mymiRNA <- read.csv(input$file1$datapath,
                          header = input$header1,
                          sep = input$sep1,
                          quote = input$quote1,
                          stringsAsFactors = FALSE)
        },
        error = function(e) {
          # return a safeError if a parsing error occurs
          stop(safeError(e))
        }
      )
      
      if ((length(input$ex1_columns_selected) == 4) & (length(input$ex2_columns_selected) == 4)) {
        
        s1 = input$ex1_columns_selected[2]
        e1 = input$ex1_columns_selected[3]
        s2 = input$ex2_columns_selected[2]
        e2 = input$ex2_columns_selected[3]
        o1 = mymiRNA[,input$ex1_columns_selected[4]]
        o2 = mygff[,input$ex2_columns_selected[4]]
        # orientation = c("+", "-", ".")
        orientation = c("+", "-")
        
        # cat("s1, e1, s2, e2, o1, o2: ", s1, e1, s2, e2, o1, o2, "\n")

        
        if ((all(s1 <= e1) & 
             all(s2 <= e2)) & 
            (!is.na(all(s1 == as.numeric(s1))) & 
             !is.na(all(s2 == as.numeric(s2))) & 
             !is.na(all(e1 == as.numeric(e1))) &
             !is.na(all(e2 == as.numeric(e2)))) &
            all(o1 %in% orientation) &
            all(o2 %in% orientation)) {
          

          ind1 = matrix(data = NA, nrow = 0, ncol = 2)
          ind2 = matrix(data = NA, nrow = 0, ncol = 2)
          ind3 = matrix(data = NA, nrow = 0, ncol = 2)
          
          
          colnames(mymiRNA)[input$ex1_columns_selected] = c("Chromosome",	"Start_position",	"End_position", "Orientation")
          colnames(mygff)[input$ex2_columns_selected] = c("Chr", "start", "stop", "strand")
          
          for (i in (1:nrow(mymiRNA))) {
            # miRNA wihin
            tmp = which((mymiRNA[i,]$Start_position >= mygff$start) & 
                          (mymiRNA[i,]$End_position <= mygff$stop))
            if (length(tmp)) {
              ind1 = rbind(ind1, cbind(i,tmp))
            }
            
            
            # miRNA left partial overlap
            tmp = which((mymiRNA[i,]$Start_position < mygff$start) & 
                          (mymiRNA[i,]$End_position <= mygff$stop) & 
                          (mymiRNA[i,]$End_position > mygff$start))
            if (length(tmp)) {
              ind2 = rbind(ind2, cbind(i,tmp))
            }
            
            # miRNA right partial overlap
            tmp = which((mymiRNA[i,]$Start_position >= mygff$start) & 
                          (mymiRNA[i,]$End_position > mygff$stop) & 
                          (mymiRNA[i,]$Start_position < mygff$stop))
            if (length(tmp)) {
              ind3 = rbind(ind3, cbind(i,tmp))
            }
            
            
          }
          
          ind1.1 = NULL
          ind2.1 = NULL
          ind3.1 = NULL
          
          if (length(ind1)) ind1.1 = cbind(mymiRNA[ind1[,1],], mygff[ind1[,2],], 'miRNA within')
          if (length(ind2)) ind2.1 = cbind(mymiRNA[ind2[,1],], mygff[ind2[,2],], 'miRNA left partial')
          if (length(ind3)) ind3.1 = cbind(mymiRNA[ind3[,1],], mygff[ind3[,2],], 'miRNA right partial')
          
          # on the same chr
          ind1.1 = ind1.1[ind1.1$Chromosome == ind1.1$Chr,]
          ind2.1 = ind2.1[ind2.1$Chromosome == ind2.1$Chr,]
          ind3.1 = ind3.1[ind3.1$Chromosome == ind3.1$Chr,]
          
          # same orientation
          ind1.1 = ind1.1[ind1.1$Orientation == ind1.1$strand,]
          ind2.1 = ind2.1[ind2.1$Orientation == ind2.1$strand,]
          ind3.1 = ind3.1[ind3.1$Orientation == ind3.1$strand,]
          
          if (length(ind1)) colnames(ind1.1)[ncol(ind1.1)] = 'match'
          if (length(ind2)) colnames(ind2.1)[ncol(ind2.1)] = 'match'
          if (length(ind3)) colnames(ind3.1)[ncol(ind3.1)] = 'match'
          
          indmiRNA = rbind(ind1.1, ind2.1, ind3.1)

          
          ind1 = matrix(data = NA, nrow = 0, ncol = 2)
          ind2 = matrix(data = NA, nrow = 0, ncol = 2)
          ind3 = matrix(data = NA, nrow = 0, ncol = 2)
          
          for (i in (1:nrow(mygff))) {
            # gff wihin miRNA
            tmp = which((mygff[i,]$start > mymiRNA$Start_position) & # 2019-07-17 >= to > and <= to <
                          (mygff[i,]$stop < mymiRNA$End_position))
            if (length(tmp)) {
              ind1 = rbind(ind1, cbind(i,tmp))
            }
            
            
            # gff left partial overlap
            tmp = which((mygff[i,]$start < mymiRNA$Start_position) & 
                          (mygff[i,]$stop <= mymiRNA$End_position) & 
                          (mygff[i,]$stop > mymiRNA$Start_position))
            if (length(tmp)) {
              ind2 = rbind(ind2, cbind(i,tmp))
            }
            
            # gff right partial overlap
            tmp = which((mygff[i,]$start >= mymiRNA$Start_position) & 
                          (mygff[i,]$stop > mymiRNA$End_position) & 
                          (mygff[i,]$start < mymiRNA$End_position))
            if (length(tmp)) {
              ind3 = rbind(ind3, cbind(i,tmp))
            }
            
            
          }
          
          ind1.1 = NULL
          ind2.1 = NULL
          ind3.1 = NULL
          
          if (length(ind1)) ind1.1 = cbind(mymiRNA[ind1[,2],], mygff[ind1[,1],], 'gff within')
          if (length(ind2)) ind2.1 = cbind(mymiRNA[ind2[,2],], mygff[ind2[,1],], 'gff left partial')
          if (length(ind3)) ind3.1 = cbind(mymiRNA[ind3[,2],], mygff[ind3[,1],], 'gff right partial')
          
          ind1.1 = ind1.1[ind1.1$Chromosome == ind1.1$Chr,]
          ind2.1 = ind2.1[ind2.1$Chromosome == ind2.1$Chr,]
          ind3.1 = ind3.1[ind3.1$Chromosome == ind3.1$Chr,]

          ind1.1 = ind1.1[ind1.1$Orientation == ind1.1$strand,]
          ind2.1 = ind2.1[ind2.1$Orientation == ind2.1$strand,]
          ind3.1 = ind3.1[ind3.1$Orientation == ind3.1$strand,]

          if (length(ind1)) colnames(ind1.1)[ncol(ind1.1)] = 'match'
          if (length(ind2)) colnames(ind2.1)[ncol(ind2.1)] = 'match'
          if (length(ind3)) colnames(ind3.1)[ncol(ind3.1)] = 'match'
          
          indgff = ind1.1

          
          ind = rbind(indmiRNA, indgff)

          
          # sort ind by coordinates
          ind = ind[with(ind, order(Start_position, End_position)), ]
          
          # print duplicated rows
          ind[duplicated(ind),]
          
          # print("made")
          # print(head(ind))
          

          
          return(ind)
        }
        
      }
    }
  })
  

  
  output$y44 <- DT::renderDataTable(DT::datatable({myoutput()},
                                    extensions = 'Buttons',
                                    options = list(dom = 'Bfrtip',
                                                   pageLength = 10,
                                                   buttons = c('copy', 
                                                               'csv', 
                                                               'excel', 
                                                               'pdf', 
                                                               'print')), rownames = FALSE
                                    ), server = FALSE
  )
  
  # jump to output
  observe({
    if( (!is.na(req(input$file2))[1]) & (!is.na(req(input$file1))[1]) & ntext() & (!is.null(myoutput()))){
      updateNavbarPage(session, inputId = 'tabselected', selected = "2")
    }
  })
  
  # observeEvent(input$goButton, {
  #   withBusyIndicatorServer("goButton", {
  #     Sys.sleep(1)
  #     # (validate(need(exists(myoutput()),message="output not found")))
  #     #   stop("provide appropriate columns")
  #     
  #   })
  # })
  
}

# Shiny app
shinyApp(ui, server)
