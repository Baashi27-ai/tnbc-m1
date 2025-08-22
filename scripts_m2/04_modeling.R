
source('scripts_m2/00_setup.R')
message('M2/04_modeling')

X_fe <- readr::read_tsv(file.path(dirs$fe,'X_features_topVar.tsv'), show_col_types = FALSE)
stopifnot('SID' %in% names(X_fe)); rownames(X_fe) <- X_fe$SID; X_fe$SID <- NULL
X_fe <- as.data.frame(X_fe)

y_tbl <- tryCatch({
  readr::read_tsv(file.path(root,'results/integration/consensus_clustering/cc_assignments.tsv'),
                  show_col_types = FALSE)
}, error=function(e) NULL)

if (!is.null(y_tbl) && all(c('SID','CC_cluster') %in% names(y_tbl))) {
  common <- intersect(rownames(X_fe), y_tbl$SID)
  Xm <- X_fe[common,,drop=FALSE]
  y  <- factor(y_tbl$CC_cluster[match(common, y_tbl$SID)])
  set.seed(123)
  ctrl <- caret::trainControl(method='repeatedcv', number=5, repeats=2, classProbs=TRUE)
  mod  <- caret::train(x = Xm, y = y, method = 'rf',
                       trControl = ctrl, ntree = 1000,
                       tuneLength = 5, importance = TRUE)
  saveRDS(mod, file.path(dirs$modeling,'rf_cv_model.rds'))
  readr::write_tsv(as.data.frame(mod$results), file.path(dirs$modeling,'rf_cv_results.tsv'))
  png(file.path(dirs$modeling,'rf_mtry_vs_acc.png'), 1000, 700, res=130)
  print(ggplot(mod$results, aes(mtry, Accuracy)) + geom_line() + geom_point() +
        ggtitle('RF CV Accuracy vs mtry') + theme_bw(12))
  dev.off()
  models <- list(rf_cv = mod)
} else {
  message('No labels found → skipping supervised modeling placeholder.')
  models <- list()
}
checkpoint_save('M2_modeling')

