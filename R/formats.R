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
