---
name: project-portfolio-terraform-baseline
description: Baseline security posture of terraform/ for the static portfolio site (S3 + CloudFront), and known open gaps as of last audit
metadata:
  type: project
---

Audited terraform/{providers,variables,main,outputs,backend}.tf on 2026-07-21. This is a minimal static-site stack (S3 origin + CloudFront + OAC), no IAM roles/policies and no OIDC trust policy defined in these files yet (so IAM/OIDC checklist items don't currently apply — re-check if a CI/CD deploy role or GitHub Actions OIDC provider is added later).

Already done well (don't re-flag as new issues, just confirm still present):
- S3 bucket uses `aws_s3_bucket_public_access_block` with all four flags true.
- `aws_s3_bucket_ownership_controls` set to `BucketOwnerEnforced` (ACLs disabled).
- CloudFront uses OAC (`aws_cloudfront_origin_access_control`), not legacy OAI.
- S3 bucket policy scoped to CloudFront service principal with `AWS:SourceArn` condition tied to the specific distribution ARN (least privilege, not a wildcard).
- `viewer_protocol_policy = "redirect-to-https"` on the default cache behavior.
- No hardcoded account IDs/ARNs/secrets found in any file.

Open gaps found at this audit (recommend re-checking on next pass to see if fixed):
- No `aws_s3_bucket_server_side_encryption_configuration` for the site bucket.
- No `aws_s3_bucket_versioning` for the site bucket.
- No S3 access logging or CloudFront `logging_config` block.
- `viewer_certificate` only sets `cloudfront_default_certificate = true`, no explicit `minimum_protocol_version` (defaults to weak TLSv1) and no ACM cert wired up even though `var.domain_name`/`aliases` exist — will break at apply time if a custom domain is ever set, since CloudFront requires ACM for custom domains.
- No CloudFront response headers policy (no CSP, X-Frame-Options, HSTS, etc.).
- No WAF association on the distribution.
- `backend.tf` remote state (S3) is intentionally commented out pending manual bootstrap; the bootstrap `aws s3api create-bucket` command in the comments does not enable versioning, default encryption, or a public access block on the tfstate bucket itself — worth flagging if/when that bootstrap actually happens.

**Why:** captured so future audits of this repo can quickly diff "still open" vs "newly introduced" issues instead of re-deriving the whole picture from scratch.
**How to apply:** when re-auditing terraform/ in this repo, check whether each open gap above has been remediated before treating it as a fresh finding; also check whether IAM/OIDC resources have been added (this repo's CLAUDE.md mentions GitHub Actions automation, so a deploy role is likely to appear eventually).
