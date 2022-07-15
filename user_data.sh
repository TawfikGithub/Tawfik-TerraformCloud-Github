#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "The page was created by Tawfik. With Ibrahim Moosi(bigHEAD) assisting" | sudo tee /var/www/html/index.html
EOF