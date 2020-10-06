

#' @title Get Monash logo
#'
#' @description
#' A quick way of getting the Monash logo.
#'
#' @param path the path to save the file to
#' @param stack TRUE for stacked logo, FALSE for one-line logo
#' @param color `blue`, `black` or `white`
#' @param type `png`, `jpg` or `ai`
#' @param hq TRUE for high-quality image (larger file size)
#' @param overwrite TRUE for overwriting (should it enquire?), FALSE for not. Not implemented yet.
#' @param filename A new file name for the logo. Not implemented yet.
#'
#' @name logo
#' @source https://www.monash.edu/brandbook/brand-elements/our-logo
#' @export
logo_get <- function(path = ".",
                     stack = TRUE,
                     color = c("blue", "black", "white"),
                     type = c("png", "jpg", "ai"),
                     hq = FALSE,
                     overwrite = TRUE,
                     filename = NULL) {
  logo_path <- logo_path(stack = stack, color = color,
                         type = type, hq = hq)
  filename <- filename %||% path_file(logo_path)
  new_path <- path(path, filename)
  invisible(file_copy(logo_path, new_path = new_path, overwrite = overwrite))
  ui_done(glue("The {ui_value(filename)} is now in {ui_path(path)}"))
  new_path
}

#' @importFrom vctrs vec_assert
logo_path <- function(stack = TRUE,
                      color = c("blue", "black", "white"),
                      type = c("png", "jpg", "ai"),
                      hq = FALSE) {
  # validate arguments
  # all logo functions come here
  color <- arg_match(color)
  type <- arg_match(type)
  vec_assert(stack, logical(), size = 1)
  vec_assert(hq, logical(), size = 1)

  # get logo path
  color <- switch(color,
                  blue = ifelse(hq, "blue-cmyk", "blue-rgb"),
                  black = ifelse(hq, "black-cmyk", "black-rgb"),
                  white = ifelse(stack, "reversed-white", "reversed"))
  stack <- ifelse(stack, "stacked", "one-line")
  filename <- glue("monash-{stack}-{color}.{type}")
  logo <- logo_find(filename)
  logo
}



#' #' @rdname logo A wrapper to insert logo.
#' #' @export
#' logo_insert <- function(path = NULL,
#'                         stack = TRUE,
#'                         color = c("blue", "black", "white"),
#'                         type = c("png", "jpg", "ai"),
#'                         hq = FALSE) {
#'   path <- path %||% rmarkdown::metadata$lib_dir %||% "."
#'   knitr::include_graphics(logo_get(path = path,
#'                                    stack = stack,
#'                                    color = color,
#'                                    type = type,
#'                                    hq = hq,
#'                                    overwrite = TRUE))
#' }


logo_find <- function(logo_filename) {
  path <- tryCatch(
    path_package(package = "monash", "logos", logo_filename),
    error = function(e) ""
  )
  if (identical(path, "")) {
    ui_stop(
      "Could not find logo {ui_value(logo_filename)}."
    )
  }
  path
}

#' NUMBAT logo
#'
#' From Di: some history of the file: it is a photo that I took at
#' Healesville zoon when they still had numbats. I had to paint in
#' the legs so it looked more complete. and photoshop was used to make
#' it a little ore artistic
NULL
