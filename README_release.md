# 📦 TNBC Master Release (v3.0.6-tnbc)

This page summarizes the *TNBC Multi-Omics release deliverables*, providing complete master and reproducibility bundles for downstream use.

---

## 📂 Included Assets

| File                     | Description                          |
|--------------------------|--------------------------------------|
| *TNBC_master_bundle.zip* | Full deliverable (all reports, figures, manifests) |
| *TNBC_repro_bundle.zip*  | Minimal reproducibility bundle (scripts + configs) |
| *release_manifest_M3.tsv*| Detailed manifest of included files |
| *checksums_M3.sha256*    | SHA-256 integrity list              |

👉 Browse all releases here: [*GitHub Releases*](https://github.com/Baashi27-ai/tnbc-m1/releases)

---

## 🔐 Verify Integrity

You can verify the checksums locally with *PowerShell* (Windows) or *bash* (Linux/macOS):

*PowerShell*  
```powershell
Get-FileHash TNBC_master_bundle.zip -Algorithm SHA256

