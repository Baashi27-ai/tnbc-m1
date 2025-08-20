# TNBC Multi-omics: Milestone-1 (Integration → Clustering → Classifier)

*What this repo shows*

- GSVA + PROGENy + TFA integration (190 samples; 300+ features)
- Consensus clustering (K=8) + stability & profiling (DE + enrichment)
- Survival (stable strata) + audit plots
- Classifier (RF) with OOB ≈ 0.720 and hold-out CV

*Key deliverables*
- Master index (HTML):  [open](results/TNBC_M1_master_index.html)
- Summary report (DOCX): [download](results/REPORTS/TNBC_M1_summary.docx)
- New cohort prediction bundle: results/integration/consensus_clustering/newcohort_predict/

*Reproduce (quick view)*

r
source('scripts/QUICKSTART.R')


*Run pipeline (modular)*

r
source('run_all.R')


*Notes*

- Heavy data, checkpoints, and raw inputs are git-ignored.
- See results/ for figures (.png) and tables (.tsv).
