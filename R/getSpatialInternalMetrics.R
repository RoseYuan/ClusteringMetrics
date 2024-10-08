
#' getSpatialInternalMetrics
#' 
#' Computes a selection of internal clustering evaluation metrics for spatial 
#' data.
#' @inheritParams getSpatialElementInternalMetrics
#' @param metrics The metrics to compute. See details.
#' @param level The level to calculate the metrics. Options include `"element"`,
#' `"class"` and `"dataset"`.
#' @return A data.frame of metrics.
#' @export
#' @details
#' The allowed values for `metrics` depend on the value of `level`:
#'   - If `level = "element"`, the allowed `metrics` are: `"PAS"`, `"ELSA"`.
#'   - If `level = "class"`, the allowed `metrics` are: `"CHAOS"`, `"PAS"`, `"ELSA"`.
#'   - If `level = "dataset"`, the allowed `metrics` are:
#'      - `"PAS"`: Proportion of abnormal spots (PAS score)
#'      - `"ELSA"`: Entropy-based Local indicator of Spatial Association (ELSA score)
#'      - `"CHAOS"`: Spatial Chaos Score.
#'      - `"MPC"`: Modified partition coefficient
#'      - `"PC"`: Partition coefficient
#'      - `"PE"`: Partition entropy
#' @examples
#' data <- sp_toys
#' getSpatialInternalMetrics(data$label, data[,c("x", "y")], k=6, level="class")
getSpatialInternalMetrics <- function(labels, location, k=6, level="class",
                                      metrics=c("CHAOS", "PAS", "ELSA"), ...){
  # Map level to the corresponding function
  level_functions <- list(
    "element" = getSpatialElementInternalMetrics,
    "class" = getSpatialClassInternalMetrics,
    "dataset" = getSpatialGlobalInternalMetrics
  )
  .checkMetricsLevel(metrics, level, level_functions, use_default=FALSE, 
                     use_attribute=TRUE, attr_name="allowed_metrics")
  # Collect all arguments into a list
  args <- list(labels = labels, location=location, k=k, metrics = metrics, ...)
  do.call(level_functions[[level]], args)
}


#' Compute dataset-level internal evaluation metrics for spatially-resolved data
#' 
#' Computes a selection of internal clustering evaluation metrics for spatial 
#' data at the dataset level. MPC, PC and PE are internal metrics for fuzzy 
#' clustering, and their implementations in package `fclust` are used.
#' 
#' @param labels A vector containing the labels to be evaluated.
#' @param location A numerical matrix containing the location information, with
#' rows as samples and columns as location dimensions.
#' @param k The size of the spatial neighborhood to look at for each spot. 
#' This is used for calculating PAS and ELSA scores.
#' @param metrics The metrics to compute. See below for more details.
#' @param ... Optional arguments for [PAS()].
#' @importFrom fclust MPC PC PE
#' 
#' @references Yuan, Zhiyuan, et al., 2024; 10.1038/s41592-024-02215-8
#' @references Naimi, Babak, et al., 2019; 10.1016/j.spasta.2018.10.001
#' @references Wang, et al., 2022; 10.1016/j.ins.2022.11.010
#' 
#' @return A named vector containing metric values. Possible metrics are:
#'   \item{PAS}{Proportion of abnormal spots (PAS score).}
#'   \item{ELSA}{Entropy-based Local indicator of Spatial Association (ELSA score).}
#'   \item{CHAOS}{Spatial Chaos Score.}
#'   \item{MPC}{Modified partition coefficient} 
#'   \item{PC}{Partition coefficient} 
#'   \item{PE}{Partition entropy} 
#' 
#' @examples
#' data <- sp_toys
#' getSpatialGlobalInternalMetrics(data$label, data[,c("x", "y")], k=6)
getSpatialGlobalInternalMetrics <- function(labels, location, k=6,
                                            metrics=c("PAS", "ELSA", "CHAOS"),
                                            ...){
  res <- lapply(setNames(metrics, metrics), FUN=function(m){
    switch(m,
           PAS = PAS(labels, location, k=k, ...)$PAS,
           ELSA = colMeans(ELSA(labels, location, k=k), na.rm = TRUE),
           CHAOS = CHAOS(labels, location, BNPARAM=NULL)$CHAOS,
           MPC = MPC(getFuzzyLabel(labels, location)),
           PC = PC(getFuzzyLabel(labels, location)),
           PE = PE(getFuzzyLabel(labels, location)),
           stop("Unknown metric.")
    )}
    )
  res <- unlist(res)
  res <- data.frame(t(res), row.names = NULL)
  names(res)[names(res) == "ELSA.ELSA"] <- "ELSA"
  return(res)
}
attr(getSpatialGlobalInternalMetrics, "allowed_metrics") <- c("PAS","ELSA","CHAOS","MPC","PC","PE")

