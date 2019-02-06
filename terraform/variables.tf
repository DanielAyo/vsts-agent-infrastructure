variable "rg_group_name" {
  default = "aci-rg"
}

variable "location" {
  default = "northeurope"
}
variable "share_name" {
  default = "aci-share"
}

variable "container_image" {
  default = "danielayo/vsts-agent-infrastructure"
}
variable "vsts-account" {
  default = ""
}

variable "vsts-token" {
  default = ""
}

variable "vsts-agent" {
  default = "ACI-Agent"
}

variable "vsts-pool" {
  default = "ACI-Pool"
}
