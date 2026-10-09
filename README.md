# IAM Vulnerable

[IAM Vulnerable](https://github.com/BishopFox/iam-vulnerable) by Seth Art and Bishop Fox: an AWS
IAM privilege escalation playground. This repository runs it with
[Isoloom](https://www.isoloom.com) in your own AWS account: [`isoloom.yml`](isoloom.yml)
describes the cloud services, upstream's Terraform sits unchanged in [`app/`](app), and
[`terraform/`](terraform) is a small wrapper that applies its free modules.

| Cloud services | What |
| --- | --- |
| IAM (free) | 31 privilege escalation paths: a user and a role per path (`privesc<N>-<technique>-role`), plus `fp*`/`fn*` principals for testing tools |

Cost: IAM only, nothing billed.

## Run it

Use an AWS account with nothing else in it, signed in with the AWS CLI (`aws login`), and
Terraform installed.

```bash
isoloom run cloud-services     # creates the IAM resources and prints where to start
isoloom test cloud-services
isoloom down cloud-services    # deletes everything the lab created
```

Every lab role trusts the principal that deployed it. An account's root user can't assume roles:
deploy as, or assume from, an IAM user or role. Lab guides:
[IAM Vulnerable: an AWS IAM privilege escalation playground](https://labs.bishopfox.com/tech-blog/iam-vulnerable-an-aws-iam-privilege-escalation-playground)
and [privilege escalation in AWS](https://labs.bishopfox.com/tech-blog/privilege-escalation-in-aws).

Upstream version and commit: [UPSTREAM.md](UPSTREAM.md).

## Licence

MIT, as IAM Vulnerable ([LICENSE](LICENSE)). This lab is deliberately vulnerable: deploy it only
in an account you use for nothing else, and destroy it when you are done.
