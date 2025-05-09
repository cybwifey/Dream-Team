# Team Update – May 9, 2025   
**Repository:** Dream-Team

---

## Repository & Workflow  
- Repo structure finalized (`code/`, `data/`, `docs/`, etc.)  
- Naming convention: lowercase, underscores, verbs  
- Pull request system established and followed  
- Direct commits to `main` allowed for admin actions only

---

## NHANES Integration  
- Fetched 2011–2012 datasets (+ 2021–2023 body measurements):
  - Demographics, blood pressure, diabetes, body measures  
- Datasets merged by `SEQN`, clean output saved to `data/processed/`  
- Developed 2 reusable cleaning scripts:
  - `clean_csv_data.R` – generic CSV preprocessor  
  - `clean_nhanes_flags.R` – handles malformed binary/logical values  
- All parsing errors resolved (`problems()` returns empty)

---

## External Data Source Strategy  
Due to CHMS & UK Biobank access restrictions, we pivoted to the following open sources:

- **WHO GHO API** – Global health indicators, VO₂ max proxies  
- **CDC CDI API** – U.S. chronic illness prevalence  
- **OpenML** – Ready-to-model biomedical datasets  

These are now listed in `docs/data_sources.md`  
If anyone finds more open sources (no scraping or permission required), please add them there!

---

## Language & Contribution Workflow  
- We will continue using **R** for all data processing and modeling  
- Current focus:
  1. Continue **collecting** diverse datasets  
  2. **Parse/process** all data into a standard format  
  3. **Clean and validate** fields for modeling

⚠ **Do NOT commit large `.csv` files** to `main` — Git can't handle large datasets well. Use `.gitignore` and store outputs locally.

---

## Final Proposal Draft  
A draft of the final proposal is now in `docs/proposal.md`.  
Feel free to request changes — just remember:
> _The more predictors and diverse factors we integrate, the more accurate and powerful our model will be._

---
## Pull Request Guidelines  
All pull requests **must include** the following:  
- A **clear title** that summarizes the change (e.g., `feat: add VO2 max fetch script`)  
- A **short description** explaining what the script or change does and where it fits into the pipeline

If your script pulls, processes, or transforms data, please describe:
- What data it works on  
- What it outputs or modifies  
- Whether it should be reused or is one-off

This will keep our collaboration smooth and reproducible.
---
