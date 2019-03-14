#' Plot top enriched pathways
#'
#' @param df A dataframe
#' @param title Plot title
#' @param top Limit number of pathways shown
#' @param val Choose significance value e.g. c("pval", "fdr")
#' @return A plotly object
#'
#' @importFrom plotly plot_ly plotly_empty add_trace add_annotations layout %>%
.enrichment_plot <- function(df, title, top=10, val=c("fdr", "pval")) {

    # Top pathways
    df <- head(df, top)

    # Handle empty dataframes
    if (nrow(df) == 0) {
        return(plotly_empty())
    }

    # Subset data based on significance value
    if (val == "pval") {
        df.1 <- df[,c(7,1,5,3)]
        val.pretty <- "P-Value"
    } else if (val == "fdr") {
        df.1 <- df[,c(7,2,5,3)]
        val.pretty <- "FDR"
    }

    # Calculate bar heights
    colnames(df.1) <- c("y", "x", "x1", "x2")
    df.2 <- df.1
    df.2$x <- -log10(df.1$x) # Total bar height
    df.2$x2 <- df.1$x2/df.1$x1*df.2$x # Second bar height
    df.2$x1 <- df.2$x-df.2$x2 # First bar height
    y <- factor(df.2$y, levels=df.2$y) # Force order of rownames

    p <- plot_ly(df.2,
                 x = ~x1,
                 y = ~y,
                 type = 'bar',
                 orientation = 'h',
                 hoverinfo = 'y',
                 marker = list(color = '#4CA1AF',
                               line = list(color = 'white',
                                           width = 1))) %>%

                 # Split bars
                 add_trace(x = ~x2, marker = list(color = '#C4E0E5')) %>%

                 # Plot settings
                 layout(title = title,
                        xaxis = list(title = paste("-log<sub>10</sub>(",
                                                   val.pretty,
                                                   ")",
                                                   sep=""),
                                     tickvals=c(-log10(0.05),
                                                -log10(0.01),
                                                -log10(0.001),
                                                seq(5, 1000, 5)),
                                     ticktext=c("-log(0.05)",
                                                "-log(0.01)",
                                                "-log(0.001)"),
                                     tickfont=list(size=9),
                                     showgrid = TRUE,
                                     showline = TRUE,
                                     showticklabels = TRUE,
                                     zeroline = TRUE,
                                     domain = c(0.16, 1)),
                        yaxis = list(title = "",
                                     categoryarray = rev(y),
                                     categoryorder = 'array',
                                     showgrid = TRUE,
                                     showline = TRUE,
                                     showticklabels = FALSE,
                                     zeroline = TRUE),
                        barmode = 'stack',
                        paper_bgcolor = 'white',
                        plot_bgcolor = 'white',
                        margin = list(l = 300, r = 0, t = 30, b = 40),
                        showlegend = FALSE) %>%

                 # Labeling the y-axis
                 add_annotations(xref = 'paper',
                                 yref = 'y',
                                 x = 0.15,
                                 y = y,
                                 xanchor = 'right',
                                 text = y,
                                 categoryorder = 'array',
                                 font = list(family = 'Arial',
                                             size = 10,
                                             color = 'black'),
                                 showarrow = FALSE,
                                 align = 'right')
    return(p)
}

#' Visualize top enriched pathways from one or more signatures
#'
#' @param hyp A hyper object
#' @param top Limit number of pathways shown
#' @param val Choose significance value e.g. c("pval", "fdr")
#' @param show_plots An option to show plots
#' @param return_plots An option to return plots
#' @return A plotly object
#'
#' @examples
#' # Grab a list of curated gene sets
#' REACTOME <- ex_get("C2.CP.REACTOME")
#'
#' # Genes involed in tricarboxylic acid cycle
#' symbols <- c("IDH3B","DLST","PCK2","CS","PDHB","PCK1","PDHA1","LOC642502",
#'              "PDHA2","LOC283398","FH","SDHD","OGDH","SDHB","IDH3A","SDHC",
#'              "IDH2","IDH1","OGDHL","PC","SDHA","SUCLG1","SUCLA2","SUCLG2")
#'
#' # Perform hyper enrichment
#' hyp <- hypeR(symbols, REACTOME, bg=2522, fdr=0.05)
#'
#' # Visualize
#' hyp_plot(hyp, top=3, val="fdr")
#'
#' @importFrom plotly plot_ly add_trace add_annotations layout %>%
#' @export
hyp_plot <- function(hyp, top=10, val=c("fdr", "pval"), show_plots=TRUE, return_plots=FALSE) {

    # Default arguments
    val <- match.arg(val)

    # Handling of multiple signatures
    if (class(hyp) == "list") {
        n <- names(hyp)
        res <- lapply(setNames(n, n), function(title) {
            p <- .enrichment_plot(hyp[[title]], title, top, val)
            if (show_plots) {
                show(p)
            }
            return(p)
        })
    } else  {
        res <- .enrichment_plot(hyp, "Top Pathways", top, val)
        if (show_plots) {
            show(res)
        }
    }
    if (return_plots) {
        return(res)
    }
}