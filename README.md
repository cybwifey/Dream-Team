# ai_health_inquiry
Using data science and artificial intelligence to develop data-driven solutions that support aging populations and improve chronic disease management


## 📁 Dream-Team Repository/Project Structure
```
Dream-Team/
├── README.md                  # General project info & Git instructions (existing)
├── docs/
│   ├── proposal.md            # Draft & final versions of the project proposal
│   ├── literature_review.md   # Key papers and summary notes
│   └── meetings/              # Agendas and meeting minutes
├── data/
│   ├── raw/                   # Unprocessed original datasets
│   └── processed/             # Cleaned and preprocessed data
├── code/
│   ├── api/                   # Data extraction process
│   ├── exploratory/           # EDA scripts & notebooks
│   ├── preprocessing/         # Data cleaning scripts
│   ├── modeling/              # Predictive model development scripts
│   └── validation/            # Model evaluation scripts
├── results/
│   ├── figures/               # Visualization outputs
│   └── tables/                # Statistical summaries & performance metrics
└── deliverables/
    ├── manuscript/            # Final manuscript & abstract
    ├── poster/                # Poster drafts & final version
    └── video/                 # Presentation videos
```
## File Naming Convention

To keep our project clean, consistent, and easy to collaborate on, please follow these naming rules:

### General Rules

- Use **snake_case** for all file names: `fetch_nhanes_data.R`
- Use **verbs** at the beginning to describe what the script does (e.g., `fetch_`, `clean_`, `train_`, `plot_`)
- Use the `.R` extension (uppercase **R**, not `.r`)
- Avoid spaces, uppercase letters, or special characters
- Please include an Author: *your name here* at the top of your script

### Folder Naming (project-wide)

- Use **lowercase-hyphen-separated** names for folders (e.g., `code/preprocessing/`)
- Keep subfolders specific by function (e.g., `api/`, `functions/`, `modeling/`)

### Examples

| Purpose             | Good Name                      | ❌ Bad Name             |
|---------------------|--------------------------------|-------------------------|
| API fetch           | `fetch_strava_data.R`          | `StravaAPI.R`           |
| Cleaning script     | `clean_vo2max_data.R`          | `VO2Clean.r`            |
| Modeling            | `train_random_forest.R`        | `TrainModel.R`          |
| Visualization       | `plot_chronic_disease_rate.R`  | `disease graph.R`       |

Following this format helps everyone on the team stay organized and prevents merge conflicts.



## Getting started + Git Workflow Instructions
Here’s how we’ll work together using Git and GitHub. Don’t worry if you’re new, simply just follow these steps each time you work on the project!


**1. Clone the repo** (first time only):
This copies the code from GitHub to your own computer.

```bash
git clone https://github.com/YOUR_USERNAME/ai_health_inquiry.git
cd ai_health_inquiry
```



**2. Pull the latest changes** (Everytime you start working!):
This grabs the latest changes from the GitHub repo so you're not working on old code.
Do this every time you start a new session, even if you just worked on it yesterday.

```
git pull origin main
```


**3. Create new branch for your work**:
Branches are like “drafts” — your changes stay separate until you’re ready to share.
Use names like feature/signup-page or bugfix/typo-readme.

```
git checkout -b feature/your-feature-name
```


**4. Make changes, then commit** (Always include a short description of your work/changes):
Staging (git add): marks what changes you want to save.
Committing (git commit): saves a snapshot with a message describing your work.

```
git add .
git commit -m "feat: short description of your work"
```


**5. Push your branch to github**:
This sends your branch up to GitHub so others can see it and review it.

```
git push origin feature/your-feature-name
```


**6. Open a pull request(PR)**:
Now go to the GitHub website:
  1. Click “Pull Requests” → “New Pull Request”
  2. Choose your branch (on the right) and compare it to main
  3. Add a title and short description
  4. Click Create Pull Request
  5. We'll review each other's PRs and merge them into main only after everything works!


##  Team Git Workflow Rules
  1. Never push directly to main!!!
  2. Always use a separate branch (feature/*, bugfix/*, or docs/*)
  3. Always pull before starting your work
  4. Review others’ pull requests before merging
  5. Keep commits small and focused



## Team Members
| Name       | GitHub Username |
| ---------- | --------------- |
| Sarina     | @cybwifey       |
| Adam       | @adamsilver2005 |
| Andrei     | @teammate2      | 
| Adrian     | @teammate3      |
| Arman      | @teammate4      |



