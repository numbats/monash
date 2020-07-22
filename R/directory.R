# Taken from usethis directory.R

create_directory <- function(path) {
  if (dir_exists(path)) {
    return(invisible(FALSE))
  } else if (file_exists(path)) {
    ui_stop("{ui_path(path)} exists but is not a directory.")
  }

  dir_create(path, recurse = TRUE)
  ui_done("Creating {ui_path(path)}")
  invisible(TRUE)
}

check_path_is_directory <- function(path) {
  if (!file_exists(path)) {
    ui_stop("Directory {ui_path(path)} does not exist.")
  }

  if (!is_dir(path)) {
    ui_stop("{ui_path(path)} is not a directory.")
  }
}

check_directory_is_empty <- function(x) {
  files <- dir_ls(x)
  if (length(files) > 0) {
    ui_stop("{ui_path(x)} exists and is not an empty directory.")
  }
  invisible(x)
}
