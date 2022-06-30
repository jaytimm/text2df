#' Convert tokens to df -- via textshape package
#'
#' @name token2df
#' @param tok A list
#' @return A data frame
#'
#' @export
#' @rdname token2df
#'
#'
token2df <- function(tok){

  df <- textshape::tidy_list(tok,
                             id.name = 'doc_id',
                             content.name = 'token')

  if(grepl('\\.', df$doc_id[1])) {
    df[, sentence_id := gsub('^.*\\.', '', doc_id)]
    df[, doc_id := gsub('\\..*$', '', doc_id)]
    df[, term_id := data.table::rowid(doc_id, sentence_id)]
  }

  df[, token_id := data.table::rowid(doc_id)]
  return(df)
}

