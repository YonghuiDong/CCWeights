#' @title Run CCWeights shiny Gui
#' @description Run CCWeights shiny Gui
#' @author Yonghui Dong
#' @export
#' @examples
#'\dontrun{
#' runGui()
#'}


#' @export
runGui <- function() {
  appDir <- system.file("shiny", "Gui", package = "CCWeights")
  if (appDir == "") {
    stop("Could not find Shiny Gui directory. Try re-installing `CCWeightd`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
