

gcloud.cmd iam workload-identity-pools create "github-pool-new" --project="resolute-radar-343608" --location=global --display-name="GitHub Actions Pool"

gcloud.cmd iam workload-identity-pools providers list --workload-identity-pool="github-pool-new" --location="global" --project="resolute-radar-343608"

gcloud.cmd iam service-accounts add-iam-policy-binding "gha-deployer@resolute-radar-343608.iam.gserviceaccount.com" --project="resolute-radar-343608" --role="roles/iam.workloadIdentityUser" --member="principalSet://iam.googleapis.com/projects/34199410565/locations/global/workloadIdentityPools/github-pool-new/attribute.repository/manishn157/gcp-ci-cd-cloudrun-demo"

For running via Gitlab: 

Add GitHub repo secrets (one-time via web UI)
Set GCP_PROJECT, REGION, ARTIFACT_REPO, GCP_SA_EMAIL (from terraform output), WORKLOAD_IDENTITY_PROVIDER (the provider resource string).
Trigger the pipeline
Push your code (or merge to main). Workflow .github/workflows/ci-cd.yml will start automatically.

For  Manual run and testing, follow below steps

gcloud auth configure-docker us-central1-docker.pkg.dev
cd "d:\Manish\Study\vs code\Agentic AI\gcp-ci-cd-cloudrun-demo\app"
docker build -t us-central1-docker.pkg.dev/resolute-radar-343608/demo-repo/demo:local .
docker push us-central1-docker.pkg.dev/resolute-radar-343608/demo-repo/demo:local
gcloud.cmd run deploy demo --image us-central1-docker.pkg.dev/resolute-radar-343608/demo-repo/demo:local --region us-central1 --platform managed --allow-unauthenticated --quiet

Get the service URL and call health endpoint:
$URL = gcloud run services describe demo --region us-central1 --format="value(status.url)"
curl "$URL/health"

Check logs if smoke test fails:
gcloud logging read "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"demo\"" --project=YOUR_PROJECT --limit=50

Smoke testing:
gcloud run services update-traffic demo --to-revisions previous-revision=100 --region us-central1