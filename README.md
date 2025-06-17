# Cloud-Native Reference Platform

A hands-on, production-ready reference solution for compliant, automated, and ephemeral AWS infrastructure, built with Go, Terraform, Kubernetes, and React.

## Overview
This project demonstrates how to architect, provision, and manage cloud-native applications and infrastructure on AWS, following best practices for compliance, automation, cost management, and developer experience. It is designed as a portfolio-ready project for interviews and public sharing (Medium, LinkedIn).

## Features
- **Reference Architecture:** Modular, reusable Terraform modules for AWS (VPC, EKS, RDS, S3, etc.)
- **Application:** Go backend API and React frontend, containerized with Docker
- **Ephemeral Environments:** Automated CI/CD pipeline (GitHub Actions) for short-lived test environments
- **Policy as Code:** OPA/Sentinel policies for compliance
- **Cost Management:** Resource tagging and cost reporting
- **Automated Testing:** Unit, integration, and infrastructure tests
- **Comprehensive Documentation:** User and developer guides, architecture diagrams

## Repository Structure
```
cloud-native-reference-platform/
├── infra/                # Terraform modules & scripts
├── backend/              # Go API
├── frontend/             # React app
├── policy/               # OPA/Sentinel policies
├── .github/workflows/    # GitHub Actions for CI/CD
├── tests/                # Go Terratest, frontend tests
├── docs/                 # Markdown docs, diagrams
└── README.md
```

## Getting Started
1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd cloud-native-reference-platform
   ```
2. **Set up AWS credentials and Terraform:**
   - See `infra/README.md` for details.
3. **Build and run the backend:**
   - See `backend/README.md` for details.
4. **Build and run the frontend:**
   - See `frontend/README.md` for details.
5. **Run CI/CD pipeline:**
   - See `.github/workflows/` for automation examples.

## Contribution Guidelines
- Follow code style and documentation standards
- Write tests for new features
- Submit PRs with clear descriptions

## Deployment
- Production-ready configuration for AWS and Kubernetes
- Automated ephemeral environments for testing
- Cost control and teardown scripts included

## License
MIT (or your choice)

---

**Showcase your skills in Go, Terraform, Kubernetes, AWS, and modern DevOps!**

---

For more details, see the `docs/` folder and future blog posts on Medium/LinkedIn.


1. Terraform (infra/)
Modular, reusable Terraform code to provision AWS networking, EKS (Kubernetes), and supporting resources.
Focus on compliance, tagging, and automation.
Includes README and example usage.
2. Go Backend (backend/)
REST API written in Go.
Containerized with Docker.
Includes basic endpoints, health checks, and automated tests.
3. CI/CD (GitHub Actions)
Automated pipeline for:
Terraform plan/apply
Building and testing Go/React apps
Deploying to EKS (Kubernetes)
Spinning up ephemeral environments for PRs