#!/bin/sh
# The lab's IAM principals exist: the privesc users and the 31 privesc paths' roles.
set -eu
for u in privesc1-CreateNewPolicyVersion-user privesc21-PassExistingRoleToNewDataPipeline-user fp1-allow-and-deny-user; do
  aws iam get-user --user-name "$u" --query User.UserName --output text >/dev/null
done
roles=$(aws iam list-roles --query "length(Roles[?starts_with(RoleName, 'privesc')])" --output text)
[ "$roles" -ge 31 ] || { echo "only $roles privesc roles" >&2; exit 1; }
aws iam get-role --role-name "${ISOLOOM_OUTPUT_FIRST_ROLE##*/}" --query Role.Arn --output text >/dev/null
