library(zoo)
library(urca)
library(pracma)

########## 
#Import data

# Read csv files into data frames

audcad <- read.csv("MeanReversionPart1/AUD_CAD.csv", stringsAsFactors = F)
audnzd <- read.csv("MeanReversionPart1/AUD_NZD.csv", stringsAsFactors = F)

# Convert strings into Date objects

audcad_dates <- as.Date(audcad[,1], format="%d/%m/%Y") 
audnzd_dates <- as.Date(audnzd[,1], format="%d/%m/%Y") 

# Create zoo objects from the 5th column containing closing prices

audcad <- zoo(audcad[,5], audcad_dates)
audnzd <- zoo(audnzd[,5], audnzd_dates)

# plot time series
plot(audcad, type = 'line', col = 'blue', xlab = 'Date', ylab = 'AUD/CAD')
plot(audnzd, type = 'line', col = 'red', xlab = 'Date', ylab = 'AUD/NZD')

##########
# ADF test 
summary(ur.df(audcad, type = "drift", lags = 1))
summary(ur.df(audnzd, type = "drift", lags = 1))

##########
# Hurst exponent
hurst <- hurstexp(log(audnzd)) # returns a list of various Hurst calculations

##########
# Calculate half life of mean reversion
y <- audnzd
y.lag <- lag(y, -1)
delta.y <- diff(y)
df <- cbind(y, y.lag, delta.y)
df <- df[-1 ,] #remove first row with NAs
regress.results <- lm(delta.y ~ y.lag, data = df)
lambda <- summary(regress.results)$coefficients[2]
half.life <- -log(2)/lambda



x = ts(audcad,start = as.Date("2008-01-04"), end = as.Date("2015-07-23"), frequency = 250)
fit <- stl(x, s.window = "periodic", t.window = 250, robust = T)
plot(fit)