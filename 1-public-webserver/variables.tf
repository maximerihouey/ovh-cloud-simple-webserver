variable "open_stack_user_name" {
  # env var: TF_VAR_open_stack_user_name
  type = string
}

variable "open_stack_password" {
  # env var: TF_VAR_open_stack_password
  type = string
}

variable "ssh_key_location" {
  type    = string
  default = "~/.ssh/id_rsa_ovh.pub"
}
