# Converts a list which records characteristics by classes to a list which records classes by keys


list_flippeR <- function(input.list){
  output.list <- list()
  for(trait in unique(unlist(input.list))){
	  cat <- c()
	  for(j in names(input.list))	if(trait %in% input.list[[j]])) cat <- c(cat, j)
	  output.list[[trait]] <- cat
  }
output.list
}
