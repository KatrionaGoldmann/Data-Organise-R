This document outlines how `Reproducer.R` can be used and provides some
examples. The script is currently functional for vectors (factor,
character or numeric), data frames, matrices and lists. This code is
still evolving so there may be some exceptions to this.

Note that in cases of large objects, RStudio will by default trucate
printed outputs. To override this you can go to Tools &gt; Global
Options &gt; Code &gt; Display and change 'limit length of lines
displayed in console to' to 0.

### Load in the script

```r
library(RCurl)
script <- getURL("https://raw.githubusercontent.com/KatrionaGoldmann/Reproducer/master/Reproducer.R")

eval(parse(text = script))
```

### Vectors

Create some examples (character, numeric, factor)
```r
    char <- letters[1:10]
    num <- 1:10
    fac <- factor(char)

    noquote(c(
        Reproduce(char, returnName=T),
        Reproduce(num, returnName=T),
        Reproduce(fac, returnName=T)
    ))

    ## [1] char <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j") 
    ## [2] num <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10) 
    ## [3] fac <- factor(c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j") )
```
Now we set other dummy variables as these using copy and paste:
```r
    char2 <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j")
    num2 <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    class(num2) <- class(num) # Difference between numeric and integer...need better workaround for future
    fac2 <- factor(c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j") )
```
Check if they are the same as the originals:
```r
    all(identical(char, char2), identical(num, num2), identical(fac, fac2))

    ## [1] TRUE
```
### Data Frames

Create some data:
```r
    df <- mtcars[1:5, 1:5]

    Reproduce(df)

    ## [1] df <- data.frame("mpg" = c(21, 21, 22.8, 21.4, 18.7), "cyl" = c(6, 6, 4, 6, 8), 
    ##                      "disp" = c(160, 160, 108, 258, 360), "hp" = c(110, 110, 93, 110, 175), 
    ##                      "drat" = c(3.9, 3.9, 3.85, 3.08, 3.15), 
    ##                      row.names = c("Mazda RX4", "Mazda RX4 Wag", "Datsun 710", "Hornet 4 Drive", "Hornet Sportabout"))
```
Now if you copy and paste this output to set it as say df2. Then we can
see that the two are exactly the same.
```r
    identical(df, df2)

    ## [1] TRUE
```
### Matrices

Create some data:
```r
    mat<- matrix(c(2, 4, 3, 1, 5, 7), nrow=3) 

    Reproduce(mat)

    ## [1] mat <- matrix(c(2, 4, 3, 1, 5, 7), nrow=3, ncol=2, dimnames=list( NULL ,  NULL ))
```
Now if you copy and paste this output to set it as say mat2.
```r
    mat2 <- matrix(c(2, 4, 3, 1, 5, 7), nrow=3, ncol=2, dimnames=list( NULL ,  NULL ))

    identical(mat, mat2)

    ## [1] FALSE
```
The only difference is the dimnames have been set as NULL. If you remove
this part of the argument then we can see that the two are exactly the
same.
```r
    mat3 <- matrix(c(2, 4, 3, 1, 5, 7), nrow=3, ncol=2)

    identical(mat, mat3)

    ## [1] TRUE
```
### Lists
Create a list

```r
    lst <- list(c(letters[1:5]), c(letters[6:10]))
    names(lst) <- 1:2
    
    Reproduce(lst)
 ```
Now if you copy and paste this output to set it as say lst2. Then we can
see that the two are exactly the same:
```r
    lst2 <- list("1" = c("a", "b", "c", "d", "e"), "2" = c("f", "g", "h", "i", "j"))

    identical(lst, lst2)

    ## [1] TRUE   
 ``` 
 
 ### Copied and pasted deliminated string
 Creates a vector from copied and pasted names separated by white space or non-alphanum characters.
 This requires the package `tockenizers` and the entire deliminated string to be bookended by quotes
 ```r
    copied.string("Here is an; example, where entries- are				deliminated")

    ## [1] c("Here", "is", "an", "example", "where", "entries", "are", "deliminated")
```
