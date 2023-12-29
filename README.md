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


# Day 2 - Terraform with AWS

Provisioning on AWS is quite easy and straightforward with Terraform.

## Prerequisites

### AWS CLI installed

The AWS Command Line Interface (AWS CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts.

### AWS IAM user

IAM (Identity Access Management) AWS Identity and Access Management (IAM) is a web service that helps you securely control access to AWS resources. You use IAM to control who is authenticated (signed in) and authorized (has permissions) to use resources.

_In order to connect your AWS account and Terraform, you need the access keys and secret access keys exported to your machine._

```
export AWS_ACCESS_KEY_ID=<access key>
export AWS_SECRET_ACCESS_KEY=<secret access key>
```

### Install required providers

```
terraform {
 required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.16"
}
}
        required_version = ">= 1.2.0"
}
```

Add the region where you want your instances to be

```
provider "aws" {
region = "us-east-1"
}
```
## Task 1: Create a security group

To allow traffic to the EC2 instance, you need to create a security group. Follow these steps:

In your main.tf file, add the following code to create a security group:

```
resource "aws_security_group" "web_server" {
  name_prefix = "web-server-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

## Task-02 - Provision an AWS EC2 instance using Terraform

```
resource "aws_instance" "aws_ec2_instance" {
        count = 5
        ami = "ami-08c40ec9ead489470"
        instance_type = "t2.micro"
        tags = {
     Name = "TerraformwithAWS"
  }
}
```

![ec2 running](https://github.com/davender-singh1/terraform-course-practice/assets/106000634/01e0fa64-7271-4b25-b141-605ffa8a275b)



## Task-03 - Get the Public IPs for the provisioned instances

```
output "instance_pub_ip" {
        value = aws_instance.aws_ec2_test[*].public_ip
}
```


![terra](https://github.com/davender-singh1/terraform-course-practice/assets/106000634/d9680f68-6f50-4655-91ed-005cbc71b0fc)


## Task-4 - AWS S3

For s3, the bucket name should be unique

```
resource "aws_s3_bucket" "my_s3_bucket" {
	bucket = "terraform-davender1366-123"
	tags = {
	Name = "terraform-davender1366-123"
        Environment = "Dev"
}
}
```

![bucket_terra](https://github.com/davender-singh1/terraform-course-practice/assets/106000634/affb353e-615c-42b3-8a64-24f316994ac7)

# Day 3 - Meta-Arguments in Terraform

When you define a resource block in Terraform, by default, this specifies one resource that will be created. To manage several of the same resources, you can use either count or for_each, which removes the need to write a separate block of code for each one. Using these options reduces overhead and makes your code neater.

count is what is known as a ‘meta-argument’ defined by the Terraform language. Meta-arguments help achieve certain requirements within the resource block.

## Count

The count meta-argument accepts a whole number and creates the number of instances of the resource specified.

When each instance is created, it has its own distinct infrastructure object associated with it, so each can be managed separately. When the configuration is applied, each object can be created, destroyed, or updated as appropriate.

eg.

```

terraform {

required_providers {

aws = {

source = "hashicorp/aws"

version = "~> 4.16"

}

}

required_version = ">= 1.2.0"

}



provider "aws" {

region = "us-east-1"

}



resource "aws_instance" "server" {

count = 4



ami = "ami-08c40ec9ead489470"

instance_type = "t2.micro"



tags = {

Name = "Server ${count.index}"

}

}



```

## for_each

Like the count argument, the for_each meta-argument creates multiple instances of a module or resource block. However, instead of specifying the number of resources, the for_each meta-argument accepts a map or a set of strings. This is useful when multiple resources are required that have different values. Consider our Active directory groups example, with each group requiring a different owner.

```

terraform {
required_providers {
	aws = {
	source = "hashicorp/aws"
	version = "~> 4.16"
}
}
	required_version = ">= 1.2.0"
}

provider "aws" {
	region = "us-east-1"
}

locals {
	instances = {"Devender":"ami-079db87dc4c10ac91","Daven":"ami-0c7217cdde317cfec","Mohit":"ami-0c7217cdde317cfec","Monu":"ami-079db87dc4c10ac91"}
}

resource "aws_instance" "aws_ec2_test" {
        for_each = local.instances
        ami = each.value
        instance_type = "t2.micro"
        tags = {
     Name = each.key
  }
}



#Multiple key value iteration

locals {

ami_ids = {

"linux" :"ami-0b0dcb5067f052a63",

"ubuntu": "ami-08c40ec9ead489470",

}

}



resource "aws_instance" "server" {

for_each = local.ami_ids



ami = each.value

instance_type = "t2.micro"



tags = {

Name = "Server ${each.key}"

}

}

```


# Day 4 - Terraform State Management

1. Remote Backends
2. State Locking


## Terraform State commands:

terraform state list : List resources within terraform state. 

terraform-state mv : Move items within terraform state. This will be used to resource renaming without destroy, apply command 

terraform state pull : Manually download and output the state from the state file. 

terraform state push : Manually upload a local state file to the remote state

terraform state rm : Remove items from the state. Items removed from the state are not physically destroyed. This item no longer managed by Terraform. 

terraform state show: Show attributes of a single resource in the state.


## States:

Terraform uses state to keep track of the infrastructure it manages. To use Terraform effectively, you must keep your state accurate and secure.


State Locking:

State locking happens automatically on all operations that could write state. You won’t see any message that it is happening. If state locking fails, terraform will not continue. You can disable state locking in most commands with the -lock flag but it is not recommended.
Terraform has a force-unlock command to manually unlock the state if unlocking failed.
Syntax: terraform force-unlock [options] LOCK_ID [DIR]

Backend Management:

A backend in Terraform determines how state is loaded and how an operation such as apply is executed
Terraform must initialize any configured backend before use.

Local:

By default, terraform uses the “local” backend. After running first terraform apply the terraform.tfstate file created in the same directory of main.tf
terraform.tfstate file contains JSON data.

The local backend stores state on the local filesystem, locks the state using system APIs, and performs operations locally

```
terraform {
backend "local" {
path = "relative/path/to/terraform.tfstate"
}
}
```


![tf state using s3](https://github.com/davender-singh1/terraform-course-practice/assets/106000634/cc09dcf6-103b-4261-b0a1-9dd02c7332b0)


