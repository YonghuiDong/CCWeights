#' @title Perform calibration
#' @description perform calibration
#' @author Yonghui Dong
#' @param DF data frame, it must contain a column named 'Concentration' and a column named 'Response'
#' @param weights default is NULL
#' @importFrom stats predict
#' @importFrom magrittr %>%
#' @export
#' @examples
#'\dontrun{
#' result <- doCalibration(DF)
#'}

doCalibration <- function(DF, weights = NULL){

  ## suppress the warning: no visible binding for global variable ‘Concentration’
  Concentration <- NULL
  ## select only samples
  DFA <- DF %>%
    dplyr::filter(Concentration == 'unknown')

  if(nrow(DFA) > 0){

    # get ratio
    if (is.null(DFA$IS)) {
      DFA$Ratio = DFA$Response
    } else {
      DFA$Ratio = DFA$Response/DFA$IS
    }

    # get model
    model <-  if(inherits(try(doWlm(DF, weights = weights)$model, silent = TRUE), "try-error")){NULL} else {doWlm(DF, weights = weights)$model}

    # get y
    if (!is.null(model)){
      for (i in 1:dim(DFA)[1]) {
        DFA$Concentration[i] <- round((DFA$Ratio[i] - coef(model)[1])/coef(model)[2], 3)
      }
    }

    if (is.null(weights)){weights = "1"}
    DFA$Ratio <- NULL
    calResult <- cbind.data.frame(DFA, Model = weights)

  } else {

    if (is.null(weights)){weights = "1"}
    calResult <- cbind.data.frame(Sample = "No sample detected", Model = weights)
  }

  return(calResult)
}

