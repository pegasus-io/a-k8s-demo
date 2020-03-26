output "vm_id" {
    value = "${aws_instance.creshVM.id}"
}
output "ssh_finger_print" {
    value = "${aws_key_pair.fingerprint}"
}
output "ssh_pub_key" {
    value = "${aws_key_pair.fingerprint}"
}
