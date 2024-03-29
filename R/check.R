#' Check an \code{XPtr}'s Signature
#'
#' Check the signature (i.e., arguments and return type) of the output of
#' \code{\link{cppXPtr}}, which is an external pointer wrapped in an object of
#' class \code{XPtr}. If the user-supplied C++ function does not match the
#' signature, the wrapper throws an informative error.
#'
#' @param ptr an object of class \code{XPtr} compiled with \code{\link{cppXPtr}}.
#' @param type the return type.
#' @param args a list of argument types.
#' @param call. logical, indicating if the call should become part of the error message.
#'
#' @seealso \code{\link{cppXPtr}}
#' @examples
#' \donttest{
#' # takes time to compile
#' ptr <- cppXPtr("double foo(int a, double b) { return a + b; }")
#' checkXPtr(ptr, "double", c("int", "double")) # returns silently
#' try(checkXPtr(ptr, "int", c("double", "std::string"))) # throws error
#' }
#' @export
checkXPtr <- function(ptr, type, args = character(), call. = TRUE) {
  stopifnot(inherits(ptr, "XPtr"))

  .type. <- attr(ptr, "type")
  .args. <- sapply(attr(ptr, "args"), .type, USE.NAMES=FALSE)
  msg <- character()

  if (type != .type.)
    msg <- paste(c(
      msg, paste0("  Wrong return type '", type, "', should be '", .type., "'.")
    ), collapse = "\n")

  if (length(args) != length(.args.))
    msg <- paste(c(
      msg, paste0("  Wrong number of arguments, should be ", length(.args.), "'.")
    ), collapse = "\n")
  else {
    for (i in which(!(args == .args.)))
      msg <- paste(c(
        msg, paste0("  Wrong argument type '", args[[i]], "', should be '", .args.[[i]], "'.")
      ), collapse = "\n")
  }

  if (length(msg))
    stop("Bad XPtr signature:\n", msg, call.=call.)
}
