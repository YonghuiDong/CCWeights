#' @title Evaluate different weighted linear regression models
#' @description Evaluate different weighted linear regression models
#' @author Yonghui Dong
#' @param DF data frame, it must contain a column named 'Concentration' and a column named 'Response'
#' @param userWeights user defined weights in linear regression, default is NULL. User can easily define weights, e.g., "1/x", "1/x^2", "1/y"
#' @export
#' @examples
#'\dontrun{
#' result <- doEvaluation(DF)
#'}

doEvaluation <- function(DF, userWeights = NULL) {
  Homo <- unique(doFtest(DF, p = 0.01)$Homoscedasticity)
  Compound <- unique(DF$Compound)
  if(is.null(userWeights)){userWeights = "None"}
  Model <- c("1", "1/x", "1/x2", "1/y", "1/y^2", paste("user: ", userWeights, sep = ""))
  W0 <- doWlm(DF, weights = NULL)
  W1x <- doWlm(DF, weights = "1/x")
  Wx2<- doWlm(DF, weights = "1/x^2")
  W1y <- doWlm(DF, weights = "1/y")
  Wy2 <- doWlm(DF, weights = "1/y^2")
  if(!is.null(userWeights)){
    Wuser <-  if(inherits(try(doWlm(DF, weights = userWeights), silent = TRUE), "try-error")){NULL} else {doWlm(DF, weights = userWeights)}
  }
  if(is.null(Wuser)){
    sumRE = c(W0$sumResid, W1x$sumResid, Wx2$sumResid, W1y$sumResid, Wy2$sumResid, NA)
    R2 = c(W0$R2, W1x$R2, Wx2$R2, W1y$R2, Wy2$R2, Wuser$R2, NA)
  } else{
    sumRE = c(W0$sumResid, W1x$sumResid, Wx2$sumResid, W1y$sumResid, Wy2$sumResid, Wuser$sumResid)
    R2 = c(W0$R2, W1x$R2, Wx2$R2, W1y$R2, Wy2$R2, Wuser$R2)
  }

  Recommendation <- rep("--", 6)

  if(Homo == "Yes") {
    Recommendation[1] <- "Yes"
  } else {
    Recommendation[which.min(sumRE)] <- "Yes"
  }

  Result <- cbind.data.frame(Compound = Compound,
                             Homoscedasticity = Homo,
                             Model = Model,
                             R2 = R2 ,
                             "sum%RE" = sumRE,
                             Recommendation = Recommendation)
  return(Result)

}
