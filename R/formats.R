#' Output formats for Monash EBS documents
#'
#' Each function is a wrapper for \code{\link[bookdown]{pdf_document2}} to
#' produce documents in Monash EBS style.
#'
#' @param \dots Arguments passed to \code{\link[bookdown]{pdf_document2}}.
#'
#' @return An R Markdown output format object.
#'
#' @author Rob J Hyndman
#'
#' @export
letter <- function(...) {
  template <- system.file("rmarkdown/templates/letter/resources/monashletter.tex",
                          package="monash")
   bookdown::pdf_document2(...,
     template = template
   )
}

#' @rdname letter
#' @export
exam <- function(...) {
  template <- system.file("rmarkdown/templates/exam/resources/examtemplate.tex",
                          package="monash")
  bookdown::pdf_document2(...,
                          template = template
  )
}

#' @rdname letter
#' @export
workingpaper <- function(...) {
  template <- system.file("rmarkdown/templates/working-paper/resources/monashwp.tex",
                          package="monash")
  bookdown::pdf_document2(...,
                          template = template
  )
}


#' @rdname letter
#' @export
report <- function(...) {
  template <- system.file("rmarkdown/templates/report/resources/monashreport.tex",
                          package="monash")
  bookdown::pdf_document2(...,
                          template = template
  )
}

#' @rdname letter
#' @export
memo <- function(...) {
  template <- system.file("rmarkdown/templates/memo/resources/monashmemo.tex",
                          package="monash")
  bookdown::pdf_document2(...,
                          citation_package = 'biblatex',
                          template = template
  )
}

# assumes that the template repos all are in the `numbats` org
# with prefix `monash-quarto-`
base_quarto <- "numbats/monash-quarto-"

#' List of Quarto templates available
#'
#' This function lists the Monash Quarto templates available.
#'
#' @param type One of either "report", "workingpaper", "thesis", "memo", or
#'  "letter".
#' @param dir The name of the directory to put the template in. The directory
#'  should not exist.
#'
#' @name quarto_template
#' @examples
#' \dontrun{
#' quarto_template_use("report", dir = "myreport")
#' quarto_template_install("workingpaper")
#' quarto_template_add("thesis")
#' }
#' @export
quarto_template_use <- function(type = c("report",
                                         "workingpaper",
                                         "thesis",
                                         "memo",
                                         "letter"),
                                dir = type) {

  type <- match.arg(type)
  dir <- dir[1]
  wd_current <- getwd()
  wd_new <- dir
  if(dir.exists(wd_new)) stop(paste0("The directory ", wd_new, " already exists. Please delete this first to proceed."))
  dir.create(wd_new)
  setwd(wd_new)
  system(paste0("quarto use template ", base_quarto, type, " --no-prompt"))
  # back to original working directory
  setwd(wd_current)
  fn <- basename(dir)
  # TODO: add base option
  rstudioapi::navigateToFile(paste0(dir, "/", fn, ".qmd"))
}


#' @rdname quarto_template
#' @export
quarto_template_install <- function(type = c("report",
                                             "workingpaper",
                                             "thesis",
                                             "memo",
                                             "letter")) {
  type <- match.arg(type)

  system(paste0("quarto install extension ", base_quarto, type, " --no-prompt"))
  ui_done("Template installed.")
}


#' @rdname quarto_template
#' @export
quarto_template_add <- function(type = c("report",
                                         "workingpaper",
                                         "thesis",
                                         "memo",
                                         "letter")) {

  type <- match.arg(type)

  system(paste0("quarto add ", base_quarto, type, " --no-prompt"))
  ui_done("Template added.")
}
