#' Monash brand colors
#'
#' @details
#' # Primary palette
#'
#' * Monash Blue is our most identifiable colour. It conveys youthfulness,
#' possibility and openness. It should always be considered first.
#' * Black conveys prestige, timelessness and sophistication.
#' * White is often shown as white space and conveys the brand personality
#' of being open and youthful.
#' * Greys can be any percentage of black and provides additional flexibility
#'  to our primary colour palette.
#'
#' The primary colour palette is preferred for digital work.
#'
#' # Secondary palette
#'
#' Inspired by the colours of our academic robes, we have a range of bright,
#' colourful secondary colours.
#'
#' Secondary colours are to be used:
#' * in charts and diagrams to highlight key findings
#' * as headings and subheadings
#' * sparingly to provide highlights or accents – ideally one or two secondary
#' colours per double page spread
#' * to speak to a particular audience group. For instance, colours that would
#' resonate best with our prospective undergraduate audience would be colourful,
#' bright and youthful. Industry and research would suit a more corporate/mature
#' choice to reflect focus and prestige.
#'
#' @name monash-color
#' @usage color_all() # show both primary and secondary colors
#' @export
color_all <- function() {
  c(color_primary(), color_secondary())
}

#' @param print whether to print the color vector
#' @rdname monash-color
#' @usage color_show(print = TRUE)
#' @export
color_show <- function(print = TRUE) {
  par(mfrow = c(1, 2))
  scales::show_col(color_primary())
  scales::show_col(color_secondary())
  if(print) print(color_all())
  return(invisible(color_all()))
}

#' @rdname monash-color
#' @usage color_primary()
#' @export
color_primary <- function() {
  return(c(blue = "#006DAE", black = "#000000", white = "#FFFFFF",
           gray80 = "#5A5A5A", gray50 = "#969696", gray10 = "#E6E6E6"))
}

#' @rdname monash-color
#' @usage color_secondary()
#' @export
color_secondary <- function() {
  return(c(blue = "#027EB6", purple = "#746FB2", fuchsia = "#9651A0",
           ruby = "#C8008F", pink = "#ee64a4", red = "#EE0220",
           orange = "#D93F00", umber = "#795549", olive = "#6F7C4D",
           green = "#008A25"))
}
