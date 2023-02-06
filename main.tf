resource "random_id" "randomprefix" {
  byte_length = 4
}

module "terraform" {
  source = "./modules/terraform"
  
  location = var.resource_group_location
  stage = "PROD"
  replication = "LRS"
  random = random_id.randomprefix.hex
}

module "resourcegroups" {
  source = "./modules/resourcegroups"
  
  location = var.resource_group_location
  stage = "PROD"
}