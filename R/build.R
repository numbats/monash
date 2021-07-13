
render_website <- function(data, path = "docs/") {
  create_directory(path)
}

# from pkgdown
render_template <- function(path, data) {
  template <- read_file(path)
  if (length(template) == 0)
    return("")

  whisker::whisker.render(template, data)
}


