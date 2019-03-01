par(mfrow = c(2, 2)) # this sets up plots with 2 rows and 2 columns.
plot(radius, volume, main = "Q1 plot made with type l",
     xlab = "radius", ylab = "Volume",
     lwd = 3, col = 21, type = "l")
plot(radius, volume, main = "Q1 plot made with type b",
     xlab = "radius", ylab = "Volume",
     lwd = 6, col = 1, type = "b")
plot(radius, volume, main = "Q1 plot made with type p",
     xlab = "radius", ylab = "Volume",
     lwd = 1, col = 4, type = "p")
plot(radius, volume, main = "Q1 plot made with type n",
     xlab = "radius", ylab = "Volume",
     lwd = 23, col = 13, type = "n")

#Saving and loading
save.image(file = "AllOfMyWorkSpace.Rdata")
save(poke, file = "JustThePokeObject.Rdata")

#Making comparisons
boxplot(poke[, "Attack"] ~ poke[, "Type.1"],
        main = "Q7:Pokemon Attacks by Type.1",
        las = 2)