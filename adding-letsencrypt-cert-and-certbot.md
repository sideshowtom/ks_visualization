To get an SSL certificate from Let's Encrypt for Tableau Server, I had to run certbot with the manual plugin:

sudo snap install core
sudo snap refresh core
sudo apt-get remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo certbot certonly --manual -d your-domain-name --csr your-certificate.csr --preferred-challenges dns
