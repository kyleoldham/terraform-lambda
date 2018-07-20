# Getting a basic Terraform Lambda going

Commands: <br/ >
GOOS=linux GOARCH=amd64 go build -o hello <br/ >
zip hello.zip hello <br/ >
terraform apply <br/ >
terraform destroy <br/ >

Test: <br/ >
curl -fsSL $(terraform output url)?name=world || curl -fsSL $(terraform output url)?name=lambda
