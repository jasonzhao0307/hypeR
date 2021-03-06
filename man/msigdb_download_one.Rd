% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/msigdb.R
\name{msigdb_download_one}
\alias{msigdb_download_one}
\title{Fetch gsets from msigdb}
\usage{
msigdb_download_one(species = "Homo sapiens", category,
  subcategory = "")
}
\arguments{
\item{species}{A species to determine gene symbols (refer to ?msigdbr::msigdbr for avilable species)}

\item{category}{Gene set category (refer to ?msigdbr::msigdbr for avilable categories)}

\item{subcategory}{Gene set subcategory (refer to ?msigdbr::msigdbr for avilable subcategories)}
}
\value{
A list of gene sets
}
\description{
Fetch gsets from msigdb
}
\examples{
HALLMARK <- msigdb_download_one("Homo sapiens", "H", "")

}
