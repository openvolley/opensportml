#' Example images provided as part of the opensportml package
#'
#' @param choices string: which image files to return?
#' - "2019 Wimbledon" - an image from the 2019 Wimbledon Men's Singles Championships, obtained from <https://en.wikipedia.org/wiki/2019_Wimbledon_Championships_%E2%80%93_Men%27s_Singles#/media/File:Wimbledon_2019_Nadal_v_Sousa.jpg> (CC BY-SA 4.0 license)
#'
#' @return Path to the image files
#'
#' @export
os_example_image <- function(choices = "2019 Wimbledon") {
    assert_that(is.character(choices))
    choices <- tolower(choices)
    if (!all(choices %in% c("2019 wimbledon"))) stop("unrecognized choices values: ", setdiff(choices, c("2019 wimbledon")))
    out <- rep(NA_character_, length(choices))
    out[choices == "2019 wimbledon"] <- system.file("extdata/images/1024px-Wimbledon_2019_Nadal_v_Sousa.jpeg", package = "opensportml")
    out
}
