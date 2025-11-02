# gcp-ci-cd-cloudrun-demo

A small demo repository that shows end-to-end CI/CD on Google Cloud Platform using GitHub Actions and Terraform. The app is a minimal Python Flask microservice deployed to Cloud Run. The repo includes a sample GitHub Actions workflow, a Terraform skeleton, tests, and a `COPILOT_USAGE.md` document describing how Copilot was used.

Quickstart (local)

1. Build and run locally:

   ```powershell
   cd gcp-ci-cd-cloudrun-demo\app
   python -m venv .venv; .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   python main.py
   ```

2. Run tests:

   ```powershell
   cd gcp-ci-cd-cloudrun-demo\app
   pytest -q
   ```

What is included

- `app/`: Flask app, Dockerfile, and tests
- `.github/workflows/ci-cd.yml`: example GitHub Actions workflow (build/test/deploy)
- `terraform/`: skeleton for Artifact Registry and Cloud Run
- `scripts/smoke_test.sh`: simple healthcheck script
- `docs/COPILOT_USAGE.md`: notes on Copilot prompts and assisted code

Notes

- The workflow uses placeholders and assumes you will configure GitHub Secrets (GCP_PROJECT, REGION, ARTIFACT_REPO, etc.) and Workload Identity for secure auth.
- This is a demo scaffold — adapt Terraform variables and permissions for your project.
