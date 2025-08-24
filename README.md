# 🚀 TNBC Multi-Omics Release Pipeline

![Build Status](https://github.com/Baashi27-ai/tnbc-m1/actions/workflows/build-and-release.yml/badge.svg)
[![Latest Release](https://img.shields.io/github/v/release/Baashi27-ai/tnbc-m1?include_prereleases&sort=semver)](https://github.com/Baashi27-ai/tnbc-m1/releases)

This repository powers the *end-to-end CI/CD pipeline* for the Triple-Negative Breast Cancer (TNBC) Multi-Omics Project.

Every tagged commit triggers GitHub Actions to:
- Run the analysis workflow (PowerShell + optional R).
- Package master and reproducibility bundles.
- Generate checksums & release manifests.
- Publish a GitHub Release with all artifacts.

---

## ✨ Features
- ✅ Zero-touch CI/CD – runs automatically on tag push.
- 📦 Artifacts included: reports, manifests, reproducible bundles.
- 🔐 Secure publishing with PAT (RELEASE_TOKEN).
- 🔎 SHA-256 integrity verification for all deliverables.
- 🤖 Future-ready for integration with TNBC AI pipelines.

---

## 📊 Key Results Snapshot

| Analysis                          | Output / Metric                              |
|-----------------------------------|----------------------------------------------|
| *TNBC Samples Integrated*       | N = 150 (multi-omics: RNA-seq + methylation + clinical) |
| *Consensus Clusters (K=8)*      | 8 stable clusters (validated by silhouette + PCA/UMAP) |
| *Kaplan–Meier Survival*         | Log-rank p = 0.002 → distinct survival differences |
| *Classifier (RF Ensemble)*      | OOB Accuracy ≈ 0.72, Hold-out Accuracy ≈ 0.70 |
| *Top Features*                  | 25 genes/proteins enriched in immune & growth pathways |
| *Pathway Enrichment*            | Hallmark, KEGG, Reactome → immune signaling, EGFR, MYC |
| *External Validation (GSE58812)*| Consistent subtype separation + survival relevance |

> 🔑 These highlights summarize the pipeline: reproducible clusters, validated biomarkers, predictive performance, and external cohort confirmation.

---

## 📦 Release Assets

Each release ships with:

| File                    | Description                         |
|-------------------------|-------------------------------------|
| *TNBC_master_bundle.zip*  | Complete master deliverable         |
| *TNBC_repro_bundle.zip*   | Minimal reproducibility bundle      |
| *release_manifest_M3.tsv* | Detailed manifest of included files |
| *checksums_M3.sha256*     | Integrity verification              |

👉 Browse all releases here: **[Releases](https://github.com/Baashi27-ai/tnbc-m1/releases)**

---

## 🗺 Pipeline Diagram (Mermaid)

```mermaid
flowchart LR
  A[Tag pushed] --> B[GitHub Actions: Checkout]
  B --> C[Run PowerShell pipeline]
  C --> D[Build master & repro bundles]
  D --> E[Generate checksums & manifest]
  E --> F[Create GitHub Release + Upload Assets]
  F -->|Publish| G[(Release)]
