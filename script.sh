#!/bin/bash

##Docker and Docker Compose
# Check if docker is installed
if ! [ -x "$(command -v docker)" ]; then
  # Install docker if not present
  echo 'Docker not installed. Installing Docker...'
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
fi

# Check if docker-compose is installed
if ! [ -x "$(command -v docker-compose)" ]; then
  # Install docker-compose if not present
  echo 'Docker-compose not installed. Installing Docker-compose...'
  curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi

# Check if installation was successful
if [ -x "$(command -v docker)" ] && [ -x "$(command -v docker-compose)" ]; then
  echo 'Docker and Docker-compose installed successfully!'
else
  echo 'Installation failed.'
fi

##End of Docker and Docker compose


# Check if the user provided a site name as a command-line argument
if [ -z "$1" ]; then
    echo "Please provide a site name as a command-line argument."
    exit 1
fi

# Set the site name
SITE_NAME=$1

# Create a directory for the WordPress site
mkdir -p $SITE_NAME
cd $SITE_NAME

# Create a docker-compose.yml file
cat > docker-compose.yml << EOF
version: '3'

services:
  db:
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: password
  wordpress:
    depends_on:
      - db
    image: wordpress
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: password
    ports:
      - 8080:80
  nginx:
    image: nginx
    depends_on:
      - wordpress
    ports:
      - 80:80
EOF

# Check if the first argument is blank
if [ -z "$2" ]; then
  # If no second argument is provided run script in enable mode
  # Start WordPress site using Docker Compose
  docker-compose -f docker-compose.yml up -d --quiet-pull

  # Add site_url to /etc/hosts file
  echo "127.0.0.1:8080 $1" >> /etc/hosts

  # Open the website in Firefox
  firefox http://$1:8080
fi

# Define a function to enable the site
function enable_site() {
    # Start the containers
    docker-compose up -d
    firefox http://$1:8080
    # Print a success message
    echo "Site enabled!"
}

# Define a function to disable the site
function disable_site() {
    # Stop the containers
    docker-compose stop

    # Print a success message
    echo "Site disabled!"
}

# Define a function to delete the site
function delete_site() {
    # Stop the containers
    docker-compose stop

    # Delete the local files
    rm -rf ../$SITE_NAME
    docker rmi -f $(docker images -a -q)
    # Print a success message
    echo "Site deleted!"
}

# Check if the first argument is "enable", "disable", or "delete"
if [ "$2" == "enable" ]; then
    # Enable the site
    enable_site
elif [ "$2" == "disable" ]; then
    # Disable the site
    disable_site
elif [ "$2" == "delete" ]; then
    # Delete the site
    delete_site
fi
