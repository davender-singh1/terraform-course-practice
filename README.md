# terraform-practice

# Installation

Linux

 sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform


# Day 1 - Terraform with Docker 🔥

Terraform needs to be told which provider to be used in the automation, hence we need to give the provider name with source and version.
For Docker, we can use this block of code in your main.tf

## Blocks and Resources in Terraform

## Terraform block

## Task-01

- Create a Terraform script with Blocks and Resources

```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.21.0"
}
}
}
```

### Note: kreuzwerker/docker, is shorthand for registry.terraform.io/kreuzwerker/docker.

## Provider Block

The provider block configures the specified provider, in this case, docker. A provider is a plugin that Terraform uses to create and manage your resources.

```
provider "docker" {}
```

## Resource

Use resource blocks to define components of your infrastructure. A resource might be a physical or virtual component such as a Docker container, or it can be a logical resource such as a Heroku application.

Resource blocks have two strings before the block: the resource type and the resource name. In this example, the first resource type is docker_image and the name is Nginx.

## Task-02

- Create a resource Block for an nginx docker image

Hint:

```
resource "docker_image" "nginx" {
 name         = "nginx:latest"
 keep_locally = false
}
```

- Create a resource Block for running a docker container for nginx

```
resource "docker_container" "nginx" {
 image = docker_image.nginx.latest
 name  = "tutorial"
 ports {
   internal = 80
   external = 80
 }
}
```

Note: In case Docker is not installed

`sudo apt-get install docker.io`
`sudo docker ps`
`sudo chown $USER /var/run/docker.sock`

![ngin](https://github.com/davender-singh1/terraform-course-practice/assets/106000634/056f3570-ced5-4f74-bbd4-18203cd411ee)


# Terraform Variables

variables in Terraform are quite important, as you need to hold values of names of instance, configs , etc.

We can create a variables.tf file which will hold all the variables.

```
variable "filename" {
default = "/home/ubuntu/terrform-tutorials/terraform-variables/demo-var.txt"
}
```

```
variable "content" {
default = "This is coming from a variable which was updated"
}
```

These variables can be accessed by var object in main.tf

## Task-01

- Create a local file using Terraform
  Hint:

```
resource "local_file" "devops" {
filename = var.filename
content = var.content
}
```

## Task-02

- Use terraform to demonstrate usage of List, Set and Object datatypes
  
## Data Types in Terraform

## Map

```
variable "file_contents" {
type = map
default = {
"statement1" = "this is cool"
"statement2" = "this is cooler"
}
}
```

## Object

```
variable "devops" {
        type = object({
        name = string
        items = list(number)
})

        default = {
        name = "shubham"
        items = [1,2,3,4]
}
}
```
## Outputs

output "devops-op" {
value = var.devops.name
}

output "devops-items" {
value = var.devops.items
}


![image](https://github.com/davender-singh1/terraform-course-practice/assets/106000634/da60d1b3-77d5-4b3a-bb35-3b77f97c214b)

Use `terraform refresh`

To refresh the state by your configuration file, reloads the variables
