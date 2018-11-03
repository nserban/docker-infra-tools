# docker-infra-tools
Docker Image containing infrastructure tools ( Ansible, Terraform, Packer )

## Build
```
$ docker build -t infra-tools .
```

## Usage
```
$ docker run -it --rm infra-tools ansible --version ; packer version ; terraform version
```
