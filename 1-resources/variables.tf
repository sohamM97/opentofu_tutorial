# Variables can be supplied through:
# tofu apply -var=greeting="Hello"
# Or: tofu apply -var-file=prod.tfvars

# Note: this file is where the variables are defined, while prod.tfvars
# (or basically, any file with the tfvars extension) is where you specify the actual values
variable "greeting" {
    type = string
    description = "How to greet the folks"
}


variable "html_file_name" {
    type = string
    description = "Name of the HTML file"
}