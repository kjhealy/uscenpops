#' US Census and Intercensal Population Counts and Estimates
#'
#' US Census population estimates by year of age and sex, 1900-2019
#'
#' @format A tibble with 10,520 rows and 5 columns
#' \describe{
#' \item{\code{year}}{Year in <int> format. Where multiple monthly or quarterly estimates were available in the original data, the July estimate was used for the yearly count.}
#' \item{\code{age}}{Age in years. Top-coded at 75 between 1900 and 1939, at 85 between 1940 and 1979, and 100 thereafter.}
#' \item{\code{pop}}{Total population count.}
#' \item{\code{male}}{Male population count.}
#' \item{\code{female}}{Female population count.}
#' }
#'
#' @docType data
#' @keywords datasets
#' @name uscenpops
#' @source United States Census Bureau
'uscenpops'
