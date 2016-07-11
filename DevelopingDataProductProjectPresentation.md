Developing Data Product Course Project Presentation
========================================================
author: Li Lu
date: 7/10/2016
autosize: true

Slide 1: Introduction of A Tool for Retrieving and Comparing two Pubmed Searches 
========================================================

For a live demonstration of R please visit <https://llu5.shinyapps.io/CourseProject/>.

- This data product project is a database tool for helping users of heatlh scientists and researchers to discover and compare the dynamic trend of number of puplications on two topics and given years in live database of Pubmed of NCBI on two topics that users .
- This tool allows users easily retrieve results of numbers from queries by using two search terms for each year and calculate ratios.
- This tool plot the trend for result of each search term and draw a line of linear gression for comparing the trend.
- This tool uses codes of RISmed   and yplot packages

Slide 2: The code for ui.R
========================================================


```r
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

      tabsetPanel(
        tabPanel("Plot1", plotOutput("plot1")), 
        tabPanel("Summary of Data", verbatimTextOutput("summary")), 
        tabPanel("Result and Documentation",  htmlOutput("oid3"),
        tabPanel("Documentation",  htmlOutput("documentation")
         )       
                 )
      )
      
      
)
)
  
)
```

<!--html_preserve--><div class="container-fluid">
<h2>Retrieving and Comparing Pubmed Search Results</h2>
<div class="col-sm-4">
<form class="well">
<div class="form-group shiny-input-container">
<label for="id1">Enter first search term:</label>
<input id="id1" type="text" class="form-control" value="cancer"/>
</div>
<div class="form-group shiny-input-container">
<label for="id2">Enter second search term:</label>
<input id="id2" type="text" class="form-control" value="heart disease"/>
</div>
<div class="form-group shiny-input-container">
<label class="control-label" for="id3">Select a filter of research type for above searches</label>
<div>
<select id="id3"><option value="" selected>all</option>
<option value="molecular">molecular</option>
<option value="cellular">cellular</option>
<option value="genomic">genomic</option>
<option value="genetics">genetics</option>
<option value="epidemiology">epidemiology</option>
<option value="diagnosis">diagnosis</option>
<option value="treatment">treatment</option>
<option value="therapy">therapy</option>
<option value="demography">demography</option>
<option value="control">control</option>
<option value="prevention">prevention</option></select>
<script type="application/json" data-for="id3">{}</script>
</div>
</div>
<div class="form-group shiny-input-container">
<label class="control-label" for="id4">Starting Year</label>
<div>
<select id="id4"><option value="2011" selected>2011</option>
<option value="2010">2010</option>
<option value="2009">2009</option>
<option value="2008">2008</option>
<option value="2007">2007</option>
<option value="2006">2006</option>
<option value="2005">2005</option>
<option value="2004">2004</option>
<option value="2003">2003</option>
<option value="2002">2002</option>
<option value="2001">2001</option>
<option value="2000">2000</option>
<option value="1999">1999</option></select>
<script type="application/json" data-for="id4" data-nonempty="">{}</script>
</div>
</div>
<div class="form-group shiny-input-container">
<label class="control-label" for="id5">Ending Year</label>
<div>
<select id="id5"><option value="2014" selected>2014</option>
<option value="2013">2013</option>
<option value="2012">2012</option>
<option value="2011">2011</option></select>
<script type="application/json" data-for="id5" data-nonempty="">{}</script>
</div>
</div>
<div>
<button type="submit" class="btn btn-primary">Submit</button>
</div>
</form>
</div>
<div class="col-sm-8">
<h3>Search of Pubmed with two terms and year of publication:</h3>
<div class="tabbable tabs-above">
<ul class="nav nav-tabs">
<li class="active">
<a href="#tab-1464-1" data-toggle="tab" data-value="Plot1">Plot1</a>
</li>
<li>
<a href="#tab-1464-2" data-toggle="tab" data-value="Summary of Data">Summary of Data</a>
</li>
<li>
<a href="#tab-1464-3" data-toggle="tab" data-value="Result and Documentation">Result and Documentation</a>
</li>
</ul>
<div class="tab-content">
<div class="tab-pane active" data-value="Plot1" id="tab-1464-1">
<div id="plot1" class="shiny-plot-output" style="width: 100% ; height: 400px"></div>
</div>
<div class="tab-pane" data-value="Summary of Data" id="tab-1464-2">
<pre id="summary" class="shiny-text-output"></pre>
</div>
<div class="tab-pane" data-value="Result and Documentation" id="tab-1464-3">
<div id="oid3" class="shiny-html-output"></div>
<div class="tab-pane" title="Documentation" data-value="Documentation">
<div id="documentation" class="shiny-html-output"></div>
</div>
</div>
</div>
</div>
</div>
</div><!--/html_preserve-->

Slide 3: The code for server.R
========================================================


```r
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
  
 
    
  })
```

Slide 4: A sample plot that can be reproduced Locally in R Presenter
========================================================

![plot of chunk unnamed-chunk-3](DevelopingDataProductProjectPresentation-figure/unnamed-chunk-3-1.png)

Slide 5: a Sample Data Summary  that can be reproduced Locally in R Presenter
========================================================


```
             TERM year number
1 "heart disease" 2011   5181
2 "heart disease" 2012   5483
3 "heart disease" 2013   6035
4 "heart disease" 2014   6606
5        "cancer" 2011  82976
6        "cancer" 2012  89032
7        "cancer" 2013  98388
8        "cancer" 2014 117491
```
