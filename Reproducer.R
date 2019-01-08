# Script which reproduced objects by generating a vector which when pasted back into R create identical objects
# Useful when posting questions to the wider programming community (the likes of stackoverflow, bioconductor...)

# To date (29/09/2017) this works for matrices, data.frames, factors, vectors, numerics, lists
# Note RStudio has settings to truncate string if longer than n characters, to print the full object:
# > Tools > Global Options > Code > Display : Set 'Limit length of lines displayer in console to' 0

Reproduce <- function(object, returnName=T){
	if (class(object) == "data.frame") {out <- rep.data.frame(object, returnName=F)}
	else if (class(object) == "matrix") {out <- rep.matrix(object, returnName=F)}
	else if (class(object) == "list") {out <- rep.list(object, returnName=F)}
	else {out <- rep.vector(object, returnName=F)}
	if(returnName == T) out <- paste(deparse(substitute(object)), "<-", out)
	noquote(out)
}

# function which creates a character vector from copied and pasted string. 
# You will have to add quotes around the entire string
copied.string <- function(string, sep=" ", returnName=F){
	library(tokenizers)
	lst <- unlist(tokenize_words(string, lowercase=FALSE ))
	rep.vector(lst, returnName=returnName)
}


################################
# Functions for specific data types
################################

# function  to reproduce vectors
rep.vector <- function(vector, returnName=F){
	classes <- setNames(c("c(", "factor(c(", "c(", "c(", "c("), c("character", "factor", "numeric", "logical", "integer"))
	temp <- c()
	for (i in 1:length(vector)) temp <- paste(temp, ', "', as.character(vector[i]), '"', sep="")
	if(! class(vector) %in% c("character", "factor")) temp <- gsub('"', "", temp)
	temp2 <- substr(noquote(temp), 3, nchar(noquote(temp)))
	temp3 <- paste(classes[class(vector)], temp2, ")", sep="")
	if (returnName == T) {temp3 <- paste(deparse(substitute(vector)), "<-", temp3)}
	if(class(vector) == "factor") temp3 <- paste(temp3, ")")
	noquote(temp3)
}

# Function to reproduce matrices
rep.matrix <- function(mat, returnName=F){
	rows <- nrow(mat)
	cols <- ncol(mat)
	nos <- c(mat)
	# Sort out the column and rownames
	d <- paste(", dimnames=list(", rep.vector(rownames(mat)),", ", rep.vector(colnames(mat)), ")" )
	if (is.null(rownames(mat)) == TRUE) d <- gsub(rep.vector(rownames(mat)), "NULL", d)
	if (is.null(colnames(mat)) == TRUE) d <- gsub(rep.vector(colnames(mat)), "NULL", d)
	output <- paste("matrix(", rep.vector(nos), ", nrow=", rows, ", ncol=", cols, d, ")", sep="")
	if (returnName == T) {output <- paste(deparse(substitute(mat)), "<-", output)}
	noquote(output)
}

# Function to reproduce data frames
rep.data.frame <- function(df, returnName=F, anonymise){
	cols <- ncol(df)
	x <- c()
	for (i in 1:cols)	x <- paste(x, '"', as.character(colnames(df)[i]), '"', " = ", rep.vector(df[,i]), ", ", sep="")
	x <- paste("data.frame(", substr(x, 1, nchar(x)-2), ", row.names = ", rep.vector(rownames(df)), ")", sep="")
	if (returnName == T) {x <- paste(deparse(substitute(df)), "<-", x)}
	noquote(x)
}

rep.list <- function(lst, returnName=F, anonymise){
	len <- length(lst)
	x <- c()
	for (i in 1:len){
		if (class(lst[[i]]) == "list") inp <- rep.list(lst[[i]]) # account for list within a list
		else inp <- rep.vector(unlist(lst[i]))
		if(is.null(names(lst)) == FALSE) x <- paste(x, '"', as.character(names(lst)[i]), '"', " = ", inp, ", ", sep="")
		else x <- paste(x, rep.vector(unlist(lst[i])), ", ", sep="")
	}
	x <- paste("list(", substr(x, 1, nchar(x)-2), ")", sep="")
	if (returnName == T) {x <- paste(deparse(substitute(df)), "<-", x)}
	noquote(x)
}


