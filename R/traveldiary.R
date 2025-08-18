
#' Create a simple travel diary for a Monash trip
#' 
#' Creates a simple travel diary (consisting of one destination) for a trip. Used in conjunction with
#' [render_travel_diary()] to generate a PDF travel diary for uploading.
#' 
#' @param start_date The start date of the trip (as a Date object).
#' @param end_date The end date of the trip (as a Date object).
#' @param start_city The city where the trip starts (default is "Melbourne").
#' @param destination The destination city for the trip.
#' @param reason The reason for the trip (e.g., "Conference", "Meeting").
#' 
#' @return A data frame representing the travel diary, with columns for Date, Location, and Description.
#' 
#' @examples
#' create_simple_travel_diary(as.Date("2025-08-18"), as.Date("2025-09-01"), destination = "Perth", reason = "NUMBATS Conference")
#' 
#' @export
create_simple_travel_diary <- function(start_date, end_date, start_city = "Melbourne", destination, reason) {
  data.frame(
    Date = seq(from = start_date, to = end_date, by = "1 day"),
    Location = c(start_city, rep(destination, length.out = as.numeric(end_date - start_date))),
    `Description` = c(paste0("Travel to ", destination), rep(reason, length.out = as.numeric(end_date - start_date)-1), paste0("Travel to ", start_city))
  )
}

#' Render a travel diary to PDF
#' 
#' Renders a travel diary to a PDF file using R Markdown. The travel diary must be created with [create_simple_travel_diary()].
#' 
#' @param travel_diary A data frame representing the travel diary, created with [create_simple_travel_diary()].
#' @param name The name of the person for whom the travel diary is created.
#' @param department The department name (default is "Department of Econometrics and Business Statistics").
#' @param output_path The directory where the PDF will be saved (default is the current working directory).
#' @param output_file The name of the output PDF file (without extension).
#' 
#' 
render_travel_diary <- function(travel_diary, name, department = "Department of Econometrics and Business Statistics", output_path = getwd(), output_file, ...) {
  if (is.null(travel_diary)) {
    stop("Travel diary is empty.")
  }

  travel_diary$Date <- format(travel_diary$Date, "%d-%b-%Y")
  
  params <- list(
    name = name,
    department = department,
    travel_diary = travel_diary
  )
  
  rmarkdown::render(
    input = system.file("rmarkdown/templates/traveldiary/skeleton.Rmd", package = "monash"),
    params = params,
    output_dir = output_path,
    output_file = output_file,
    envir = new.env(parent = globalenv()),
    ...
  )

  return(file.path(output_path, output_file))
}
