# Wordpress

This is a simple shell script which will help you to create a WordPress site using the latest WordPress Version by LEMP stack using docker .

Steps to execute the script

1. Download the script.sh file 
2. Run chmod +x script.sh to make it executable
3. Run sudo ./script.sh <abc.wordpress.com>

Firstly the script will check if docker and docker-compose is installed, if not it will install both 
Next it will create a docker-compose and run the file it will edit the /etc/hosts file so that we can access wordpress using localhost in browser
To access wordpress visit localhost:8080 and for nginx server visit localhost:80

Next the script allows you to enable or disable the site , by default it is set to enable we can change this using second argument

1. To enable the site
Run sudo ./script.sh <abc.wordpress.com> enable

2. To disable the site
Run sudo ./script.sh <abc.wordpress.com> disable

3. To delete files
Run sudo ./script.sh <abc.wordpress.com> delete
