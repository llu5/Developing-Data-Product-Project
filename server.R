#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

if (!require(RISmed)){ 
  install.packages("RISmed") 
} 

if (!require(ggplot2)){ 
  install.packages("ggplot2") 
} 
if (!require(slam)){ 
  install.packages("slam") 
}

if (!require(devtools)){ 
  install.packages("devtools")
}
# if (!require(yplot)){ 
# install_github("GuangchuangYu/yplots")
# }

if (!require(wordcloud)){ 
  install.packages("wordcloud") 
}
if (!require(RColorBrewer)){ 
  install.packages("RColorBrewer") 
}
if (!require(plyr)){ 
  install.packages("plyr") 
}
library(RISmed)
library(ggplot2)
library(slam)
library(devtools)
library(RColorBrewer)
library(wordcloud)
library(plyr)
# library(yplot)

#tally each year beginning at 1970
#In order not to overload the E-utility servers, NCBI recommends that users post no more than three
#URL requests per second and limit large jobs to either weekends or between 9:00 PM and 5:00 AM
#Eastern time during weekdays. Failure to comply with this policy may result in an IP address being
#blocked from accessing NCBI.



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # get total number of two serch results: done
  # res <- EUtilsSummary(input$id1+" + "+input$id3, type="esearch", db="pubmed", datetype='pdat', mindate=input$id4, maxdate=input$id5, retmax=50000)
  # qc<-QueryCount(res)
  # get the ratio of total number of two search results done
  
  
  # plot the trends of total number of pubmed results per year for each search in single plot with double Y axis  and lines of different color. Done.
  
  # build and plot the linear model from total of pubmed results per year for each of the results

  output$oid1 = renderPrint({QueryCount(EUtilsSummary(paste(input$id1," AND ",input$id3), type="esearch", db="pubmed", datetype='pdat', mindate=input$id4, maxdate=input$id5, retmax=50000))})
  output$oid2 = renderPrint({QueryCount(EUtilsSummary(paste(input$id2," AND ",input$id3), type="esearch", db="pubmed", datetype='pdat', mindate=input$id4, maxdate=input$id5, retmax=50000))})
  output$oid3 = renderUI({
       q1total<- QueryCount(EUtilsSummary(paste(input$id1," AND ",input$id3), type="esearch", db="pubmed", datetype='pdat', mindate=input$id4, maxdate=input$id5, retmax=50000))
       q2total<- QueryCount(EUtilsSummary(paste(input$id2," AND ",input$id3), type="esearch", db="pubmed", datetype='pdat', mindate=input$id4, maxdate=input$id5, retmax=50000))
       ratioq1toq2<-q1total/q2total
       HTML(paste("<H2>Results</H2></br>Total number for publications on ", input$id3 ," research of ", input$id1, " is <b>", q1total, "</b>, and the total number of publications on ", input$id3 ," research of ",input$id2, " is <b>",q2total , "</b>.
                  </br> The ratio of total publications in Pubmed on ", input$id3, " research of ", input$id1," to ", input$id2 , " between ", input$id4, " and ", input$id5, " is: <b>", round(ratioq1toq2, digits = 3) ,"</b>",sep = ' '))
       })
  output$plot1 <- renderPlot({
    validate(
      need(input$id1 != "", "Please enter a valid search term.")
    )
    validate(
      need(input$id2 != "", "Please enter a valid search term.")
    )
    
    input$newplot

    getPubmedTrend.internal <- function(searchTerm, year) {
      withProgress(message = 'Making plot', value = 0, {
        # Number of times we'll go through the loop
        n <- as.numeric(input$id5)-as.numeric(input$id4)
        
      num <- array()
      
      x <- 1
      
      for (i in year){
        
        Sys.sleep(1)
        
        cat("querying year ", i, "\n")
        
        r <- EUtilsSummary(searchTerm, type='esearch', db='pubmed', mindate=i, maxdate=i)
        
        num[x] <- QueryCount(r)
        # Increment the progress bar, and update the detail text.
        incProgress(1/n, detail = paste("Doing part", i))
        
        
        x <- x + 1
        
      }
      
      })
      res <- data.frame(year=year, number=num)
      
      return(res)
      
    }
    getPubmedTrend <- function(searchTerm, year) {
      
      if (length(searchTerm) == 1)
        
        return(getPubmedTrend.internal(searchTerm, year))
      
      res <- lapply(searchTerm, getPubmedTrend.internal, year=year)
      
      names(res) <- searchTerm
      
      res.df <- ldply(res)
      
      colnames(res.df)[1] <- "TERM"
      
      return(res.df)
      
    }

    plotPubmedTrend <- function(x) {
      
      year <- number <- TERM <- NULL
      
      ## if (is(x, "list")) {
      
      ##     df <- ldply(x)
      
      ##     colnames(df)[1] <- "TERM"
      
      if (ncol(x) == 3 && "TERM" %in% colnames(x)) {
        
        p <- ggplot(x, aes(factor(year), number, group=TERM, color=TERM))+
          
          geom_point(size=3) + geom_line()+geom_smooth(method="lm")
        
      } else {
        
        p <- ggplot(x, aes(year, number))+geom_point(size=3) + geom_line()+geom_smooth(method="lm")
        
      }
      
      return(p)
      
    }
    ifall<-if(input$id3 !="") " AND " else "";
    term = c(paste(input$id1, ifall,input$id3), paste(input$id2, ifall,input$id3))
    pm=getPubmedTrend(term, year=as.numeric(input$id4):input$id5)
    plotPubmedTrend(pm)
    
    
 
    
  })

  # Generate a summary of the data

  output$summary <- renderPrint({
    ifall<-if(input$id3 !="") " AND " else "";
    term = c(paste(input$id1, ifall,input$id3), paste(input$id2, ifall,input$id3))
    pm=getPubmedTrend(term, year=as.numeric(input$id4):input$id5)
    summary(pm)
  })
  
  # Generate a supproting documentation
  
  output$documentation <- renderUI({
       HTML("<H2>Supporting Documentation</H2><br>
   <b>Introduction of Comparing two Pubmed search results</b></br>
      Pubmed is NCBI database for public to search  information of publications on research in  biomedical and health related topics. It is a database for analysis of meta data of wide area of reserch topics.
    It is very important for researchers to discover trends of research topics by comparing two different topics with search terms in a given period of time. 
    There are many steps of retrieving, processing and plotting the data. Therefore, a web tool allows public users to easily complete the tasks and the result of analysis of this tool may facilitate their decision making.
    Recently, a RISmed package in R is available. This package helps this task by calling EUtils services, download dataset and perform analysis of the meta data and plot the result in R shiny application.
    In this course project, I have developed an application for users to create two customized queries, download data, compare the number of results of total number of two search result in a given period of years, calculate the ratio of total numbers of the two searches and create a plot with total number per year for each of the two queries, with linear model fit to see the trends of two searches. The plot help visualize the  total number of these two search term and discover the trends and their difference.</br>
    
    <b>Get started to use the tool </b></br>
    There are two text boxes for two separate search terms from which the search will be compared. The default value for first term is heart disease, the default value of the second search term is cancer. You can simply replace these search term by entering your own favorite search terms. 
    Next to the two textboxes, there is a select input of filter, a predefined search term of research types. Default is all research type. you can refine the search by selecting a particular research type and compare the difference of the results.  For example select prevention, only publications of two searches with term prevention and the first or second search term will be returned. Then you can try to change it to other values of your interest.
    In addition, there are two select input box for starting year and ending year of the publication. Users can select any given values to visualize the results in the any period of years as user defined.
    There is a Submit button at the bottom of left side panel. User can change the values and redo the search.
    After waiting for up to 30 seconds, the result will be displayed.
    There are three tabs in the main panel. The plot tab displays a line chart for two search result in given time period.
    Before plot is completed, a progress bar is displayed to notify user that the data is being processed.
    The Summary tab display year of search results and a summary of all data used for the plot.
    The third tab is Total numbers and Ratio. It describe the results of total numbers and calculatied ratio of total numbers of the two searches.")
  })
})
