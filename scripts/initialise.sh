#!/bin/sh

#
# This script fetches the People Finder source
# from Github, and configures appropriately.
#
# /etc/profile.d/environment.sh must be appropriately
# set with the necessary environment variables, including;
#
# $APP_ROOT; e.g. relative path to app directory
# $ROLE; e.g. "worker", or "app"
# $GIT_BRANCH; e.g. "master"

# Source appropriate profiles
. /etc/profile.d/rvm.sh
. /etc/profile.d/environment.sh

# Remove app home
rm -rf $APP_ROOT

# Clone branch from Github
su - ubuntu -c "git clone -b $GIT_BRANCH https://github.com/cabinetoffice/peoplefinder.git $APP_ROOT"

# Install and precomile
cd $APP_ROOT
su - ubuntu -c "cd $APP_ROOT; bundle install"
su - ubuntu -c "cd $APP_ROOT; bundle exec rake assets:precompile RAILS_ENV=assets"

# Assign permissions
chmod -R 755 $APP_ROOT/tmp

# Trust CO root certificate authority
cp /etc/ssl/ca.crt /usr/local/share/ca-certificates
update-ca-certificates

# Generate upstart scripts and install
foreman export upstart --app=peoplefinder --user=ubuntu /etc/init.d

# Copy nginx scripts, replacing if required
rm /etc/nginx/sites-enabled/default
cp -f $APP_ROOT/scripts/nginx/nginx.conf /etc/nginx/nginx.conf
cp -f $APP_ROOT/scripts/nginx/peoplefinder.conf /etc/nginx/sites-available/peoplefinder.conf
cp -f $APP_ROOT/scripts/nginx/peoplefinder-ssl.conf /etc/nginx/sites-available/peoplefinder-ssl.conf
ln -s /etc/nginx/sites-available/peoplefinder.conf /etc/nginx/sites-enabled/peoplefinder.conf
ln -s /etc/nginx/sites-available/peoplefinder-ssl.conf /etc/nginx/sites-enabled/peoplefinder-ssl.conf

# Proceed based on instance role
if [ $ROLE = "app" ]
then
	# Automatically launch web process at boot
	update-rc.d peoplefinder-web defaults
	# Start peoplefinder-web and restart nginx
	service peoplefinder-web start
	service nginx reload
	service nginx restart
elif [ $ROLE = "worker" ]
then
	# Automatically launch worker processes at boot
	update-rc.d peoplefinder-clock defaults
	update-rc.d peoplefinder-worker defaults
	# Stop nginx and the web process
	service nginx stop
	service peoplefinder-web stop
	# Start the clock and worker processes
	service peoplefinder-clock start
	service peoplefinder-worker start
elif [ $ROLE = "hybrid" ]
	# Automatically launch all processes at boot
	update-rc.d peoplefinder defaults
	service peoplefinder start
	service nginx reload
	service nginx restart
fi