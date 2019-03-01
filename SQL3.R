#Moving Averages with SQL
mov_avg1 = "SELECT Edition as Year, Count(Edition) AS TotalNumber FROM Olymp_meds GROUP BY Edition"
out = dbGetQuery(con, mov_avg1)

#virtual table (called a VIEW )
dbGetQuery(con, "drop view tot_meds")
mov_avg2 = "CREATE VIEW tot_meds AS SELECT Edition AS Year, Count(Edition) AS TotalNumber FROM Olymp_meds GROUP BY Edition"
dbGetQuery(con, mov_avg2)

mov_avg3 = "SELECT Year, TotalNumber FROM tot_meds"
out = dbGetQuery(con, mov_avg3)

#line plot
plot(out$Year, out$TotalNumber, main = "Total number of athletes who obtained Olympic medals",
     xlab = "year", ylab = "Count", type = "p",
     col = "red", lwd = 2, las = 2)
lines(out$Year, out$TotalNumber, col = 1,
      lwd = 2)

# moving average within the year and averaging everything within that window
check = "SELECT * FROM tot_meds AS t,
(SELECT t1.Year, AVG(t2.TotalNumber) AS mavg
FROM tot_meds AS t1, tot_meds AS t2
WHERE t2.Year BETWEEN (t1.Year-4) AND (t1.Year+4)
GROUP BY t1.Year) sq WHERE (t.Year = sq.Year)"
movingAvg = dbGetQuery(con, check)

plot(out$Year, out$TotalNumber, main = "Total number of athletes who obtained Olympic medals",
     xlab = "year", ylab = "Count", type = "p", col = "red", lwd = 2, las = 2)
lines(out$Year, out$TotalNumber, col = 1, lwd = 2)
lines(movingAvg$Year, movingAvg$mavg,type = "l", col = 3, lwd = 2)
legend("topleft", lwd = 2, lty = c(NA, 1, 1), pch = c(1, NA, NA), col = c(2, 1, 3), c("medals per year points", "medals per year line", "moving average"))

#SQL summary statistics
summaries = "SELECT COUNT(Year) AS YearsInOlympics,
AVG(TotalNumber) AS AVGmedalcount , MIN(TotalNumber) AS MINmedalcount ,
MAX(TotalNumber) AS MAXmedalcount FROM Can_tot_meds"

getmedian = "SELECT TotalNumber AS Median FROM Can_tot_meds
ORDER BY TotalNumber LIMIT 1 OFFSET (SELECT COUNT(TotalNumber)
FROM Can_tot_meds) /2"

#(10, 30, 50, 70, 90) th percentiles
dbGetQuery(con, "CREATE VIEW MTL AS SELECT Edition AS Year,
Count(Edition) AS TotalNumber, NOC FROM Olymp_meds GROUP BY NOC, Edition
HAVING City == 'Montreal'")

get10 = "SELECT TotalNumber AS percentile10 FROM Can_tot_meds
ORDER BY TotalNumber LIMIT 1 OFFSET (SELECT COUNT(TotalNumber)*1/10
FROM Can_tot_meds)"
p10 = dbGetQuery(con, get10)
get30 = "SELECT TotalNumber AS percentile30 FROM Can_tot_meds
ORDER BY TotalNumber LIMIT 1 OFFSET (SELECT COUNT(TotalNumber)*3/10
FROM Can_tot_meds)"
p30 = dbGetQuery(con, get30)
get50 = "SELECT TotalNumber AS percentile50 FROM Can_tot_meds
ORDER BY TotalNumber LIMIT 1 OFFSET (SELECT COUNT(TotalNumber)*5/10
FROM Can_tot_meds)"
p50 = dbGetQuery(con, get50)
get70 = "SELECT TotalNumber AS percentile70 FROM Can_tot_meds
ORDER BY TotalNumber LIMIT 1 OFFSET (SELECT COUNT(TotalNumber)*7/10
FROM Can_tot_meds)"
p70 = dbGetQuery(con, get70)
get90 = "SELECT TotalNumber AS percentile90 FROM Can_tot_meds
ORDER BY TotalNumber LIMIT 1 OFFSET (SELECT COUNT(TotalNumber)*9/10
FROM Can_tot_meds)"
p90 = dbGetQuery(con, get90)

#standard deviation
initExtension(con)
dbGetQuery(con, "SELECT STDEV(TotalNumber) FROM Can_tot_meds")
## STDEV(TotalNumber)
## 1 19.26681