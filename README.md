# Tableau Server Single Node: Tableau Server (trial version) on Azure Ubuntu VM

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsideshowtom%2Fks_visualization%2Fmain%2Fazuredeploy.json)

This is based on https://github.com/Azure/azure-quickstart-templates/tree/master/tableau-server-single-node, but is specific to Linux

**To deploy this to Azure and use your domain name and SSL certificate:**

Choose a domain name vendor and an SSL/TLS certificate vendor.

Create an empty resource group in your Azure account

Deploy the Azure template with the button above, you will need to fill out some fields

then after the deployment succeeds:

set your IP address as static instead of dynamic.  To do this go to the Public IP address of the VM in Azure and change it to static and save it. 

Then go back and tell your domain name vendor of the static IP address that Azure gave you.  To do that you would add or change an 'A' record that connects the domain name to the IP address.

You may have to wait until the domain name/ip address matching is set up and propagated on the web.  You can check it here https://whatsmydns.net

To get to a command line on the VM, from a terminal window do:

(if you've done this before, you may already have your domain name in your known_hosts, and you'll have to remove it or you'll get a nasty warning when you try to do ssh-copy-id to a known_host.  To remove it, do
*ssh-keygen -f "/home/your-user-name/.ssh/known_hosts" -R "your-domain-name"*)

*ssh-copy-id vm-user-name\@your-domain-name*

It will ask you to verify the server.  If the IP address matches, say yes. Then it will prompt you for your VM user password.

After that you can type:

*ssh vm-user-name\@your-domain-name*

from a terminal window to get to a command line on the VM.

Now you can start to get the SSL certificate installed.  From the command line on the VM:

*openssl genrsa -out cert-file-name.key 4096*

then

*openssl req -new -key cert-file-name.key -out cert-file-name.csr*

then, give the .csr file (certificate signing request file) to your SSL certificate vendor, and they will give you back two .crt files, the larger of which is the key chain file

Then, from the command line on the VM, tell Tableau Services Manager about the certificate:

*tsm security external-ssl enable --cert-file path-to-cert-file.crt --key-file path-to-key-file.key --chain-file path-to-chain-file.crt*

then,

*tsm authentication trusted configure -th https://your-domain-name*

Then, open a browser and go to https://your-domain-name:8850.  You will get a warning that the SSL certificate is not trusted because it is self signed by Tableau, but you can accept the risk and proceed past it.  Then login to Tableau Services Manager as the vm admin user.  There in tableau services manager in the browser, you can apply the pending changes and start the server on the upper right

once all 33 services are started...

then from the command line in the VM:

*tabcmd initialuser --server https://localhost --username 'tableau-server-admin-name' --no-certcheck*

It will prompt you for a password.  This will be the tableau server administrator password.

Now you can go to your Tableau server (different from the Tableau Services Manager)
https://your-domain-name
and by not including the port number it defaults to 443 since its SSL.
You can log in there with 'tableau-server-admin-name' and its password.

Now you should have two browser tabs open, one for Tableau Server and one for Tableau Services Manager.

You can restrict traffic to the VM to specific IP addresses or lists or ranges of IP addresses with the inbound port rules in the network interface for the VM.  This can be done in the Azure portal.

