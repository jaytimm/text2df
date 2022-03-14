#' Parallel text processing and annotation -- the latter via `udpipe`.
#'
#' @name tif2parallel
#' @param tif A dataframe
#' @param mwe A character vector
#' @param output_dir A file path
#' @param ud_model_dir A file path
#' @param cores An integer
#' @param per An integer
#' @return A list of data frames
#'
#' @export
#' @rdname tif2parallel
#'
#'
tif2parallel <- function(tif,
                         mwe = NULL,
                         output_dir = NULL, ## '/home/jtimm/Desktop/t2p/',
                         ud_model_dir,
                         cores = 6,
                         per = 1){

  MWE <- tolower(mwe)

  batches <- split(tif[, c('doc_id', 'text')],
                   ceiling(seq_along(1:length(tif$doc_id)) / (length(tif$doc_id)/cores/per)))

  setwd(ud_model_dir)
  udmodel <- udpipe::udpipe_load_model('english-ewt-ud-2.3-181115.udpipe')

  texting <- function(x,
                      tifA = tif2annotation,
                      mwe1 = MWE,
                      od = output_dir,
                      mod = udmodel){


    x <- text2df::tif2sentence(x)
    x <- text2df::tif2token(x)

    if(!is.null(mwe1)){x <- text2df::token2mwe(tok = x, mwe = mwe1)}
    x <- text2df::token2annotation(tok = x, model = udmodel)

    if(!is.null(od)){
      fn <- paste0(paste0(sample(LETTERS, 3, TRUE),
                          collapse = ''),
                   sample(9999, 1, TRUE))
      fn0 <- paste0(od, fn, '.rds')
      saveRDS(x, fn0) } else{return(x)}
  }

  clust <- parallel::makeCluster(cores)
  parallel::clusterExport(cl = clust,
                          varlist = c('batches', 'udmodel', 'MWE'),
                          envir = environment())

  dtm <- pbapply::pblapply(X = batches,
                           FUN = function(x)
                             texting(x,
                                     tifA = tif2annotation,
                                     mwe1 = mwe,
                                     mod = ud_model_dir,
                                     od = output_dir),
                           cl = clust)

  parallel::stopCluster(clust)
  #dtm0 <- data.table::rbindlist(dtm)
  return(dtm)
}
