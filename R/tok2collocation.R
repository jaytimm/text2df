#' Extract collocations from token object -- via text2vec package
#'
#' @name tok2collocations
#' @param tokA A list
#' @param collocation_count_min An integer
#' @param pmi_min An integer
#' @param remove_stops A Boolean
#' @param remove_punct A Boolean
#' @param n_iter An integer
#'
#' @return A list
#'
#' @export
#' @rdname tok2collocations
#'
tok2collocations <- function(tok,
                              collocation_count_min = 15,
                              pmi_min = 5,
                              remove_stops = F,
                              remove_punct = T,
                              n_iter = 5){

  it <- text2vec::itoken(tok, progressbar = FALSE)
  model <- text2vec::Collocations$new(collocation_count_min = collocation_count_min,
                                      pmi_min = pmi_min,
                                      sep = ' ')

  invisible(capture.output(
    model$fit(it, n_iter = n_iter)
  ))

  collos <- unique(tolower(model$.__enclos_env__$private$phrases))

  if(remove_stops){
    collos <- subset(collos, !grepl(paste0('\\b', tm::stopwords(), '\\b', collapse = '|'),
                                    collos))
  }

  if(remove_punct){
    collos <- subset(collos, !grepl("[[:punct:]]", collos, perl = T))
  }

  collos
}
