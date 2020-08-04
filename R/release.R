#' @export
release_tutorial <- function(week,
                             dir = "tutorials",
                             output_dir = "release",
                             ignore = getOption("monash.tutorial.ignore"),
                             interactive = rlang::is_interactive(),
                             overwrite = TRUE) {
  # update tutorials
  changes <- release_changes(dir)
  # files with format tutorial-xx but not edning with sol.Rmd, sol.html, or sol.pdf
  pattern <- ifelse(missing(week),
                    "^tutorial-[0-9][0-9].*?(?<!sol)(\\.Rmd|\\.html|\\.pdf)",
                    sprintf("^tutorial-%.2d.*?(?<!sol)(\\.Rmd|\\.html|\\.pdf)", week))
  tut_changes <- grepl(pattern, changes, perl = TRUE)
  move_files(tut_changes, dir, output_dir, overwrite)

  # move other files?
  course <- desc::desc()$get_field("Package")
  ignores <- ignore[course]
  other_changes <- grepl("^(?!tutorial-[0-9][0-9]).*", changes)
  other_changes <- other_changes[!other_changes %in% ignores]
  move <- ui_yeah(ui_line(ui_todo("Do you want to move the following files as well?"),
                  other_changes))
  if(move) {
    move_files(other_changes, dir, output_dir, overwrite)
  }
}


release_changes <- function(dir,
                           output_dir = fs::path("release", dir)) {
  # note: don't use list.files(pattern = ...) (parsed in fileSnapshot ...)
  # it doesn't do negative look behind.
  s1 <- utils::fileSnapshot(dir)
  s2 <- utils::fileSnapshot(output_dir)
  changes <- invisible(utils::changedFiles(s2, s1))
  c(changes$added, changes$changed)
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
