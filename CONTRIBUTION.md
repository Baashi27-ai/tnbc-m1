# Contributing to TNBC Multi-Omics Release Pipeline

Thank you for considering contributing to this project! 

## How to Contribute
1. *Fork* this repository to your GitHub account.  
2. *Create a branch* for your work:  
   ```bash
   git checkout -b feature/your-feature-name
   ## 📢 Reporting Issues
If you find a bug, have questions, or want to suggest improvements:
- Open an [issue](../../issues) with clear steps to reproduce.
- Add screenshots or logs when possible.
- Use descriptive titles (e.g., “Fix: checksum mismatch in M3 bundle”).

---

## 📝 Contribution Guidelines
- Write clean, commented code (PowerShell, R, or Python).
- Follow repo structure (scripts/, results/, docs/).
- Document any new parameters, flags, or configs.
- Keep commits atomic and meaningful.

---

## ✅ Tests & Validation
- Run run_all.R or the pipeline script before pushing.
- Verify generated outputs in results/.
- Ensure checksums (.sha256) match for reproducibility.

---

## 🔒 Security
- *Do not* commit secrets, tokens, or credentials.
- Use .gitignore for local configs or sensitive files.
- Report security issues privately instead of public issues.

---

## 📜 License
By contributing, you agree that your contributions will be licensed under the terms of the [MIT License](LICENSE).
