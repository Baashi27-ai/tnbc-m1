
# project_housekeeping.R
setup_paths <- function() {
  dirs <- c(
    "C:/TNBC_project/results",
    "C:/TNBC_project/results/snf",
    "C:/TNBC_project/results/snf_cluster_biology",
    "C:/TNBC_project/results/snf_survival",
    "C:/TNBC_project/results/plots",
    "C:/TNBC_project/results/checkpoints",
    "C:/TNBC_project/deliverables"
  )
  for (d in dirs) if (!dir.exists(d)) dir.create(d, recursive = TRUE)
  message("✅ Paths verified/created: ", paste(dirs, collapse = ", "))
}

checkpoint <- function(suffix = NULL) {
  ts <- format(Sys.time(), "%Y%m%d-%H%M%S")
  if (!is.null(suffix) && nzchar(suffix)) ts <- paste0(ts, "_", suffix)
  path <- file.path("C:/TNBC_project/results/checkpoints", paste0("checkpoint_", ts, ".RData"))
  save.image(path)
  message("💾 Checkpoint saved at: ", path)
}

