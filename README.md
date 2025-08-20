<<<<<<< HEAD
﻿![R](https://img.shields.io/badge/R-4.x-blue)
![Status](https://img.shields.io/badge/Milestone-M1-green)
[![Release](https://img.shields.io/github/v/release/Baashi27-ai/tnbc-m1)](https://github.com/Baashi27-ai/tnbc-m1/releases)
## Quick links

- *Master index (HTML):* inside newcohort_predict_bundle.zip  
- *Summary report:* see *Release v1.0.0-m1*  
- *Prediction bundle (zip):* see *Release v1.0.0-m1*  
  → https://github.com/Baashi27-ai/tnbc-m1/releases/tag/v1.0.0-m1

# TNBC Multi-omics: Milestone-1 (Integration â†’ Clustering â†’ Classifier)
=======
# TNBC Multi-omics: Milestone-1 (Integration → Clustering → Classifier)
>>>>>>> 16abb0e (First commit: TNBC Milestone-1 full pipeline and reports)

*What this repo shows*

- GSVA + PROGENy + TFA integration (190 samples; 300+ features)
- Consensus clustering (K=8) + stability & profiling (DE + enrichment)
- Survival (stable strata) + audit plots
<<<<<<< HEAD
- Classifier (RF) with OOB â‰ˆ 0.720 and hold-out CV
=======
- Classifier (RF) with OOB ≈ 0.720 and hold-out CV
>>>>>>> 16abb0e (First commit: TNBC Milestone-1 full pipeline and reports)

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
<<<<<<< HEAD

=======
>>>>>>> 16abb0e (First commit: TNBC Milestone-1 full pipeline and reports)
