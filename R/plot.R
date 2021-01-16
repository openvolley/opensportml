#' Minimal ggplot court plot
#'
#' @param court string: court to plot, currently only "tennis"
#' @param ... : additional arguments, currently ignored
#'
#' @return A list that can be added to a [ggplot2::ggplot()]
#'
#' @examples
#'
#' library(ggplot2)
#' ggplot() + os_ggcourt("tennis")
#'
#' @export
os_ggcourt <- function(court = "tennis", ...) {
    assert_that(is.string(court))
    court <- tolower(court)
    court <- match.arg(court, c("tennis"))
    if (court == "tennis") {
        list(geom_segment(data = data.frame(x = c(0, 100, 0, 0, -5, 12.5, 87.5),
                                            y = c(0, 0, 0, 200, 100, 0, 0),
                                            xend = c(0, 100, 100, 100, 105, 12.5, 87.5),
                                            yend = c(200, 200, 0, 200, 100, 200, 200)),
                          aes_string(x = "x", y = "y", xend = "xend", yend = "yend"), inherit.aes = FALSE, color = "black"),
             geom_segment(data = data.frame(x = c(50, 12.5, 12.5),
                                            y = c(46, 154, 46),
                                            xend = c(50, 87.5, 87.5),
                                            yend = c(154, 154, 46)),
                          aes_string(x = "x", y = "y", xend = "xend", yend = "yend"), inherit.aes = FALSE, color = "grey45"),
             coord_equal(),
             theme_void())
    } else {
        NULL
    }
}

#' Generate data suitable for creating a court overlay plot
#'
#' @param court string: court to plot, currently only "tennis"
#' @param space string: if "court", the data will be in court coordinates. If "image", the data will be transformed to image coordinates via [ovideo::ov_transform_points()]
#' @param court_ref data.frame: as returned by [os_shiny_court_ref()]. Only required if `space` is "image"
#' @param crop logical: if `space` is "image", and `crop` is TRUE, the data will be cropped to the c(0, 1, 0, 1) bounding box (i.e. the limits of the image, in normalized coordinates). Requires that the `sf` package be installed
#'
#' @return A list of data.frames
#'
#' @export
os_overlay_data <- function(court = "tennis", space = "court", court_ref, crop = TRUE) {
    assert_that(is.string(court))
    court <- tolower(court)
    court <- match.arg(court, c("tennis"))
    assert_that(is.string(space))
    space <- tolower(space)
    space <- match.arg(space, c("court", "image"))
    assert_that(is.flag(crop), !is.na(crop))
    if (crop && !requireNamespace("sf", quietly = TRUE)) {
        warning("ignoring crop = TRUE (this requires the `sf` package to be installed, but it does not appear to be available)")
        crop <- FALSE
    }

    if (court == "tennis") {
        ## outer and tram lines
        cxy <- data.frame(x = c(0, 100, 0, 0, -5, 12.5, 87.5),
                          y = c(0, 0, 0, 200, 100, 0, 0),
                          xend = c(0, 100, 100, 100, 105, 12.5, 87.5),
                          yend = c(200, 200, 0, 200, 100, 200, 200), width = 1.0)
        ## service boxes
        cxy <- rbind(cxy, data.frame(x = c(50, 12.5, 12.5),
                                     y = c(46, 154, 46),
                                     xend = c(50, 87.5, 87.5),
                                     yend = c(154, 154, 46), width = 1.0))
    } else {
        stop("unexpected court value: ", court)
    }

    if (space == "image") {
        cxy[, c("x", "y")] <- ovideo::ov_transform_points(cxy[, c("x", "y")], ref = court_ref, direction = "to_image")
        cxy[, c("xend", "yend")] <- setNames(ovideo::ov_transform_points(cxy[, c("xend", "yend")], ref = court_ref, direction = "to_image"), c("xend", "yend"))
        if (crop) {
            bbox <- sf::st_polygon(list(matrix(c(0, 0, 0, 1, 1, 1, 1, 0, 0, 0), ncol = 2, byrow = TRUE)))
            crop_seg <- function(z) {
                crpd <- as.numeric(sf::st_intersection(sf::st_linestring(matrix(c(z$x, z$y, z$xend, z$yend), ncol = 2, byrow = TRUE)), bbox))
                z$x <- crpd[1]
                z$xend <- crpd[2]
                z$y <- crpd[3]
                z$yend <- crpd[4]
                z
            }
            cxy <- do.call(rbind, lapply(seq_len(nrow(cxy)), function(ii) crop_seg(cxy[ii, ])))
        }
    }
    list(courtxy = cxy)
}
