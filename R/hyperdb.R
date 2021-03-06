#' Print hypeR-db gsets
#'
#' @param quiet Use true to suppress printing of available genesets
#' @return A character vector of available genesets
#'
#' @examples
#' hyperdb_info()
#'
#' @importFrom gh gh
#' @export
hyperdb_info <- function(quiet=FALSE) {
    response <- gh("/repos/:owner/:repo/contents/:path", owner="montilab", repo="hyperdb", path="data/genesets")
    files <- vapply(response, "[[", "", "name")
    gsets <- gsub(".rds", "", files)
    if (!quiet) print(gsets) 
    return(gsets)
}

#' Fetch gsets from hypeR-db
#'
#' @param gset A name corresponding to an available gene set
#' @return A list of gene sets
#'
#' @examples
#' gsets <- hyperdb_fetch("Cancer_Cell_Line_Encyclopedia")
#'
#' @export
hyperdb_fetch <- function(gset) {
    url <- "https://github.com/montilab/hypeR-db/raw/master/data/genesets/{0}.rds"
    temp <- tempfile(fileext=".rds")
    httr::GET(gsub("\\{0}", gset, url), 
              .send_headers = c("Accept" = "application/octet-stream"),
              httr::write_disk(temp, overwrite=TRUE))    
    return(readRDS(temp))
}
