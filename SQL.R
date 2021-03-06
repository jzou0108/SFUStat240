#Creating a Database Connection

library(RSQLite)
library(DBI)

source("Run_this_week3_lab.R")
dbcon = dbConnect(SQLite(), dbname = "stat240Week3lab.sqlite")

dbListTables(dbcon)
## [1] "CA" "POP" "Pokem"

names(dbReadTable(dbcon, "CA"))
## [1] "ID" "Country"
## [3] "Geographic_name" "Region"
## [5] "Province" "Prov_acr"
## [7] "Latitude" "Longitude"
## [9] "Region_Index"

dbcon = dbConnect(SQLite(), dbname = "stat240Week3lab.sqlite")
head(dbReadTable(dbcon, "CA"))
tail(dbReadTable(dbcon, "POP"))

#SQL Queries
sql_qry = "SELECT * FROM CA WHERE Latitude>55"
dbGetQuery(dbcon, sql_qry)

sql_qry = "SELECT * FROM CA WHERE Latitude>55 AND Longitude<-125"
dbGetQuery(dbcon, sql_qry)

q2_sql = "SELECT Geographic_name, Population__2011 FROM POP WHERE
Population__2011>100000"
dbGetQuery(dbcon, q2_sql)

#SQL Queries for Merging and Extracting Information
#"SELECT * FROM A INNER JOIN B ON A.X=B.X"
sql_join1 = "SELECT * FROM CA INNER JOIN POP ON CA.Geographic_name=POP.Geographic_name"
join1 = dbGetQuery(dbcon, sql_join1)

sql_qry2 = "SELECT * FROM CA INNER JOIN POP ON CA.Geographic_name=POP.Geographic_name WHERE Total_private_dwellings__2011==0"
(join_eg = dbGetQuery(dbcon, sql_qry2))

sql_join2 = "SELECT Region,CA.Geographic_name,Population__2011 FROM CA INNER JOIN POP ON CA.Geographic_name=POP.Geographic_name
WHERE Population__2011>100000"
(join2 = dbGetQuery(dbcon, sql_join2))

#Joining and Mapping
library(sp)
library(rworldmap)
library(rworldxtra)

worldmap = getMap(resolution = "high")
dim(worldmap)
NrthAm = worldmap[which(worldmap$REGION == "North America"), ]
plot(NrthAm, col = "white", bg = "lightblue", xlim = c(-140, -55), ylim = c(55, 60))
sql_join3 = "SELECT * FROM CA INNER JOIN POP ON CA.Geographic_name=POP.Geographic_name WHERE Population__2011<01234"
join3 = dbGetQuery(dbcon, sql_join3)
points(x = join3$Longitude, y = join3$Latitude, col = "red", pch = 16)

#SQL Queries for Extracting Information with Text
dbGetQuery(dbcon, "SELECT * FROM POP WHERE Geographic_name LIKE 'V5%' ")  ## the % symbol allows any other text to appear after V5
dbGetQuery(dbcon, "SELECT Region FROM CA WHERE Region LIKE '%da%' ")

#Disconnecting
dbDisconnect(dbcon)