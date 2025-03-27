<!-- @format -->

This directory contains GitHub workflow examples for central pipelines to deploy your Azure infrastructure.

**Workflows:**

**Build Workflow (build.yml):** Builds your Azure infrastructure. It includes:

- Azure Bicep linting
- Azure What-If deployment
- Publishing lint test results as a GitHub workflow summary
- Uploading Bicep files as a build artifact for deployment workflows.

**Deploy Workflow (deploy.yml):** Deploys your Azure Infrastructure. It includes:

- Authentication to Azure
- Downloading build artifacts
- Deploying Azure Bicep templates.

**Azure Infrastructure Workflow (azure_infra.yml):** An example workflow to deploy your Azure infrastructure using Azure Bicep. It references the build and deploy workflows from a central pipeline repository and includes a trigger to run when changes are made to the main branch.

**Usage:**

To use the build, deploy, and Azure infrastructure workflows, follow these steps:

**Central Pipeline Repository Setup:**

1.  Copy `build.yml` to `.github/workflows/` directory.
2.  Copy `deploy.yml` to `.github/workflows/` directory.
3.  Commit to the main branch (or a branch of your choosing). Consider adding semantic versioning tags.

**Project Repository Setup:**

1.  Copy `azure_infra.yml` to `.github/workflows/` directory.
2.  Update the placeholder values in the workflow file with your project-specific values.
3.  Commit the changes to your project repository.
