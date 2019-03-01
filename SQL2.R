library(RSQLite)
library(DBI)
con = dbConnect(SQLite(), dbname = "stat240Week4lab.sqlite")
dbListTables(con)

#use PRAGMA to get some table info, PRAGMA is speciﬁc to SQLite.
query_table_info = "PRAGMA table_info('Olymp_meds')"
dbGetQuery(con, query_table_info)
## cid name type notnull dflt_value pk
## 1 0 City TEXT 0 NA 0
## 2 1 Edition INTEGER 0 NA 0
## 3 2 Sport TEXT 0 NA 0
## 4 3 Discipline TEXT 0 NA 0
## 5 4 Athlete TEXT 0 NA 0
## 6 5 NOC TEXT 0 NA 0
## 7 6 Gender TEXT 0 NA 0
## 8 7 Event TEXT 0 NA 0
## 9 8 Event_gender TEXT 0 NA 0
## 10 9 Medal TEXT 0 NA 0

# The DISTINCT keyword return only distinct/unique values from a SQL database.
sql_dstc = "SELECT DISTINCT Edition FROM Olymp_meds"

# SQL Query Order By
sql_ord = "SELECT DISTINCT Edition,City FROM Olymp_meds ORDER BY City DESC"
dbGetQuery(con, sql_ord)

sql_srtage_nm = "SELECT DISTINCT NOC FROM Olymp_meds WHERE Athlete LIKE 'y%' ORDER BY NOC"
dbGetQuery(con, sql_srtage_nm)

#dbSendQuery and dbFetch
sql_pop = "SELECT Population__2011, Province FROM CA INNER JOIN
POP ON CA.Geographic_name=POP.Geographic_name WHERE
province == 'Saskatchewan'"

QuerryOut = dbSendQuery(con, sql_pop) # QuerryOut describes results but doesn’t actually give results
dbFetch(QuerryOut, 5) # gives 5 results
dbFetch(QuerryOut, 5) #runing again gives 5 more results
deFetch(QuerryOut, -1) #get all remaining rows set the number to -1

dbClearResult(QuerryOut) #clean up

sql_srtage_nm = "SELECT Discipline,Athlete,Edition, NOC FROM Olymp_meds
WHERE NOC == 'SUD' OR NOC == 'LIB' OR NOC == 'SYR' OR NOC == 'IRI'
OR NOC == 'IRQ' ORDER BY Discipline"
athls_names = dbSendQuery(con, sql_srtage_nm)
dbFetch(athls_names, 5)

#SQL Query INSERT INTO
sql_ins = "INSERT INTO CA
( Country, Geographic_name, Region, Province, Prov_acr, Latitude, Longitude)
VALUES ( 'CA', 'V5A','Statsville', 'British Columbia', 'BC', '49.278417', '-122.916454'),
( 'CA', 'V5A','Statsville240', 'British Columbia', 'BC', '49.278417', '-122.916454')"
dbSendQuery(con, sql_ins)

sql_ins3 = "SELECT * FROM CA WHERE Region LIKE 'Statsville%'"
dbGetQuery(con, sql_ins3)

sql_ins2 = "INSERT INTO Olymp_meds
(City, Edition, Sport, Discipline, Athlete, NOC, Gender, Event, Event_gender, Medal)
VALUES ('London', '2012', 'Aquatics', 'Swimming', 'PHELPS, Michael', 'USA','Men', '200 m medley','M','Gold'),
('London', '2012', 'Aquatics', 'Swimming','PHELPS, Michael', 'USA', 'Men', '100 m butterfly','M','Gold'),
('London', '2012', 'Aquatics', 'Swimming','PHELPS, Michael', 'USA', 'Men', '200 m medley','M','Gold'),
('London', '2012', 'Aquatics', 'Swimming','PHELPS, Michael', 'USA', 'Men', '4200 m freestyle','M','Gold'),
('London', '2012', 'Aquatics', 'Swimming','PHELPS, Michael', 'USA', 'Men', '4100 m medley','M','Gold'),
('London', '2012', 'Aquatics', 'Swimming','PHELPS, Michael', 'USA', 'Men', '200 m butterfly','M','Silver'),
('London', '2012', 'Aquatics', 'Swimming','PHELPS, Michael', 'USA', 'Men', '4100 m freestyle','M','Silver')"
dbGetQuery(con, sql_ins2)

sql_ins3 = "SELECT * FROM Olymp_meds WHERE Athlete LIKE 'PHELPS%'"
dbGetQuery(con, sql_ins3)

#SQL Query DELETE
sql_del = "DELETE FROM CA WHERE Region =='Statsville'"
dbGetQuery(con, sql_del)

sql_del2 = "DELETE FROM Olymp_meds WHERE Edition=='1952' AND Athlete =='CAMPBELL, Dave'"
dbGetQuery(con, sql_del2)

#SQL Functions
#• GROUP BY: The GROUP BY statement is used in conjunction with the aggregate functions to group the result-set by one or more columns.
#• COUNT: The count function returns the number of rows that matches a speciﬁed criteria.
#• SUM: The SUM function returns the total sum of a numeric column.
#• HAVING: The HAVING clause was added to SQL because the WHERE keyword could not be used with aggregate functions, treat HAVING in a aggregation querry as you would WHERE in a SELECT query.

sql_count = "SELECT Edition, Count(Edition) AS TotalNumber FROM Olymp_meds"
(count = dbGetQuery(con, sql_count))
## Edition TotalNumber
## 1 1948 29225

sql_sum = "SELECT Sport, City,Edition,count(Sport) AS Tots FROM Olymp_meds
GROUP BY Sport, Edition HAVING Edition>=2000"
sum = dbGetQuery(con, sql_sum)
sum
## Sport City Edition Tots
## 1 Aquatics Sydney 2000 329
## 2 Aquatics Athens 2004 332

sql_dens = "SELECT Age, COUNT(Age) AS Counted FROM USA_MEDALS GROUP BY AGE HAVING AGE>19 AND AGE < 30"
dbGetQuery(con, sql_dens)
## Age Counted
## 1 20 49
## 2 21 66
## 3 22 94
## 4 23 93
## 5 24 97
## 6 25 88
## 7 26 92
## 8 27 71
## 9 28 63
## 10 29 68

#density plot
sql_dens = "SELECT Age FROM USA_MEDALS"
dens = dbGetQuery(con, sql_dens)
p = density(as.numeric(as.character(dens$Age)))
plot(p, main = "Density plot of Ages of Olympic Athletes", ylab = "Density", xlab = "Age")

dbDisconnect(con)