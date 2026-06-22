# Node.js + Docker CI/CD Pipeline

A minimalist, high-performance web application designed to demonstrate modern DevOps practices, automated containerization, and secure Continuous Integration/Continuous Deployment (CI/CD) workflows using GitHub Actions.

---

## Tech Stack & Architecture

* **Runtime:** Node.js (v22) + Express.js
* **Containerization:** Docker (Alpine Linux base)
* **CI/CD Engine:** GitHub Actions
* **Artifact Registry:** GitHub Container Registry (GHCR.io)
* **Infrastructure Optimization:** Docker Buildx (BuildKit)

---

## CI/CD Pipeline Architecture

The automated pipeline is configured via `.github/workflows/ci-pipeline.yml` and triggers automatically on every `push` or `pull_request` to the `main` branch. It consists of two sequential, decoupled jobs:

### 1. Verification Stage (`test-and-lint`)
* Spins up an isolated `ubuntu-latest` runner.
* Installs Node.js and executes a clean production dependency tree validation.
* Acts as an automated quality gate; if this stage fails, the pipeline halts immediately, preserving compute resources.

### 2. Build & Deploy Stage (`build-docker`)
* Requires successful completion of the verification stage (`needs: test-and-lint`).
* Configures **Docker Buildx** to leverage BuildKit features like advanced layer caching.
* Authenticates securely to `ghcr.io` using an ephemeral, least-privilege `GITHUB_TOKEN`.
* Converts repository metadata dynamically to strictly lowercase syntax to comply with Docker registry standards.
* Generates a unique immutable timestamp tag (`YYYYMMDD-HHMMSS`) alongside updating the `latest` tag.
* Pushes the optimized image layers to the public registry.

---

## Docker Optimization & Security

* **Minimal Footprint:** Uses `node:22-alpine` as the base layer to reduce attack surface and keep deployment images incredibly lightweight.
* **Dependency Omission:** Executes `npm install --only=production` during the build phase. This strips out all `devDependencies` (linters, testing frameworks), shrinking image sizes and eliminating third-party security vulnerabilities in production.
* **Ephemeral Secrets:** Avoids long-lived Personal Access Tokens (PATs) by dynamically provisioning short-lived GitHub tokens that instantly expire upon workflow termination.

---