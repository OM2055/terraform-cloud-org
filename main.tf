terraform {
  cloud {
    organization = "TCS_BG"
    workspaces {
      name = "terraform-cloud-org"
    }
  }
}

# Declare the TFE provider
provider "tfe" {
  hostname = "app.terraform.io"
  token    = var.tfe_token
}

# Declare the variable for the TFE token
variable "tfe_token" {
  description = "The API token for Terraform Cloud."
  type        = string
  sensitive   = true
}

# Variable for organization name (if needed in other parts of your code)
variable "organization_name" {
  description = "Existing TFC Organization"
  type        = string
  default     = "TCS_BG"
}

# Create a Terraform Cloud organization (Optional if it already exists)
resource "tfe_organization" "test-organization" {
  name  = "TCS_BG"
  email = "omkar.singh1@tcs.com"
}

# Create an OAuth client for VCS integration
resource "tfe_oauth_client" "test" {
  organization     = tfe_organization.test-organization.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = "your-oauth-token"
  service_provider = "github"
}

# Create a workspace with VCS integration
resource "tfe_workspace" "parent" {
  name         = "parent-ws"
  organization = tfe_organization.test-organization.name
  queue_all_runs = false

  vcs_repo {
    branch         = "main"
    identifier     = "my-org-name/vcs-repository"
    oauth_token_id = tfe_oauth_client.test.oauth_token_id
  }
}
