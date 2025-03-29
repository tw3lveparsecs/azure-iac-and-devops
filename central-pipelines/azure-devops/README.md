<!-- @format -->

This directory contains Azure DevOps examples for central pipelines to deploy your Azure infrastructure.

**Azure Pipelines:**

**Build Pipeline (build.yml):** Builds your Azure infrastructure. It includes:

- Azure Bicep linting
- Azure What-If deployment
- Publishing lint test results in JUnit format
- Uploading Bicep files as a build artifact for deployment workflows.

**Deploy Pipeline (deploy.yml):** Deploys your Azure Infrastructure. It includes:

- Downloading build artifacts
- Deploying Azure Bicep templates.

**Azure Infrastructure Workflow (azure_infra.yml):** An example Azure pipeline to deploy your Azure infrastructure using Azure Bicep. It references the build and deploy workflows from a central pipeline repository and includes a trigger to run when changes are made to the main branch.

**Usage:**

To use the build, deploy, and Azure infrastructure workflows, follow these steps:

**Central Pipeline Repository Setup:**

1.  Copy `build.yml` to a directory of your choice, e.g. `azure_pipelines/templates`.
2.  Copy `deploy.yml` to a directory of your choice, e.g. `azure_pipelines/templates`.
3.  Commit to the main branch (or a branch of your choosing). Consider adding semantic versioning tags.

**Project Repository Setup:**

1.  Copy `azure_infra.yml` to a directory of your choice, e.g. `azure_pipelines`.
2.  Update the placeholder values in the Azure pipeline file with your project-specific values.
3.  Commit the changes to your project repository.
