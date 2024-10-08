## code to prepare `metric_info` dataset goes here
metric_info <- data.frame(Name=c("SW",
                                 "meanSW", "minSW", "pnSW", "dbcv",
                                 "meanSW", "meanClassSW", "pnSW", "minClassSW", "cdbw", "cohesion (cdbw)", "compactness", "sep", "dbcv",
                                 "SI","ISI","NP","NCE",
                                 "SI","ISI","NP","NCE","AMSP","PWC","adhesion","cohesion (graph)",
                                 "SI","ISI","NP","AMSP","PWC","NCE", "adhesion","cohesion (graph)",
                                 "WC","WH","AWC","AWH","FM",
                                 "RI","WC","WH","ARI","AWC","AWH","NCR","FM","MI","AMI","VI","EH","EC","VM","VDM","MHM","MMM","Mirkin",
                                 "spotAgreement",
                                 "fuzzyWH", "fuzzyAWH", "fuzzyWC", "fuzzyAWC",
                                 "fuzzyRI", "fuzzyARI", "fuzzyWH", "fuzzyAWH", "fuzzyWC", "fuzzyAWC",
                                 "spotAgreement",
                                 "SpatialWH","SpatialAWH", "SpatialWC","SpatialAWC",
                                 "SpatialRI","SpatialARI","SpatialWH","SpatialAWH", "SpatialWC","SpatialAWC","SpatialAccuracy",
                                 "PAS", "ELSA",
                                 "CHAOS", "PAS", "ELSA",
                                 "CHAOS", "PAS", "ELSA", "MPC", "PC", "PE"
                                 ), 
                          Levels=c("element",
                                   rep("class",4),
                                   rep("dataset",9),
                    
                                   rep("elelemt",4),
                                   rep("class",8),
                                   rep("dataset",8),
                                   
                                   rep("class",5),
                                   rep("dataset",18),
                                   
                                   rep("elelemt",1),
                                   rep("class",4),
                                   rep("dataset",6),
                                   
                                   rep("elelemt",1),
                                   rep("class",4),
                                   rep("dataset",7),
                                   
                                   rep("elelemt",2),
                                   rep("class",3),
                                   rep("dataset",6)
                                        ), 
                          MainFunction=c(
                            rep("getEmbeddingMetrics",14),
                            rep("getGraphMetrics",20),
                            rep("getPartitionMetrics",23),
                            rep("getFuzzyPartitionMetrics",11),
                            rep("getSpatialExternalMetrics",12),
                            rep("getSpatialInternalMetrics",11)
                            ))

metric_info <- metric_info %>% group_by(Name) %>% summarize(
  Levels = paste(unique(Levels), collapse = ", "),
  MainFunction = paste(unique(MainFunction), collapse = ", ")
)


tmp <- data.frame(metric=c("Adjusted Mutual Information",
                             "Adjusted Mean Shortest Path",
                             "Adjusted Rand Index",
                             "Adjusted Wallace Completeness",
                             "Adjusted Wallace Homogeneity",
                             "Spatial Chaos Score",
                             "(Entropy-based) Completeness",
                             "(Entropy-based) Homogeneity",
                             "Entropy-based Local Indicator of Spatial Association (ELSA score)",
                             "F-measure/weighted average F1 score",
                             "Inverse Simpson’s Index",
                             "Meila-Heckerman Measure",
                             "Mutual Information",
                             "Maximum-Match Measure",
                             "Modified Partition Coefficient",
                             "Mirkin Metric",
                             "Neighborhood Class Enrichment",
                             "Normalized Class Size Rand Index",
                             "Neighborhood Purity",
                             "Proportion of Abnormal Spots (PAS score)",
                             "Partition Coefficient",
                             "Partition Entropy",
                             "Proportion of Weakly Connected",
                             "Rand Index",
                             "Simpson’s Index",
                             "Silhouette Width",
                             "Adjusted Rand Index for Spatial Clustering",
                             "Adjusted Wallace Completeness for Spatial Clustering",
                             "Adjusted Wallace Homogeneity for Spatial Clustering", 
                             "Spatial Set-matching Accuracy",
                             "Rand Index for Spatial Clustering",
                             "Wallace Completeness for Spatial Clustering",
                             "Wallace Homogeneity for Spatial Clustering",
                             "Van Dongen Measure",
                             "Variation of Information",
                             "V-measure",
                             "Wallace Completeness",
                             "Wallace Homogeneity",
                             "Adhesion of a graph",
                             "Composed Density between and within Clusters (CDbw)",
                             "CDbw Cohesion",
                             "Cohesion of a graph",
                             "CDbw Compactness",
                             "Density Based Clustering Validation Index (DBCV)",
                             "Fuzzy version of Adjusted Rand Index", 
                             "Fuzzy version of Adjusted Wallace Completeness",
                             "Fuzzy version of Adjusted Wallace Homogeneity", 
                             "Fuzzy version of Rand Index", 
                             "Fuzzy version of Wallace Completeness", 
                             "Fuzzy version of Wallace Homogeneity", 
                             "Mean of Class-level Silhouette Width",
                             "Mean Silhouette Width",
                             "Minimal of Class-level Silhouette Width",
                             "Minimal Silhouette Width", 
                             "Proportion of Negative Silhouette Width", 
                             "CDbw seperation",
                             "Spot-wise Pair Agreement"
                        
))

metric_info$Description <- tmp$metric                             
metric_info <- data.frame(metric_info)                            
usethis::use_data(metric_info, overwrite = TRUE)
