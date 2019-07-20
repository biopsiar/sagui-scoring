#####################
# Voting simulation #
#####################

# mock <- readRDS("~/Documents/hackfest/datasets/mock.rds")
# mock <- mock[,c(1,12,17,9)]

lista <- readRDS("~/Documents/hackfest/datasets/FINALDATA.rds")
lista <- subset(lista, unit_price > 1 & unit_price < 10000)
#json = rjson::toJSON(lista)
#write(json, file = "DATA.final.filtered.json")
mock <- lista[,c(2,4,8,6)]

source("~/Documents/hackfest/scoring.R")
# import functions

mock$PPS <- sample(0, dim(mock)[1], replace = T)
mock$PTL <- sample(0, dim(mock)[1], replace = T)
mock$PNG <- sample(0, dim(mock)[1], replace = T)
mock$votes <- rowSums(mock[,c(5,6,7)])
# New scores
mock$itemScore = itemScore(mock)
mock$priorityScore = priorityScore(mock)
#ranking = priorityScore(table)#/((table$votes**2)+1)
mock <- mock[order(mock$priorityScore),]
mock$rank = rev(order(mock$priorityScore))
#mock = rankingScore(mock)
mock = mock[order(mock$rank),]
mock$Tag = lista$description

mock <- subset(mock, rank < 51) # Test subset
scorePerTime = cbind(mock[,c(9,10,11,12)],time=0)
scorePerTime$Tag = factor(scorePerTime$Tag)

# Choose 1% highest priority
for (timepoint in 1:1000){

if  (dim(mock)[1] == 0){
  break
}

mock <- subset(mock, votes < 20)
A = subset(mock, rank < 10)$Tag
who = sample(A, 1) # Randomly choose one of 1% highest
vote = sample(c("PPS","PTL","PNG"),1) # Choose a vote
mock[mock$Tag==who,vote] <- 1 + mock[mock$Tag==who,vote]
mock$votes <- rowSums(mock[,c(5,6,7)])
#mock$votes <- ifelse(mock$votes > 20, NA, mock$votes)
# Re-run new scores
mock$itemScore = itemScore(mock)
mock$priorityScore = priorityScore(mock)
# mock = rankingScore(mock)
# mock = mock[order(mock$rank),]
mock <- mock[order(mock$priorityScore),]
mock$rank = rev(order(mock$priorityScore))
#mock = rankingScore(mock)
mock = mock[order(mock$rank),]

# New timepoint
time = cbind(mock[,c(9,10,11,12)],time=timepoint)
scorePerTime = rbind(scorePerTime, time)
}

saveRDS(scorePerTime, "~/Documents/hackfest/datasets/scorePerTime.example.rds")