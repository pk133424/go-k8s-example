check_install:
	which swagger || brew install go-swagger

generate_swagger: check_install
	swagger generate spec -o ./swagger.yaml --scan-models

redoc:generate_swagger
	swagger serve --flavor=redoc swagger.yaml

swagger:generate_swagger
	swagger serve --flavor=swagger swagger.yaml
deploy:
	GOOS=linux GOARCH=386 go build
## Run Project
tidy:
	go mod tidy
build:tidy
	go build
run:build
	./Go_K8S
