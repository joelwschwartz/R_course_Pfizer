##############################################################################
#  An Introduction to R
#  Part 1:  Basics
#  Instructor:  Kjell Johnson
#  Copyright 2013, Kjell Johnson and Arbor Analytics, LLC, All Rights Reserved
#  Demonstration code
##############################################################################

###Telling R Where to Work

setwd("c:/Part1")

## Or define the directory location with an object, then use setwd
fileLocation <- "c:/Part1"
setwd(fileLocation)

###Creating Data in R

## Vector:  an object that contains elements
## Elements can be numeric
scores <- c(89,102,73,54,92,27)

## Check to see if scores is numeric:
is.numeric(scores)

## Or character:
sample <- c("a","a","b","b","c","c")
is.character(sample)

## Factors
sample.f <- factor(sample)
is.factor(sample.f)

## Create a matrix
prepTime <- c(9,10,7,4,9,3)
myMatrix <- cbind(prepTime,scores)

## Create a data frame
myData <- data.frame(sampleID = sample.f, Score = scores)
colnames(myData)
rownames(myData)
dim(myData)

###Accessing data in a data frame
myData$Score
myData$sampleID
myData$Prep

myData[,1]
myData[2,]
myData[3:5,2]
myData[c(2,4,6),]


## Other ways to subset or select data:  the subset function
?subset

## Select samples with scores greater than 50:
subset(myData, Score > 50)

## Select samples with scores greater than 50 and less than or equal to 89:
subset(myData, Score > 50 & Score <= 89)

## Select samples with sampleID’s of “a”:
subset(myData, sampleID == "a")

## Select samples with sampleID’s of “a” or “b”:
subset(myData, sampleID %in% c("a","b"))

## Select samples with scores greater than 50 and keep the sampleID and Score variables: 
subset(myData, Score > 50, select=c("sampleID","Score"))

## Logical Constraints
## Select samples with scores greater than 50:
myData[myData$Score > 50,]

## Select samples with scores greater than 50 and less than or equal to 89:
myData[myData$Score > 50 & myData$Score <= 89,]

## Select samples with sampleID’s of “a”:
myData[myData$sampleID == "a",]

## Select samples with sampleID’s of “a” or “b”:
myData[myData$sampleID %in% c("a","b"),]

## Select samples with scores greater than 50 and keep the sampleID and Score variables: 
myData[myData$Score > 50, c("sampleID","Score")]

### Renaming rows and columns
## Rename all rows or columns
rownames(myData) <- c("Kermit","Miss Piggy","Rizzo", 
                      "Gonzo","Animal","Fozzy")
colnames(myData) <- c("Column1","Column2")

## Renaming one row or column:
rownames(myData)[rownames(myData) == "Kermit"] <- "Ralph"
colnames(myData)[colnames(myData) == "Column2"] <- "C2"

## Renaming rows or columns by index numbers:
rownames(myData)[1:2] <- c("Ralph","Swedish Chef")
colnames(myData)[1] <- "C1"

### Missing Data
scores <- c(89,102,73,54,92,NA)
is.numeric(scores)

## Using another value to represent missing will change the object’s type:
scores <- c(89,102,73,54,92,".")
is.numeric(scores)

## What do we do with missing values?
## Omit them:
myData <- data.frame(sampleID = sample.f, Score = scores,
                     Prep = prepTime)
myData.omit <- na.omit(myData)

## Replace them:
myData.replace <- myData
myData.replace$Score[is.na(myData.replace$Score)] <- 0

##What happens when we have missing data?
scores <- c(89,102,73,54,92,NA)
mean(scores)
mean(scores, na.rm = TRUE)

## Objects are in the session
ls()

## Remove an object from the session
rm(sample)

## Remove all objects from the session
rm(list=ls())

## Remove all but a few objects
rm(list= ls()[!(ls() %in% c('myData','sample','scores'))]) 


### Read in fev data
fev <- read.csv("fev_dat.csv", header = TRUE)
str(fev)

##Or
# fev <- read.table("fev_dat.csv", header = TRUE, sep = ",")

###Visualizing data
plot(fev$height,fev$FEV)

## Customize the plot
  plot(fev$height,fev$FEV,
       xlab = list("Height",cex=1.2),            #change x-label to Height and make it 1.2 times larger than normal
       ylab = list("FEV",cex=1.2),               #change y-label to FEV and make it 1.2 times larger than normal
       ylim = c(0,7),
       main = "Height by FEV for 654 Children",
       col = "chartreuse4",                      #change the symbol color to chartreuse4
       pch = 5,                                  #change the symbol to a diamond
       cex = 0.7)                                #make the symbols 70% of normal size

## Save the plot
png(filename = "FEVplot.png", width=600, height=600)
  plot(fev$height,fev$FEV,
       xlab = list("Height",cex=1.2),            #change x-label to Height and make it 1.2 times larger than normal
       ylab = list("FEV",cex=1.2),               #change y-label to FEV and make it 1.2 times larger than normal
       ylim = c(0,7),
       main = "Height by FEV for 654 Children",
       col = "chartreuse4",                      #change the symbol color to chartreuse4
       pch = 5,                                  #change the symbol to a diamond
       cex = 0.7)                                #make the symbols 70% of normal size
dev.off()

install.packages("ggplot2", dependencies=TRUE)

## Or we can install more than one package at a time
graphicPackages = c("lattice","ggplot2")
install.packages(graphicPackages,dependencies=TRUE)

## load ggplot2
library(ggplot2)

## Getting help within packages
library(help=ggplot2)
## Loading data from a package
data(diamonds)
## Get help for the ggplot function
?ggplot


## Create a simple scatterplot
ggplot(fev, aes(height,FEV))+geom_point()

## Modify the graph
ggplot(fev, aes(height,FEV,ymin=0,ymax=7)) +
       geom_point(colour = "chartreuse4",
                  shape = 5,
                  size = 1.5) +
       ggtitle("Height by FEV for 654 Children") +
       xlab("Height") +
       ylab("FEV") +
       theme(axis.title.x = element_text(size=20),
             axis.title.y = element_text(size=20))

## Split the graph by smoking status and add a regression line to each
ggplot(fev, aes(height,FEV)) +
       geom_smooth(method = "lm") +
       facet_grid(. ~ smoke) + 
       geom_point(colour = "chartreuse4",
                  shape = 5,
                  size = 1.5) +
       ggtitle("Height by FEV by Smoking Status") +
       xlab("Height") +
       ylab("FEV")

## Save the graph
ggsave(file = "fevBySmoke.png")

## Get the last 100 entries
history(100)

## Save the myData object as a csv file
write.csv(myData, file = "myData.csv", row.names = FALSE)

## Save entire workspace
save.image("part1.RData")

## Load a workspace
Rload.image("part1.Rdata")