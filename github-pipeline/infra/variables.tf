variable "github_connection_arn" {
  description = "The ARN of the GitHub CodeStar connection"
  type        = string
}

variable "github_repo_fullname" {
  description = "GitHub repo in format owner/repo"
  type        = string
}

variable "github_branch" {
  description = "Branch to track (default main)"
  type        = string
  default     = "main"
}
