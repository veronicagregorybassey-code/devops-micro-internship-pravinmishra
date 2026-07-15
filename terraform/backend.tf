# -----------------------------------------------------------------------------
# Remote state backend (S3)
#
# Terraform cannot create its own state bucket while also using it as a backend,
# so bootstrap the state in two steps:
#
#   1. First run — keep this backend block COMMENTED OUT. Run:
#          terraform init
#          terraform apply
#      This creates the infrastructure using local state.
#
#   2. Create an S3 bucket to hold remote state (once), e.g.:
#          aws s3api create-bucket --bucket portfolio-site-tfstate \
#            --region ap-south-1 \
#            --create-bucket-configuration LocationConstraint=ap-south-1
#
#   3. Uncomment the block below, fill in your bucket name, then migrate:
#          terraform init -migrate-state
#      Terraform will copy the local state into S3.
# -----------------------------------------------------------------------------

# terraform {
#   backend "s3" {
#     bucket       = "portfolio-site-tfstate"
#     key          = "portfolio-site/terraform.tfstate"
#     region       = "ap-south-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }
