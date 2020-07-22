can_overwrite <- function(path) {
  if (!file_exists(path)) {
    return(TRUE)
  }

  if (interactive()) {
    ui_yeah("Overwrite pre-existing file {ui_path(path)}?")
  } else {
    FALSE
  }
}


use_file <- function(file, new_path) {
  path <- tryCatch(
    path_package(package = "monash", file),
    error = function(e) ""
  )
  if (identical(path, "")) {
    ui_stop(
      "Could not find logo {ui_value(logo_filename)}."
    )
  }
  file_copy(path, new_path)
}
