#' Calculate jaccard similarity of two sets
#'
#' @keywords internal
jaccard_similarity <- function(a, b) {
    length( intersect(a, b) ) / length( union(a, b) )
}
#' Calculate overlap similarity of two sets
#'
#' @keywords internal
overlap_similarity <- function(a, b) {
    length( intersect(a, b) ) / min( length(a), length(b) )
}

#' Plot enrichment map
#'
#' @param df A dataframe
#' @param gsets A list of genesets
#' @param title Plot title
#' @param similarity_metric Metric to calculate geneset similarity
#' @param similarity_cutoff Geneset similarity cutoff
#' @param pval_cutoff Filter results to be less than pval cutoff
#' @param fdr_cutoff Filter results to be less than fdr cutoff
#' @param val Choose significance value shown above nodes e.g. c("fdr", "pval")
#' @param top Limit number of pathways shown
#' @return A plotly object
#'
#' @import igraph
#' @import visNetwork
#' @importFrom plotly plotly_empty 
#' @export
.enrichment_map <- function(df,
                            gsets, 
                            title, 
                            similarity_metric=c("jaccard_similarity", "overlap_similarity"),
                            similarity_cutoff=0.2,
                            pval_cutoff=1, 
                            fdr_cutoff=1,
                            val=c("fdr", "pval"),
                            top=NULL) {

    # Top pathways
    if (!is.null(top)) {
        df <- head(df, top)   
    }

    # Handle empty dataframes
    if (nrow(df) == 0) {
        return(plotly_empty())
    }

    # Significance cutoff
    hyp.df <- df[df$pval <= pval_cutoff,,drop=FALSE]
    hyp.df <- df[df$fdr <= fdr_cutoff,,drop=FALSE]
    
    # Geneset similarity matrix
    hyp.gsets <- gsets[hyp.df$category]
    hyp.gsets.mat <- sapply(hyp.gsets, function(x) {
        sapply(hyp.gsets, function(y,x) {
            if (similarity_metric == "jaccard_similarity") jaccard_similarity(x, y)
            else if (similarity_metric == "overlap_similarity") overlap_similarity(x, y)     
            else stop(paste(similarity_metric, "is an invalid metric"))
        }, x)
    })
    m <- as.matrix(hyp.gsets.mat)
    
    # Sparsity settings
    m[m < similarity_cutoff] <- 0
    
    # Similarity matrix to weighted network
    inet <- graph.adjacency(m, mode="undirected", weighted=TRUE, diag=FALSE)
    
    # igraph to visnet
    vnet <- toVisNetworkData(inet)

    # Add edge weights
    vnet$edges$value <- vnet$edges$weight
    
    # Add node scaled sizes based on genset size
    size.scaler <- function(x) (x-min(x))/(max(x)-min(x))*30 
    node.sizes <- sapply(V(inet), function(x) hyp.df[x, "category.annotated"])
    node.sizes.scaled <- size.scaler(node.sizes)+20
    vnet$nodes$size <- node.sizes.scaled
    
    # Add node tooltip information
    if (val == "fdr") {
        node.info <- sapply(V(inet), function(x) hyp.df[x, "fdr"])
        vnet$nodes$title <- paste("FDR", node.info, sep=": ")        
    }
    if (val == "pval") {
        node.info <- sapply(V(inet), function(x) hyp.df[x, "pval"])
        vnet$nodes$title <- paste("P-Value", node.info, sep=": ")        
    }
    
    # Add node scaled weights based on significance
    weight.scaler <- function(x) (x-max(x))/(min(x)-max(x))
    node.weights <- sapply(V(inet), function(x) hyp.df[x, val])
    node.weights.scaled <- weight.scaler(node.weights)
    vnet$nodes$color.border <- "black"
    vnet$nodes$color.background <- sapply(node.weights.scaled, function(x) {
                                       paste("rgba(0,159,253,", round(x, 3), ")", sep="")
                                   })
    
    output <- visNetwork(vnet$nodes, vnet$edges, main=list(text=title, style="font-family:Helvetica")) %>%
                         visNodes(shadow=TRUE) %>%
                         visEdges(color="red", hidden=FALSE, shadow=TRUE) %>%
                         visOptions(highlightNearest=TRUE) %>%
                         visInteraction(multiselect=TRUE, tooltipDelay=300) %>%
                         visIgraphLayout(layout = "layout_nicely")
}

#' Visualize enrichment map from one or more signatures
#'
#' @param hyp_obj A hyp or multihyp object
#' @param similarity_metric Metric to calculate geneset similarity
#' @param similarity_cutoff Geneset similarity cutoff
#' @param pval_cutoff Filter results to be less than pval cutoff
#' @param fdr_cutoff Filter results to be less than fdr cutoff
#' @param val Choose significance value shown above nodes e.g. c("fdr", "pval")
#' @param top Limit number of pathways shown
#' @param show_plots An option to show plots
#' @param return_plots An option to return plots
#' @return A plotly object
#'
#' @export
hyp_emap <- function(hyp_obj, 
                     similarity_metric=c("jaccard_similarity", "overlap_similarity"),
                     similarity_cutoff=0.2,
                     pval_cutoff=1, 
                     fdr_cutoff=1,
                     val=c("fdr", "pval"),
                     top=NULL,
                     show_plots=TRUE, 
                     return_plots=FALSE) {

    stopifnot("hyp" %in% class(hyp_obj) | "multihyp" %in% class(hyp_obj))

    # Default arguments
    similarity_metric <- match.arg(similarity_metric)
    val <- match.arg(val)

    # Handling of multiple signatures
    if ("multihyp" %in% class(hyp_obj)) {
        multihyp_obj <- hyp_obj
        n <- names(multihyp_obj$data)
        res <- lapply(setNames(n, n), function(title) {

            # Extract hyp dataframe
            hyp_obj <- multihyp_obj$data[[title]]
            df <- hyp_obj$data
            gsets <- hyp_obj$args$gsets

            p <- .enrichment_map(df, 
                                 gsets, 
                                 title,
                                 similarity_metric,
                                 similarity_cutoff,
                                 pval_cutoff, 
                                 fdr_cutoff,
                                 val,
                                 top)
            if (show_plots) {
                show(p)
            }
            return(p)
        })
    } else  {
        # Extract hyp dataframe
        df <- hyp_obj$data
        gsets <- hyp_obj$args$gsets
        res <- .enrichment_map(df,
                               gsets, 
                               "Enrichment Map",
                               similarity_metric,
                               similarity_cutoff,
                               pval_cutoff, 
                               fdr_cutoff,
                               val,
                               top)
        if (show_plots) {
            show(res)
        }
    }
    if (return_plots) {
        return(res)
    }
}