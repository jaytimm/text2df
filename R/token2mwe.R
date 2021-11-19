#' Combine multi-word expressions per dictionary -- via quanteda --
#'
#' @name token2mwe
#' @param tok A list
#' @param mwe A character vector
#' @return A data frame
#'
#' @export
#' @rdname token2mwe
#'
#'
token2mwe <- function(tok, mwe){

  x1 <- quanteda::as.tokens(tok)
  x2 <- quanteda::tokens_compound(x1,
                                  pattern = quanteda::phrase(mwe))

  return(as.list(x2))
}
