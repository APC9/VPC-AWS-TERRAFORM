locals {
  owners     = var.owners
  enviroment = var.enviroment
  name       = "${local.owners}-${local.enviroment}"

  tags = {
    owners     = local.owners
    enviroment = local.enviroment
  }
}
