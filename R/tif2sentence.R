#' Convert TIF to sentence df
#'
#' @name tif2sentence
#' @param x A TIF
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
                             sent_suppress = abbrevs))

  x0$text <- as.character(x0$text)
  x0$doc_id <- paste0(x0$parent, '.', x0$index)
  x0[, c('doc_id', 'text')]
}


tif2token <- function(tif){

  x1 <- corpus::text_tokens(tif$text,

                            filter = corpus::text_filter(
                              map_case = FALSE,
                              combine = abbrevs,
                              connector = '_' ) )

  names(x1) <- tif$doc_id
  return(x1)
}


token2df <- function(tok){

  df <- textshape::tidy_list(tok,
                             id.name = 'doc_id',
                             content.name = 'token')

  if(grepl('\\.', df$doc_id[1])) {
    df[, sentence_id := gsub('^.*\\.', '', doc_id)]
    df[, doc_id := gsub('\\..*$', '', doc_id)]
  }

  df[, token_id := data.table::rowid(doc_id)]
  return(df)
}

