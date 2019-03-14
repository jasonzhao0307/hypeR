% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hyp_to_rmd.R
\name{hyp_to_rmd}
\alias{hyp_to_rmd}
\title{Export hyper object to rmarkdown}
\usage{
hyp_to_rmd(hyp, file.path, title = "", subtitle = "", author = "",
  header = "Hyper Enrichment", show_plots = TRUE, show_tables = TRUE,
  top = 15, val = "fdr", custom_rmd_config = NULL,
  custom_pre_content = NULL, custom_post_content = NULL)
}
\arguments{
\item{hyp}{A hyper object}

\item{file.path}{Output file path}

\item{title}{Title of markdown report}

\item{subtitle}{Subtitle of markdown report}

\item{author}{Authors of markdown report}

\item{header}{Header name of tabset section}

\item{show_plots}{Option to show plots in tabs}

\item{show_tables}{Option to show table in tabs}

\item{top}{Limit number of pathways shown in plots}

\item{val}{Choose significance value in plots e.g. c("pval", "fdr")}

\item{custom_rmd_config}{Replace configuration section of markdown report}

\item{custom_pre_content}{Insert custom content before tabset section}

\item{custom_post_content}{Insert custom content after tabset section}
}
\value{
None
}
\description{
Export hyper object to rmarkdown
}