variable "file_name" {
  type = string
}


data "http" "this" {
    # Note: even if we use http://example.org instead, the contents of both are the same.
    # On running tf plan or tf apply, opentofu first fetches the content of the website,
    # sees that both contents are the same and so, does not apply any changes to the current state.
    url = "https://example.com"
}


# Drift management: Let's say we run "tofu apply" and the file is created.
# Then, if we run tofu apply again, it'll detect that there are 0 resources added.
# However, if we delete the file, it'll detect that and add 1 resource (i.e. the file).
# The above is an example of "drift": the state of the infra is not what tofu thinks it is.
resource "local_file" "example_html_body" {
    content = data.http.this.response_body
    filename = "${var.file_name}.html"
}
