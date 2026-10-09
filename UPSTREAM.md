# Upstream

| | |
| --- | --- |
| Project | IAM Vulnerable |
| Repository | https://github.com/BishopFox/iam-vulnerable |
| Version | main (no releases) |
| Commit | 0f298666f9b7cfa01488b86912afdb211773188a |
| Licence | MIT |

`app/` is that commit, unchanged, without its Git history. `terraform/main.tf` is this lab's own
wrapper root module: it applies upstream's two free modules (`privesc-paths`, `tool-testing`) as
upstream's `app/main.tf` does, but takes the AWS credentials from the environment (Isoloom passes
the `aws login` session) instead of the named profile upstream's provider block requires, tags
every resource, and adds outputs (account, deployer, first role). Upstream's non-free modules
(Lambda, EC2, Glue, SageMaker, CloudFormation) stay off, as upstream ships them. To update,
replace `app/` with a newer commit and change this table.
