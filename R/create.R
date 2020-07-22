#' Create skeleton working directories
#'
#' Functions to create a default directory structure.
#'
#' @param code the code of the course
#' @param name the short name of the course. There should be no spaces.
#' @param full_name the full name of the course e.g. Wild-Caught Data
#' @param destdir the directory path
#' @param layout a function that creates the directory layout.
#' See `monash::layout_teaching_dir` for an example.
#' @param rstudio launch in rstudio?
#' @param open open after creating teaching directory?
#'
#' @name working-dir
NULL


#' @describeIn working-dir Create a directory structure specified by `layout`.
#' @export
create_bare_dir <- function(code,
                            name = code,
                            full_name = name,
                            destdir = code,
                            layout = function() {},
                            rstudio = rstudioapi::isAvailable(),
                            open = interactive()) {

  destdir <- user_path_prep(destdir)
  check_path_is_directory(path_dir(destdir))

  create_directory(destdir)
  old_project <- proj_set(destdir, force = TRUE)
  on.exit(proj_set(old_project), add = TRUE)

  layout()

  if (rstudio) {
    use_rstudio()
  }

  if (open) {
    if (proj_activate(path)) {
      # Working directory/active project changed; so don't undo on exit
      on.exit()
    }
  }

  invisible(proj_get())

}


#' @describeIn working-dir Create a skeleton workshop directory.
#' @export
create_workshop_dir <- function(name, full_name = name,
                                destdir = getOption("monash.workshop_dir"),
                                rstudio = TRUE, open = TRUE,
                                layout = layout_workshop_dir) {
  destdir <- destdir %||% getwd()
  create_bare_dir(name = name, full_name = full_name, destdir = destdir,
                  rstudio = rstudio, layout = layout, open = open)
}

#' @describeIn working-dir Create a skeleton workshop directory.
#' @export
create_teaching_dir <- function(code, name = code, full_name = name,
                                destdir = getOption("monash.teaching_dir"),
                                rstudio = TRUE, open = TRUE,
                                layout = layout_teaching_dir) {
  destdir <- destdir %||% getwd()
  create_bare_dir(name = name, full_name = full_name, destdir = destdir,
                  rstudio = rstudio, layout = layout, open = open)
}

#' Directory layouts
#'
#' @name layouts
#' @export
layout_teaching_dir <-function() {
  opt_on <- getOption("monash.layout_workshop_dir")
  if(is_null(opt_on)) {
    use_directory("tutorials")
    use_directory(path("tutorials", "images"))
    use_directory("lectures")
    use_directory(path("lectures", "assets"))
    use_directory(path("lectures", "images"))
    use_directory("assessments")
    use_directory("data")
    use_directory("misc")
    use_directory("public")
    use_directory(path("public", "site"))
    use_file(path("templates", "_site.yml"), path("public", "site"))
  } else {
    if(is_function(opt_on)) opt_on()
    else {
      abort(glue("{ui_value('monash.layout_teaching_dir')} needs to be a function."))
    }
  }
}

#' @family layouts
#' @export
layout_workshop_dir <- function() {
  opt_on <- getOption("monash.layout_workshop_dir")
  if(is_null(opt_on)) {
    use_directory("slides")
    use_directory(path("slides", "images"))
    use_directory("public")
    use_directory(path("public", "site"))
    use_file(path("templates", "README.md"), path())
    use_file(path("templates", "_site.yml"), path("public", "site"))
  } else {
    if(is_function(opt_on)) opt_on()
    else {
      abort(glue("{ui_value('monash.layout_workshop_dir')} needs to be a function."))
    }
  }
}

