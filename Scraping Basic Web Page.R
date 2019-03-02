course_url = "https://www.sfu.ca/outlines.html?2017/spring/stat/240/e100"
course_page = readLines(course_url)

# <h1>, <h2>, ...: Largest heading, second largest heading, etc.
# <p>: Paragraph elements
# <ul>: Unordered bulleted list
# <ol>: Ordered list
# <li>: Individual list item
# <div>: Division or section
# <table>: Table

index = grep("<h1 id=\"name\">", course_page, ignore.case = TRUE)
# Then strip out the html junk and extra white space
(title = course_page[index])
## [1] " <h1 id=\"name\">Spring 2017 - STAT 240 <span>E100</span></h1>"
(number1 = gsub("<[^<>]+>", " ", title))
## [1] " Spring 2017 - STAT 240 E100 "
# remove the semester and year (before the '-')
(step1 = gsub(".*\\-", "", number1))
## [1] " STAT 240 E100 "
# remove the section
(step2 = gsub("[[:alpha:]]+[[:digit:]]{3}", "", step1))
## [1] " STAT 240 "
# Then fix it so that you just get Stat 240 as your output
(CourseNumber = gsub("^\\s+|\\s+$", "", step2))
## [1] "STAT 240"

#Scraping tables
library(XML)
movie_url = "http://www.imdb.com/chart/boxoffice"
movie_table = readHTMLTable(movie_url)
