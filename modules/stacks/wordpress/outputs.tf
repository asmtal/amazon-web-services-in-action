output "wordpress_url" {
  value = "this_should be the url"
  value = "${aws_cloudformation_stack.wordpress_stack.outputs["URL"]}"
}
