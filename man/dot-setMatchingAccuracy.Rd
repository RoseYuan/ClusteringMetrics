% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SpatialMetrics.R
\name{.setMatchingAccuracy}
\alias{.setMatchingAccuracy}
\title{Just the non-spatially-weighted counterpart of nnWeightedAccuracy}
\usage{
.setMatchingAccuracy(true, pred)
}
\arguments{
\item{true}{True class labels (vector coercible to factor)}

\item{pred}{Predicted labels (vector coercible to factor)}
}
\value{
A scalar representing the weighted accuracy.
}
\description{
Just the non-spatially-weighted counterpart of nnWeightedAccuracy
}
