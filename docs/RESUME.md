# Resume & Demo notes for gcp-ci-cd-cloudrun-demo

Use the bullets below in your resume, LinkedIn, or interview answers to concisely describe the project. Prefer 1–2 bullets on a resume and a longer explanation in your portfolio or LinkedIn.

Resume bullets (short)

- Implemented an end-to-end CI/CD pipeline deploying a containerized Python microservice to Google Cloud Run using GitHub Actions with OIDC-based authentication and Terraform for infrastructure provisioning.
- Automated image builds, Artifact Registry publishing, and Cloud Run deployments with smoke tests and automated rollback on failure; documented Copilot-assisted development and IaC patterns in the repo.

Expanded bullets (for portfolio / LinkedIn)

- Built a demo repo showing GitHub Actions → GCP Cloud Run CI/CD with Workload Identity Federation (OIDC) to avoid long-lived service account keys. Infrastructure was provisioned via Terraform (Artifact Registry, Cloud Run, service account + IAM bindings).
- Implemented a workflow that runs unit tests, builds and pushes Docker images to Artifact Registry using Cloud Build, deploys to Cloud Run, runs a smoke test script, and reverts traffic to the previous revision on failure.
- Captured Copilot prompts and accepted snippets in `docs/COPILOT_USAGE.md` and included a `docs/TERRAFORM_GUIDE.md` to explain infrastructure setup, Workload Identity, and recommended permissions.

Talking points for interviews

- Explain why you chose Cloud Run (serverless, low cost for demos) and Artifact Registry.
- Walk through the GitHub Actions workflow: authentication, build, push, deploy, smoke test, rollback.
- Show the Terraform modules and explain separation of concerns (artifact registry vs cloud run).
- Demonstrate Copilot-assisted commits: show a prompt and the generated code you accepted and explain how you validated it.
- Discuss security considerations: Workload Identity, minimal IAM roles, no static keys in repo.

How to demo in 5 minutes

1. Show README with high-level overview.
2. Show `docs/COPILOT_USAGE.md` and highlight one prompt + generated file (e.g., the workflow or main.py).
3. Show `ci-cd.yml` and explain OIDC and secret names.
4. Show Terraform outputs (artifact repo, service account email) and where to set GitHub Secrets.
5. Optionally run `scripts/smoke_test.sh` against a deployed service to demonstrate the health check.

Short commands to reference during a demo

```bash
# Init and apply terraform for staging
cd terraform
terraform init
terraform apply -var-file=envs/staging.tfvars

# Build and run locally
cd app
python -m venv .venv; . .venv/bin/activate
pip install -r requirements.txt
python main.py

# Run tests
pytest -q
```

Notes

- Keep the demo project small and focused: your goal is to demonstrate the pipeline and security practices, not a feature-complete app.
- Be prepared to explain any changes you made to Copilot suggestions and why.
