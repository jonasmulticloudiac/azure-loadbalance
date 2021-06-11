## Saving ssh-key into file called private_key.pem
# resource "local_file" "private_key" {
#     content  =  tls_private_key.SSHtftec.private_key_pem
#     filename = "./ssh/priv-ssh-key.pem"
# }


output "ip_public_lb" {

  value = azurerm_public_ip.PUBIPtftec.ip_address

}




