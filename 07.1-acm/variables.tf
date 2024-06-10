variable "project" {
    type = string
    default = "expense"
  
}

variable "environment" {
    default = "dev"
  
}

variable "common_tags" {
    type = map 
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
        component = "backend"

    }
  
}

variable "zone_name" {
    default = "daws78s.site"
  
}
variable "zone_id" {
    default = "Z0163449Y0Q3IH42Y44X"
  
}