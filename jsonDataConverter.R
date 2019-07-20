###############################
# Transform Json in dataframe #
###############################

setwd("Documents/hackfest/")

data = readLines("datasets/FINALDATA.json")

data.final = rjson::fromJSON(data[1], simplify = F)
lista = sapply(data, function(x){
  data.final = rjson::fromJSON(x, simplify = T)
  do.call("cbind", data.final)
})
lista = as.data.frame(t(lista))
colnames(lista) <- c("buyer_id","buyer_name", "product_source","name","description","category","price","unit_price","purchase_date")
rownames(lista) <- NULL
lista$buyer_id <- as.character(lista$buyer_id)
lista$buyer_name <- as.character(lista$buyer_name)
lista$product_source <- as.character(lista$product_source)
lista$name <- as.character(lista$name)
lista$description <- as.character(lista$description)
lista$category <- as.character(lista$category)
lista$price <- as.numeric(lista$price)
lista$unit_price <- as.numeric(lista$unit_price)
lista$purchase_date <- as.character(lista$purchase_date)

saveRDS(lista, file = "Documents/hackfest/datasets/FINALDATA.rds")

# Description data

lista = readRDS("Documents/hackfest/datasets/FINALDATA.rds")

png(filename = "figs/DataFinal.categories.png", width = 1000, height = 800)
ggplot(lista, aes(y=log2(unit_price+1), x=factor(category))) + geom_boxplot() +
  theme_minimal() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
dev.off()

source("scoring.R")
mock2 <- lista[,c(2,4,8,6)]








