df_to_list <- function(df){
  l <- split(check, rep(1:ncol(check), each = nrow(check)))
  names(l) <- colnames(df)
  l
}
