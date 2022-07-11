#' Link attendance record to google sheet
#'
#' @param .data The summary data frame with email, total and letter grade.
#' @param .sheet The link to the googlesheet
#' @param sheetname The name of the sheet
#' @param week The week number
#' @param upload Should the attendance be uploaded to a Google sheet?
#'
#'
#' @export
zoom_attendance <- function(.data, .sheet, sheetname = "Lecture", week,
                            upload = FALSE) {
  df <- googlesheets4::read_sheet(.sheet, sheetname, skip = 3,
                            col_names = c("id", paste0("wk", 1:12), "away", "excused", "absent", "x"))

  out <- .data %>%
    mutate(id = stringr::str_match(email, "([a-zA-Z0-9]+)@.+")[,2])
  out <- df %>%
    select("id", old = paste0("wk", week)) %>%
    left_join(select(out, id, letter)) %>%
    mutate(letter = ifelse(is.na(letter), "U", letter),
           letter = ifelse(is.na(old), letter, old)) %>%
    select(-old)

  if(upload) {
    cli::cat_bullet("Uploading attendance to spreadsheet...", bullet_col = "red")
    googlesheets4::range_write(
      .sheet, out["letter"], sheet = sheetname,
      range = paste0(LETTERS[2 + week], c(4,NROW(df)+3), collapse = ":"),
      col_names = FALSE
    )
    cli::cli_alert_success("Attendance successfully uploaded \U1F389")
  }
  out
}

#' This reads in the zoom report
#'
#' The zoom meeting report is expected to have the meeting
#' information and uncheck the "unique users" so that the
#' record for start and end time exists. The latter is
#' required so that total time for students is recorded
#' from the start of the lecture to the end of the time and
#' not because the student happens to be lingering before/after.
#'
#' In order to identify the student, the zoom meeting should be
#' set to authenticate and restricted to Monash id alone.
#' This makes the data linkage easier with record in LMS.
#' @param file The file name for the zoom meeting report.
#' @param info TRUE or FALSE of whether the meeting information is included in the file.
#' @param date_format A date format specification. See [`readr::parse_datetime()`]
#'                    for more details.
#' @export
#' @importFrom readr read_csv cols col_character col_datetime col_double
zoom_read <- function(file, info = TRUE, date_format = "%m/%d/%Y %I:%M:%S %p") {
  nskip <- ifelse(info, 4, 1)
  read_csv(file, skip = nskip,
                 col_names = c("name", "email", "join", "leave", "duration", "guest", "consent"),
                 col_types = cols(
                   name = col_character(),
                   email = col_character(),
                   join = col_datetime(date_format),
                   leave = col_datetime(date_format),
                   duration = col_double(),
                   guest = col_character(),
                   consent = col_character()
                 ))

}

#' Process the data frame from zoom meeting to total duration of attendance
#'
#' @param .data Data frame
#' @param start,end A date time of when the zoom meeting started or ended.
#' If NA, this is ignored. If the date time is supplied, then the time is censored.
#' @param length The total length of the session in minutes.
#' @param accept A named numeric vector that signifies the minimum required amount for the letter grade.
#' @import dplyr
#' @export
zoom_process <- function(.data, start = NA, end = NA, length = 120,
                                accept = c("A" = length * 1/2, "P" = length * 3/4)) {
  if(!is.na(start)) {
    .data <- .data %>%
      mutate(join = case_when(join < start ~ start,
                              TRUE ~ join)) %>%
      filter(leave >= start)
  }
  if(!is.na(end)) {
    .data <- .data %>%
      mutate(leave = case_when(leave > end ~ end,
                               TRUE ~ leave)) %>%
      filter(start <= end)
  }
  out <- .data %>%
    mutate(duration = lubridate::period_to_seconds(as.period(leave - join))) %>%
    group_by(email) %>%
    summarise(total = sum(as.numeric(duration)))
  if(length(accept)) {
    accept <- c(-sort(-accept), "U" = -1)
    f <- rlang::parse_exprs(purrr::imap_chr(accept, ~glue::glue("total > {.x} ~ '{.y}'")))
    out <- out %>%
      mutate(letter = case_when(!!!f))
  }
  out
}

# Declare global variables to avoid check errors due to NSE
utils::globalVariables(c("email","join","leave","old"))
