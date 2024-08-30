terraform {
    cloud {
      organization  = "TCS_BG"
      workspaces {
        name   = "terraform-cloud-org"
      }
    }
}

provider "tfe" {
    hostname = "app.terraform.io"
    token    =  var.tfe_token
}

variable "organization_name" {
    description = "Existing TFC Organization"
    type        = string  
}

resource "tfe_organization" "test-organization" {
  name  = "TCS_BG"
  email = "omkar.singh1@tcs.com"
}

resource "tfe_oauth_client" "test" {
  organization     = tfe_organization.test-organization
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = "oauth_token_id"
  service_provider = "github"
}

resource "tfe_workspace" "parent" {
  name                 = "parent-ws"
  organization         = tfe_organization.test-organization
  queue_all_runs       = false
  vcs_repo {
    branch             = "main"
    identifier         = "my-org-name/vcs-repository"
    oauth_token_id     = tfe_oauth_client.test.oauth_token_id
  }
}