#' Compute spot-level internal evaluation metrics for spatially-resolved data
#' 
#' Computes a selection of internal clustering evaluation metrics for spatial 
#' data at each spot level.
#'
#' @inheritParams getSpatialGlobalInternalMetrics
#' @param metrics Possible metrics: "PAS" and "ELSA".
#' @param ... Optional params for [PAS()].
#' @return A dataframe containing the metric values for all samples in the dataset.
#' If PAS is calculated, the value is a Boolean about the abnormality of a spot.
#' If ELSA is calculated, Ea, Ec and ELSA for all spots will be returned.
#' @examples 
#' data <- sp_toys
#' getSpatialElementInternalMetrics(data$label, data[,c("x", "y")], k=6)
getSpatialElementInternalMetrics <- function(labels, location, k=6, 
                                      metrics=c("PAS", "ELSA"), ...){
  res <- as.data.frame(lapply(setNames(metrics, metrics), FUN=function(m){
    switch(m,
           PAS = PAS(labels, location, k=k, ...)$abnormalty,
           ELSA = ELSA(labels, location, k=k),
           stop("Unknown metric.")
           )})
    )
  colnames(res)[colnames(res) == "ELSA.ELSA"] <- "ELSA"
  return(res)
}
attr(getSpatialElementInternalMetrics, "allowed_metrics") <- c("PAS","ELSA")

#' Compute class-level internal evaluation metrics for spatially-resolved data
#' 
#' Computes a selection of internal clustering evaluation metrics for spatial 
#' data for each class.
#'
#' @inheritParams getSpatialElementInternalMetrics
#' @param metrics Possible metrics: "CHAOS", "PAS" and "ELSA".
#' @param ... Optional params for [PAS()].
#' @return A dataframe of metric values.
#' @examples 
#' data <- sp_toys
#' getSpatialClassInternalMetrics(data$label, data[,c("x", "y")], k=6)
getSpatialClassInternalMetrics <- function(labels, location, k=6, 
                                      metrics=c("CHAOS", "PAS", "ELSA"), ...){
  res <- data.frame(class=sort(unique(labels)))
  PAS <- .element2class(data.frame(PAS=PAS(labels, location, k=k, ...)$abnormalty, class=labels))
  ELSA <- .element2class(data.frame(ELSA=ELSA(labels, location, k=k), class=labels))
  CHAOS <- data.frame(CHAOS=CHAOS(labels, location, BNPARAM=NULL)$CHAOS_class, 
                              class=names(CHAOS(labels, location, BNPARAM=NULL)$CHAOS_class))
  if("PAS" %in% metrics){res <- merge(res, PAS, by="class")}
  if("ELSA" %in% metrics){res <- merge(res, ELSA, by="class")}
  if("CHAOS" %in% metrics){res <- merge(res, CHAOS, by="class")}
  colnames(res)[colnames(res) == "ELSA.ELSA"] <- "ELSA"
  return(res)
}
attr(getSpatialClassInternalMetrics, "allowed_metrics") <- c("CHAOS","PAS","ELSA")
