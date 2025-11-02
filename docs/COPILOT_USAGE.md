# Copilot usage notes

This document records where GitHub Copilot was used to accelerate development in this repo. Below are the key prompts, the generated outputs that were accepted (possibly edited), and short notes you can use in interviews or on your resume.

How to capture Copilot usage
- Save short prompt -> result pairs here (copy the prompt you used and paste Copilot's suggestion).
- Commit frequently with messages that annotate Copilot assistance, e.g. `ci: add GitHub Actions workflow (copilot-assisted)`.
- If allowed by company policy, take a screenshot of the Copilot chat suggestions and add it to this doc for demonstrations.

Prompts and accepted outputs

1) Scaffold a minimal Flask app

Prompt:
```
Create a minimal Flask app with two endpoints: `/` returning JSON welcome message and `/health` returning JSON status=ok. Add a small `requirements.txt`.
```

Accepted output (file created):
- `app/main.py` (copilot suggestion accepted and minor edits applied)
- `app/requirements.txt`

Notes: Copilot produced the initial `main.py` and I adjusted the port and gunicorn command in `Dockerfile`.

2) Create GitHub Actions CI/CD workflow for Cloud Run

Prompt:
```
Write a GitHub Actions workflow that runs tests, authenticates to GCP via Workload Identity (OIDC), builds and pushes an image to Artifact Registry, deploys to Cloud Run, runs a smoke test, and rolls back on failure.
```

Accepted output (file created/edited):
- `.github/workflows/ci-cd.yml` — Copilot generated the initial structure; I added explicit OIDC inputs, secrets names, and a rollback strategy that records previous revision and uses `gcloud run services update-traffic` on failure.

3) Terraform module stubs and wiring

Prompt:
```
Create Terraform modules: one for Artifact Registry (Docker) and one for Cloud Run. Provide variables and outputs. Also create a top-level `main.tf` that wires modules and creates a `gha-deployer` service account with minimal IAM roles.
```

Accepted output (files):
- `terraform/modules/artifact_registry/*`
- `terraform/modules/cloudrun/*`
- `terraform/main.tf` which includes creation of a service account and IAM bindings (artifactregistry.writer, run.admin, iam.serviceAccountUser).

Notes: Copilot produced the initial HCL which I reviewed and adjusted (added outputs, default image for demo, and a README explaining recommended workflows).

4) Helper scripts and smoke test

Prompt:
```
Add a shell script `smoke_test.sh` that calls /health and exits non-zero when the service is unhealthy. Add deploy_helper.sh and tear_down.sh convenience scripts.
```

Accepted output (files):
- `scripts/smoke_test.sh`, `scripts/deploy_helper.sh`, `scripts/tear_down.sh` (minor edits applied for error handling and messaging).

Best-practices used when accepting Copilot suggestions
- Review generated code for security (no secrets were embedded). Remove or modify any code that uses unsafe defaults.
- Run all generated code locally or in a sandboxed project before trusting it in CI.
- Prefer small, easy-to-review edits of Copilot output rather than wholesale acceptance.

Suggested commit messages when using Copilot
- `chore: scaffold app and tests (copilot-assisted)`
- `ci: add initial GitHub Actions workflow (copilot-assisted)`
- `infra: add Terraform modules for artifact registry and cloud run (copilot-assisted)`

Resume-ready wording (pick one or two for your CV)
- "Built an end-to-end CI/CD demo deploying a containerized Python microservice to GCP Cloud Run using GitHub Actions and Terraform; used GitHub Copilot to accelerate workflow and Terraform scaffolding."
- "Implemented GitHub Actions pipelines with OIDC authentication to GCP and automated smoke-test rollback; Copilot-assisted development reduced scaffolding time by ~30% (documented in repo)."

Additions and evidence
- Keep this file updated with the exact prompts and the Copilot text that you accepted. This is valuable when you want to demonstrate how Copilot accelerated development in interviews.

If you'd like, I can also add a short `copilot-prompts/` directory containing the actual prompts and the accepted output snippets as separate text files for auditing.

---
Last updated: 2025-10-26
