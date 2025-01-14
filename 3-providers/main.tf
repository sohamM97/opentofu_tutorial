# WARNING: Renaming a resource after it's already been applied, will cause terraform
# to try to destroy it and create a new one. This can be averted by changing
# the name in the state as well. We can use tofu state mv command for that.


resource "aws_s3_bucket" "bucket" {
    # By default, it uses the account and region set up in ~/.aws/credentials
    bucket = "opentofu-tutorial"

}


data "aws_caller_identity" "current" {}


resource "local_file" "forwards" {
    content = data.aws_caller_identity.current.arn
    filename = "forwards.txt"
}


# Let's say we want to store the arn reversed in another file.
# There is no function to reverse a string in opentofu, but there are to split a string
# into a list, reverse it and join it back into a string. We do this inside the "locals" block.
locals {
  char_list = split("", local_file.forwards.content)
  reversed_char_list = reverse(local.char_list)
  reversed_string = join("", local.reversed_char_list)
}


resource "local_file" "backwards" {
    content = local.reversed_string
    filename = "backwards.txt"
}


resource "aws_s3_object" "forwards" {
    bucket = aws_s3_bucket.bucket.bucket
    key = local_file.forwards.filename
    source = local_file.forwards.filename
}


resource "aws_s3_object" "backwards" {
    bucket = aws_s3_bucket.bucket.bucket
    key = local_file.backwards.filename
    source = local_file.backwards.filename
}