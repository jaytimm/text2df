#' Convert TIF to sentence df
#'
#' @name tif2sentence
#' @param tif A TIF
#' @return A data frame
#'
#' @export
#' @rdname tif2sentence
#'
#'
tif2sentence <- function(tif){

  c0 <- tif$text
  names(c0) <- tif$doc_id
  x0 <- corpus::text_split(c0,
                           filter = corpus::text_filter(
                             sent_suppress = c(corpus::abbreviations_en, 'Gov.', 'Sen.')))

  x0$text <- as.character(x0$text)
  x0$doc_id <- paste0(x0$parent, '.', x0$index)
  x0[, c('doc_id', 'text')]
}
