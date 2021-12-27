resource "null_resource" "test" {

}

resource "null_resource" "validate" {

}

output "test" {
  value = null_resource.test.id
}

output "validate" {
  value = null_resource.validate.id
}
