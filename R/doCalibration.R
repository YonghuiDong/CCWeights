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

  # get ratio
  if (is.null(DFA$IS)) {
    DFA$Ratio = DFA$Response
  } else {
    DFA$Ratio = round(DFA$Response/DFA$IS, 3)
  }

  # get model
  model <-  if(inherits(try(doWlm(DF, weights = weights)$model, silent = TRUE), "try-error")){NULL} else {doWlm(DF, weights = weights)$model}

  # get y
  if (!is.null(model)){
    for (i in 1:dim(DFA)[1]) {
      DFA$Concentration[i] <- round(predict(model, data.frame(x = c(DFA$Ratio[i]))), 3)
    }
  }

  if (is.null(weights)){weights = "1"}
  calResult <- cbind.data.frame(DFA, Model = weights)
  return(calResult)
}

