# Prerequisites

**Docker**  
Required to build the application container and run OWASP ZAP in a container (locally).

**Terraform**  
Manages AWS infrastructure.

**AWS CLI** (optional but recommended)  
For local testing and AWS credential management (`aws configure`).

**Git & GitHub Account**  
For version control and GitHub Actions.

**A VPC and Public Subnets**  
Terraform expects `vpc_id` and `public_subnets` for ECS deployment.

---

# Quick Start

## Fork/Clone this repository
```bash
git clone https://github.com/your-username/ephemeral-security-testing.git
cd ephemeral-security-testing
```

## Configure Terraform for AWS
Open terraform/variables.tf or create a terraform/terraform.tfvars file with your vpc_id and public_subnets.

Push to GitHub
```bash
git add .
git commit -m "Initial commit"
git push origin main
```
## Trigger Pipeline
Go to GitHub → Actions → select “Ephemeral Security Testing” workflow → “Run workflow”
(or just push to main / open a PR).

## View Results
GitHub Actions will show logs as it builds, deploys, and scans the app.
If successful, a ZAP Report artifact will appear under the “Artifacts” section.
Terraform will destroy the environment automatically at the end of the run.

## Local Testing
Build & Run the Flask App Locally
```bash
cd app
docker build -t ephemeral-security-testing .
docker run -p 5000:5000 ephemeral-security-testing
# Visit http://localhost:5000 to see "Hello from Ephemeral Security Testing!"
```

## Local Terraform Deployment (Optional)
```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
# Once done, test the ALB URL
terraform destroy -auto-approve
```
## Local OWASP ZAP Scan (Optional, requires Docker)
```bash
# Make sure zap-scan.sh is executable
chmod +x scripts/zap-scan.sh
./scripts/zap-scan.sh "http://your-app-url/"
# Check the generated zap_report.html for vulnerabilities
```
# How It Works

## GitHub Actions Workflow: `ephemeral-ci.yml`
- **Runs `terraform init/plan/apply`** to spin up ECS, ALB, and the Docker container for the Flask app.  
- **Waits ~60 seconds** for the environment to become fully operational.  
- **OWASP ZAP** runs in a Docker container, scanning the ephemeral environment.  
- **Artifacts**: The ZAP HTML report is uploaded to GitHub for inspection.  
- Finally, **Terraform destroy** tears down resources, saving on costs.

## Security Checks
- The **ZAP Baseline** scan checks for common vulnerabilities: insecure headers, missing security-related HTTP headers, suspicious cookies, etc.  
- You can extend this approach with authentication scans, fuzzing, or advanced configuration (e.g., `zap-full-scan.py`).

## Ephemeral Approach
- Because infrastructure is **short-lived**, you reduce the attack surface (fewer resources remain online).  
- Perfect for **continuous integration** and **pull requests**: spin up, test, tear down.