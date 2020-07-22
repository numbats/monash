
# from usethis utils.R

asciify <- function(x) {
  stopifnot(is.character(x))
  gsub("[^a-zA-Z0-9_-]+", "-", x)
}
