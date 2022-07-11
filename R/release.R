#' Release materials
#'
#' @name release-functions
#' @param week the week number
#' @param dir the subdirectory where the file is
#' @param output_dir the directory where the release folder is
#' @param ignore the file paths to ignore
#' @param interactive not used yet
#' @param overwrite should the files be overwritten?
#' @examples
#' \dontrun{
#' release_lecture(9) # to release week 9 lecture
#' release_tutorial(9) # to release week 9 tutorial
#' release_tutorial_solution(9) # to release week 9 tutorial solution
#' }
#'
NULL

#' @rdname release-functions
#' @export
release_lecture <- function(week,
                             dir = "tutorials",
                             output_dir = "release",
                             ignore = getOption("monash.lecture.ignore"),
                             interactive = rlang::is_interactive(),
                             overwrite = TRUE) {
  release_base("^lecture-%.2d(\\.Rmd|\\.html|\\.pdf)",
               "^(?!lecture-[0-9][0-9]).*",
               week, dir, output_dir, ignore, interactive, overwrite)
}

#' @rdname release-functions
#' @export
release_tutorial <- function(week,
                              dir = "tutorials",
                              output_dir = "release",
                              ignore = getOption("monash.tutorial.ignore"),
                              interactive = rlang::is_interactive(),
                              overwrite = TRUE) {
  release_base("^tutorial-%.2d(\\.Rmd|\\.html|\\.pdf)",
               "^(?!tutorial-[0-9][0-9]).*",
               week, dir, output_dir, ignore, interactive, overwrite)
}

#' @rdname release-functions
#' @export
release_tutorial_solution <- function(week,
                             dir = "tutorials",
                             output_dir = "release",
                             ignore = getOption("monash.tutorial.ignore"),
                             interactive = rlang::is_interactive(),
                             overwrite = TRUE) {
  release_base("^tutorial-%.2dsol(\\.Rmd|\\.html|\\.pdf)",
               "^(?!tutorial-[0-9][0-9]).*",
               week, dir, output_dir, ignore, interactive, overwrite)
}


release_base <- function(pos_pattern, neg_pattern, week, dir, output_dir, ignore = NULL,
                         interactive = FALSE, overwrite = FALSE) {
  if(missing(week)) abort("The week number is missing.")
  changes <- release_changes(dir)
  tut_changes <- changes[grep(pos_pattern, changes, perl = TRUE)]
  move_files(tut_changes, dir, output_dir, overwrite)

  # move other files?
  course <- desc::desc()$get_field("Package")
  ignores <- ignore[course]
  other_changes <- changes[grep(neg_pattern, changes, perl = TRUE)]
  other_changes <- other_changes[!other_changes %in% ignores]
  move <- ui_yeah(ui_line(c(ui_todo("Do you want to move the following files as well? Select no to select one at a time."),
                            other_changes)))
  if(move) {
    move_files(other_changes, dir, output_dir, overwrite)
  } else {
    exit <- FALSE
    while(!exit) {
      value <- ui_select(c(other_changes, "None"),
                         "Which file/folder do you want to move? ")
      if(value == length(other_changes) + 1) {
        exit <- TRUE
      } else {
        move_files(other_changes[value], dir, output_dir, overwrite)
        other_changes <- other_changes[-value]
      }
      if(length(other_changes) == 0) exit <- TRUE
    }
  }
}


release_changes <- function(dir,
                           output_dir = fs::path("release", dir)) {
  # note: don't use list.files(pattern = ...) (parsed in fileSnapshot ...)
  # it doesn't do negative look behind.
  s1 <- utils::fileSnapshot(dir)
  s2 <- utils::fileSnapshot(output_dir)
  if(fs::file_exists(".releaseignore")) {
    ignore_fns <- read.table(".releaseignore")[,1]
  } else {
    ignore_fns <- NULL
  }
  changes <- invisible(utils::changedFiles(s2, s1))
  setdiff(c(changes$added, changes$changed), ignore_fns)
}

move_files <- function(file_list, dir, output_dir, overwrite) {
  for(file in file_list) {
    if(is_file(path(dir, file))) {
      file_copy(path(dir, file), path(output_dir, dir, file), overwrite = overwrite)
    } else {
      dir_copy(path(dir, file), path(output_dir, dir, file), overwrite = overwrite)
    }
    ui_done(glue("The latest {ui_value(file)} is now in {ui_path(path(output_dir, dir))}"))
  }
}
