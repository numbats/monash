
# from usethis utils.R

asciify <- function(x) {
  stopifnot(is.character(x))
  gsub("[^a-zA-Z0-9_-]+", "-", x)
}

# use this to evaluate inline R Markdown code
eval_inline <- function(text) {
  exprs <- stringr::str_match_all(text, "`r ([^`]+)`")[[1]][, 2]
  out <- unname(sapply(exprs, function(aexpr) eval(parse(text = aexpr))))
  text_new <- text
  for(a in out) {
    text_new <- stringr::str_replace(text_new, "`r [^`]+`", as.character(a))
  }
  text_new
}
