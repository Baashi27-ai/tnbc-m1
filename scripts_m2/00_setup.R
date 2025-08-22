message('M2/00_setup: loading packages & helpers')

pkgs <- c(
  'readr','dplyr','tibble','tidyr','ggplot2','stringr','purrr',
  'pheatmap','Matrix','RColorBrewer','caret','randomForest'
)
new <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(new)) install.packages(new, repos = 'https://cloud.r-project.org')

invisible(lapply(pkgs, library, character.only = TRUE))
options(stringsAsFactors = FALSE)

root <- 'C:/TNBC_project'
dirs <- list(
  results = file.path(root,'results_m2'),
  qc      = file.path(root,'results_m2/01_qc'),
  batch   = file.path(root,'results_m2/02_batch_correction'),
  fe      = file.path(root,'results_m2/03_feature_engineering'),
  modeling= file.path(root,'results_m2/04_modeling'),
  ext     = file.path(root,'results_m2/05_external_validation'),
  reports = file.path(root,'results_m2/06_reports'),
  logs    = file.path(root,'results_m2/_logs'),
  chk     = file.path(root,'checkpoints_m2')
)

logfile <- file.path(dirs$logs, paste0('m2_', format(Sys.time(),'%Y%m%d_%H%M%S'), '.log'))
dir.create(dirname(logfile), recursive = TRUE, showWarnings = FALSE)
zz <- file(logfile, 'wt'); sink(zz, type='output'); sink(zz, type='message')
message('Logging to: ', logfile)

checkpoint_save <- function(tag='M2') {
  dir.create(dirs$chk, showWarnings = FALSE, recursive = TRUE)
  obj <- intersect(ls(envir=.GlobalEnv),
                   c('X_raw','X_scaled','X_bc','qc_stats','feat_tbl','models','cv_results'))
  fp <- file.path(dirs$chk, paste0('tnbc_', tag, '', format(Sys.time(),'%Y%m%d%H%M%S'), '.RData'))
  save(list=obj, file=fp); message('Checkpoint → ', fp)
  invisible(fp)
}

m1 <- list(
  X_raw    = 'C:/TNBC_project/results/integration/integrated_features_raw.tsv',
  X_scaled = 'C:/TNBC_project/results/integration/integrated_features_scaled.tsv',
  anno_cc  = 'C:/TNBC_project/results/integration/consensus_clustering/annotation/cc_sample_annotations.tsv',
  rf_bundle= 'C:/TNBC_project/results/integration/consensus_clustering/classifier_cc/classifier_cc/rf_model_bundle.rds'
)

