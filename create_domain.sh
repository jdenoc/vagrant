#!/bin/bash

BUILD_INDEX=true;
DOMAIN="";
DIRECTORY="";
VHOST_DIRECTORY=false;

function usage_alert {
   echo "Usage: $0 [-d|--domain] <Domain> [-f|--folder] <DocumentRoot> [--no-index] [--vhost-directory]";
   exit;
}

# input checking
if [[ $# < 1 ]]; then #make sure that arguments were passed
    usage_alert
fi

while [[ $# > 0 ]]
do
    i="$1"
    case $i in
        "--no-index")
            BUILD_INDEX=false;
            shift #move beyond argument $1
            ;;
        "-d"|"--domain")
            DOMAIN="$2";
            shift #move beyond argument $1
            shift #move beyond argument $2
            ;;
        "-f"|"--folder")
            DIRECTORY="$2";
            shift #move beyond argument $1
            shift #move beyond argument $2
            ;;
        "--vhost-directory")
            VHOST_DIRECTORY=true
            shift #move beyond argument $1
            ;;
        *|"") #unrecognised parameters - catch all
            usage_alert
    esac
done

if [ -z "$DOMAIN" ]; then
    echo "Please enter a domain to create";
    usage_alert
elif [ -z "$DIRECTORY" ]; then
    echo "Please enter domain DocumentRoot"
    echo "  e.g.: /var/www/domain/";
    usage_alert
elif [[ ! -d "$DIRECTORY" ]]; then
    echo "$DIRECTORY doesn't exist";
    usage_alert
fi


# write to /etc/hosts
echo "127.0.0.1    $DOMAIN" >> /etc/hosts

# Create a log directory
LOG_DIR="/var/log/httpd/$DOMAIN"
if [ ! -d $LOG_DIR ]; then
    mkdir -p $LOG_DIR;
    chown -R vagrant:apache $LOG_DIR
fi;

# Write a vhost entry
VHOST_FILE="/etc/httpd/conf.d/vhost-$DOMAIN.conf"
echo "# file: $VHOST_FILE" >> $VHOST_FILE
echo "# domain: $DOMAIN" >> $VHOST_FILE
echo "<VirtualHost *:80>" >> $VHOST_FILE
echo "    ServerAdmin jdenoc@gmail.com" >> $VHOST_FILE
echo "    DocumentRoot \"$DIRECTORY\"" >> $VHOST_FILE
echo "    ServerName $DOMAIN" >> $VHOST_FILE
echo "    ServerAlias *.$DOMAIN" >> $VHOST_FILE
echo "    ErrorLog \"$LOG_DIR/apache_error.log\"" >> $VHOST_FILE
echo "    CustomLog \"$LOG_DIR/apache_access.log\" common" >> $VHOST_FILE
if $VHOST_DIRECTORY; then
    echo "    <Directory \"$DIRECTORY\">" >> $VHOST_FILE
    echo "        Options Indexes FollowSymLinks" >> $VHOST_FILE
    echo "        AllowOverride all" >> $VHOST_FILE
    echo "        Allow from all" >> $VHOST_FILE
    echo "    </Directory>" >> $VHOST_FILE
fi
echo "</VirtualHost>" >> $VHOST_FILE

if $BUILD_INDEX; then
    # Write an index.html file
    echo "<html>" >> $DIRECTORY/index.html
    echo "    <head><title>$DOMAIN</title></head>" >> $DIRECTORY/index.html
    echo "    <body><h1>Welcome</h1><p>$DOMAIN</p></body>" >> $DIRECTORY/index.html
    echo "</html>" >> $DIRECTORY/index.html
fi

# Restart apache
service httpd restart

# Display reminder
echo "Don't forget to update your VagrantFile..."