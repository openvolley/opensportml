#' A shiny app to define a court reference
#'
#' @param image_file string: path to an image file (jpg) containing the court image (not required if `video_file` is supplied)
#' @param video_file string: path to a video file from which to extract the court image (not required if \code{image_file} is supplied)
#' @param t numeric: the time of the video frame to use as the court image (not required if \code{image_file} is supplied)
#' @param court string: the type of court, currently only "tennis"
#' @param include_net logical: if `TRUE`, include reference points for the net
#' @param existing_ref list: (optional) the output from a previous call to [ov_shiny_court_ref()], which can be edited
#' @param launch_browser logical: if `TRUE`, launch the app in the system browser
#' @param ... : additional parameters (currently ignored)
#'
#' @return A list containing the reference information
#'
#' @examples
#' if (interactive()) {
#'   os_shiny_court_ref(image_file = os_example_image("tennis_court"))
#' }
#'
#' @export
os_shiny_court_ref <- function(image_file, video_file, t = 60, existing_ref = NULL, court = "tennis", include_net = FALSE, launch_browser = getOption("shiny.launch.browser", interactive()), ...) {
    assert_that(is.flag(include_net), !is.na(include_net))
    assert_that(is.string(court))
    court <- tolower(court)
    court <- match.arg(court, c("tennis"))
    if (court == "tennis") {
        court_refs_data <- data.frame(pos = c("nlb", "nrb", "nl3", "nr3", "lm", "rm", "fl3", "fr3", "flb", "frb", "lnt", "rnt"),
                                      lab = c("Near left baseline corner", "Near right baseline corner", "Left end of near service line", "Right end of near service line", "Left end of the midline", "Right end of the midline", "Left end of far service line", "Right end of far service line", "Far left baseline corner", "Far right baseline corner", "Left top of the net", "Right top of the net"),
                                      court_x = c(0.0, 100.0, 12.5, 87.5, 0.0, 100.0, 12.5, 87.5, 0.0, 100.0, 0.0, 100.0),
                                      court_y = c(0.0, 0.0, 46.0, 46.0, 100.0, 100.0, 154.0, 154.0, 200.0, 200.0, 100.0, 100.0),
                                      stringsAsFactors = FALSE)
    }
    ovideo::ov_shiny_court_ref(image_file = image_file, video_file = video_file, t = t, existing_ref = existing_ref, include_net = include_net, overlay_data_function = os_overlay_data, launch_browser = launch_browser, court_refs_data = court_refs_data, ...)
}
