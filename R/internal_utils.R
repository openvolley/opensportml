str_trim <- function(x) {
    gsub("^[[:space:]]+", "", gsub("[[:space:]]+$", "", x))
}

`%eq%` <- function (x, y) ifelse(is.null(x) || is.null(y), FALSE, x == y & !is.na(x) & !is.na(y))
