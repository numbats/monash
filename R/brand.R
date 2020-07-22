#' Monash brand colors
#'
#' @name monash-color
#' @export
color_primary_show <- function() {
  scales::show_col(color_primary())
  color_primary()
}

#' @family
#' @export
color_secondary_show <- function() {
  scales::show_col(color_secondary())
  color_secondary()
}


#' @export
color_primary <- function() {
  return(c(blue = "#006DAE", black = "#000000", white = "#FFFFFF",
           gray80 = "#5A5A5A", gray50 = "#969696", gray10 = "#E6E6E6"))
}

#' @export
color_secondary <- function() {
  return(c(blue = "#027EB6", purple = "#746FB2", fuchsia = "#9651A0",
           ruby = "#C8008F", pink = "#ee64a4", red = "#EE0220",
           orange = "#D93F00", umber = "#795549", olive = "#6F7C4D",
           green = "#008A25"))
}


#' @export
color_info <- function() {
  # CLEAN
  cat("PRIMARY PALETTE

Monash Blue is our most identifiable colour. It conveys youthfulness, possibility and openness. It should always be considered first.

Black conveys prestige, timelessness and sophistication.

White is often shown as white space and conveys the brand personality of being open and youthful.

Greys can be any percentage of black and provides additional flexibility to our primary colour palette.

The primary colour palette is preferred for digital work.

  SECONDARY PALETTE

Inspired by the colours of our academic robes, we have a range of bright, colourful secondary colours.

Secondary colours are to be used:

* in charts and diagrams to highlight key findings
* as headings and subheadings
* sparingly to provide highlights or accents – ideally one or two secondary colours per double page spread
* to speak to a particular audience group. For instance, colours that would resonate best with our prospective undergraduate audience would be colourful, bright and youthful. Industry and research would suit a more corporate/mature choice to reflect focus and prestige.")
}


#' @family monash-color
#' @export
color_show_secondary <- function() {

}


#' Get Monash logo
#'
#' @description A quick way of getting the Monash logo.
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
NULL

#' @describeIn logo Download the logo to provided path
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

#' @describeIn logo Get path to insert logo.
#' @importFrom vctrs vec_assert
#' @export
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



#' @describeIn logo A wrapper to insert logo.
#' @export
logo_insert <- function(path = NULL,
                        stack = TRUE,
                        color = c("blue", "black", "white"),
                        type = c("png", "jpg", "ai"),
                        hq = FALSE) {
  path <- path %||% rmarkdown::metadata$lib_dir %||% "."
  knitr::include_graphics(logo_get(path = path,
                                   stack = stack,
                                   color = color,
                                   type = type,
                                   hq = hq,
                                   overwrite = TRUE))
}


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
