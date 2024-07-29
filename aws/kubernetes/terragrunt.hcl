##
# (c) 2022-2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  local_vars   = yamldecode(file("./inputs.yaml"))
  base_vars    = yamldecode(file("./inputs-global.yaml"))
  release_vars = yamldecode(file("./release.yaml"))
  global_vars  = yamldecode(file(find_in_parent_folders("global-inputs.yaml")))
  values_file   = "./helm-values.yaml"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/cloudopsworks/terraform-module-aws-eks-helm-deploy.git//?ref=master"
}

inputs = {
  org = {
    organization_name = local.base_vars.organization_name
    organization_unit = local.base_vars.repository_owner
    environment_name  = local.base_vars.environment_name
    environment_type  = local.base_vars.namespace
  }
  repository_owner = local.base_vars.repository_owner
  region           = local.global_vars.default.region
  sts_assume_role  = local.global_vars.default.sts_role_arn
  release          = local.release_vars.release
  namespace        = local.release_vars.namespace
  cluster_name     = local.local_vars.cluster_name
  helm_repo        = local.local_vars.helm_repo
  helm_chart       = local.local_vars.helm_chart
  values_file       = local.values_file
  values           = local.local_vars.values
  absolute_path    = get_terragrunt_dir()
  extra_tags       = try(local.local_vars.tags, {})
}