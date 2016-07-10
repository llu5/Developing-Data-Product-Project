#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)



# Define UI for application that draws a line chart.
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Retrieving and Comparing Pubmed Search Results" ),
  
  # Sidebar with a slider input for number of bins 
  sidebarPanel(
    
    textInput("id1", "Enter first search term:", "cancer"),

    textInput("id2", "Enter second search term:", "heart disease"),
    selectInput("id3", "Select a filter of research type for above searches",
                c("all" = "",
                  "molecular" = "molecular",
                  "cellular" = "cellular",
                  "genomic" = "genomic",
                  "genetics" = "genetics",
                  "epidemiology" = "epidemiology",
                  "diagnosis" = "diagnosis",
                  "treatment" = "treatment",
                  "therapy" = "therapy",
                  "demography" = "demography",
                  "control" = "control",
                  "prevention" = "prevention")),
    selectInput("id4", "Starting Year",
                       c("2011" = "2011",
                         "2010" = "2010",
                         "2009" = "2009",
                         "2008" = "2008",
                         "2007" = "2007",
                         "2006" = "2006",
                         "2005" = "2005",
                         "2004" = "2004",
                         "2003" = "2003",
                         "2002" = "2002",
                         "2001" = "2001",
                         "2000" = "2000",
                         "1999" = "1999")),
    selectInput("id5", "Ending Year",
                       c(
                         "2014" = "2014",
                         "2013" = "2013",
                         "2012" = "2012",
                         "2011" = "2011")),

    submitButton('Submit')
    
  ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3('Search of Pubmed with two terms and year of publication:'),
     
      h4('Ratio of total numbers of results'),
     
 
 

      tabsetPanel(
        tabPanel("Plot", plotOutput("plot1")), 
        tabPanel("Summary", verbatimTextOutput("summary")), 
        tabPanel("Result and Documentation",  htmlOutput("oid3"),
        tabPanel("Suporting Documentation", htmlOutput("documentation") )       
                 )
      )
      
      
)
)
  
)
