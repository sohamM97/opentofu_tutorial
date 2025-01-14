# This is the main.tf file which is typically the first file we create in a new project.
# Eventually, we can go ahead with other files once this file starts becoming larger.
# For example, a new file called variables.tf where we define just the variables
# (earlier, even those were in main.tf)


# "local_file" is the resource type, "example" is the name we have given to it
# The provider which provides "local_file" is "registry.opentofu.org/hashicorp/local"
# You can view this in the terraform lock file which got created when we ran
# tofu init
resource "local_file" "main" {
    # "content", "filename" are the attributes and beside them, their corresponding values
    content = "${var.greeting}, World!"
    filename = "${path.module}/example.txt"
}


# This is from provider "registry.opentofu.org/hashicorp/http"
# After adding this, we need to run tofu init -upgrade for this to reflect in the lock file
data "http" "this" {
    # Note: even if we use http://example.org instead, the contents of both are the same.
    # On running tf plan or tf apply, opentofu first fetches the content of the website,
    # sees that both contents are the same and so, does not apply any changes to the current state.
    url = "https://example.com"
}


resource "local_file" "example_html_body" {
    content = data.http.this.response_body
    filename = "${path.module}/${substr(var.html_file_name, 0, 8)}.html"
}


resource "local_file" "other" {
    content = local_file.main.content
    filename = "${path.module}/other.txt"
}