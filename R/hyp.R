#' A hyp object
#'
#' @name hyp
#'
#' @section Arguments:
#' \describe{
#'   \item{data}{A dataframe returned by \code{hypeR}}
#'   \item{args}{A list of arguments passed to \code{hypeR}}
#' }
#'
#' @section Methods:
#'
#' \code{print(hyp)} shows some information about the object data as
#' well as the arguments used in creating it.
#'
#' \code{hyp$as.data.frame()} returns the dataframe slot.
#' 
#' @section See Also:
#' 
#' \code{multihyp}
#'
#' @examples
#' data <- data.frame(replicate(5,sample(0:1,10,rep=TRUE)))
#' args <- list("arg_1"=1, "arg_2"=2, "arg_3"=3)
#' hyp_obj <- hyp$new(data, args)
#'
#' @importFrom R6 R6Class
#' @export
hyp <- R6Class("hyp", list(
  data = NULL,
  args = NULL,
  initialize = function(data, args=NULL) {
    self$data <- data
    self$args <- args
  },
  print = function(...) {
    cat("hyp object: \n")
    cat("  data: ", nrow(self$data), " x ", ncol(self$data), "\n", sep="")
    cat("  args: ", paste(names(self$args), collapse="\n        "), sep="")
    invisible(self)
  },
  as.data.frame = function(...) {
    self$data
  }
))
