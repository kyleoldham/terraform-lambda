# Getting a basic Terraform Lambda going

### Commands: 
- `GOOS=linux GOARCH=amd64 go build -o hello`
- `terraform apply`
- `terraform destory`

### Test:
- `curl -fsSL $(terraform output url)?name=world`
- `curl -fsSL $(terraform output url)?name=lambda`

## Literally just use this and implement the ones you need lol
https://registry.terraform.io/browse?provider=aws

TODO: 
- Make Environment folders for more thorough testing
- VPC + Subnet deployment
- Terragrunt Implimentation
