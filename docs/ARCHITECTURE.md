# Architecture overview

This demo repository implements a small CI/CD pipeline that builds, tests, and deploys a containerized microservice to Google Cloud Run. The main components are:

- GitHub Actions: CI workflow that runs unit tests, builds the container image, pushes to Artifact Registry, deploys to Cloud Run, and runs a smoke test.
- Artifact Registry: stores the built Docker images.
- Cloud Run: hosts the serverless containerized application.
- Terraform: Infrastructure as code to create Artifact Registry, Cloud Run service, and associated IAM resources (skeleton provided in `terraform/`).
- Smoke test script: validates the service is healthy after deployment and is used as a gate for successful deployment.

Sequence (high level):
1. Developer pushes code to `main`.
2. GitHub Actions runs tests and builds the image.
3. Action authenticates with GCP via Workload Identity and pushes the image to Artifact Registry.
4. Action deploys the image to Cloud Run (new revision).
5. Action runs `scripts/smoke_test.sh` against the service URL. If the smoke test fails, the workflow exits non-zero and you can trigger a rollback.

Later enhancements:
- Canary deployments (partial traffic shifting) and automated rollback to previous revision on smoke test failure.
- Cloud Monitoring alerts and uptime checks.
- Integration with Cloud Build or Buildpacks for alternate build strategies.
