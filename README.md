# Getting a basic Terraform Lambda going

Commands: 

`GOOS=linux GOARCH=amd64 go build -o hello`

`zip hello.zip hello`

`terraform apply`

`terraform destory`


Test:

`curl -fsSL $(terraform output url)?name=world` || `curl -fsSL $(terraform output url)?name=lambda`
