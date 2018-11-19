List_to_df <- function(input.list){
	output.df <- data.frame(matrix(NA, nrow=length(table(unlist(input.list))), ncol = max(table(unlist(input.list)), na.rm=T)))
	rownames(output.df) <- names(table(unlist(input.list)))
	colnames(output.df) <- paste("var", 1:ncol(output.df))
	for(i in names(table(unlist(input.list)))){
		cat <- c()
		for(j in names(input.list)) if(i %in% gsub("-", "",  input.list[[j]])) cat <- c(cat, j)
		cat <- append(cat, rep("", ncol(output.df) - length(cat)))
		output.df[i, ] <- cat
	}
	output.df
}
