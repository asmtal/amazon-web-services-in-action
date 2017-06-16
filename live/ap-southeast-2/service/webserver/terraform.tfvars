terragrunt = {
  terraform {
    source = "../../../../modules/service/webserver"

    extra_arguments "custom_vars" {
      commands = [
        "apply",
        "apply-all",
        "plan",
        "plan-all", 
        "destroy", 
        "destroy-all", 
        "import",
        "push",
        "refresh"
      ]

      # This allows us to put common variables (like env) in the root and
      # refer to it via relative paths.
      arguments = [
        "-var-file=${get_tfvars_dir()}/../../common.tfvars",
        "-var-file=terraform.tfvars"
      ]
    }



  }

  # This looks for terraform.tfvars in its parent folders. It uses the first one it finds. Since
  # we store state info in the root, this allows us to DRY state.
  include {
    path = "${find_in_parent_folders()}"
  }
}