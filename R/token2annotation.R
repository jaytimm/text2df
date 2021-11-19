#' Combine multi-word expressions per dictionary -- via quanteda --
#'
#' @name token2annotation
#' @param tok A list
#' @param model udpipe model
#' @param tagger udpipe tagger
#' @param parser udpipe parser
#' @return A data frame
#'
#' @export
#' @rdname token2annotation
#'
#'
token2annotation <- function(tok,
                             model,
                             tagger = 'default',
                             parser = 'none') {

  t0 <- lapply(tok, c, '\n')
  names(t0) <- gsub('\\..*$', '', names(t0))

  t1 <- sapply(unique(names(t0)),
               function(z) unname(unlist(t0[names(t0) == z])),
               simplify=FALSE)

  t2 <- udpipe::udpipe(object = udmodel,
                       x = t1,
                       tagger = tagger,
                       parser = parser)

  if(parser == 'none'){t2 <- t2[, c(1:12)]}

  subset(t2, select= -c(paragraph_id, sentence))
}
