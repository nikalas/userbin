#!/usr/bin/env bash

# Load .env file
set -a
source $HOME/bin/config/.env
set +a

# get sitename if not set as first argument
if (($#))
then
    SITENAME=$1
else
    echo "What's the url of the new local site, without the 'https://local' ?"
    read -p "ex. site.com: " SITENAME
fi

echo " :: Creating site..."
# create site dir and enter it
mkdir local."$SITENAME"
cd local."$SITENAME"

SITE_PATH=`pwd`

# install wordpress, --skip-content skips all default themes and plugs
# (i.e. twentytwentyon and akismet etc.)
wp core download --skip-content

# set up wp-config.php
echo "define( 'ACF_PRO_LICENSE', '$ACF_PRO_LICENSE' );
define( 'GF_LICENSE_KEY', '$GRAVITY_FORMS_LICENSE' );" |
wp config create \
--dbhost="$DBHOST" \
--dbuser="$DBUSER" \
--dbpass="$DBPASS" \
--dbname="$SITENAME" \
--extra-php

# create the database
wp db create

# install wordpress to the database
wp core install \
--url="local.$SITENAME"       \
--admin_user="$ADMINUSER"     \
--admin_password="$ADMINPASS" \
--admin_email="$ADMINMAIL"    \
--skip-email                  \
--prompt=title

# if dev-plugs is defined, install them
if [[ ! -z $DEV_PLUGS ]]
then
    echo " :: Installing dev plugins"
    wp plugin install $DEV_PLUGS --activate
fi

# remove wp default plugs and themes (not needed with --skip-content)
# wp plugin delete hello akismet
# wp theme delete twentytwentyone twentytwentythree

# clone theme
echo " :: Cloning DByH base theme..."
mkdir wp-content/themes/
cd wp-content/themes/
git clone  "$BASE_REPO $SITENAME"-theme
cd "$SITENAME"-theme
wp theme activate "$SITENAME"-theme

# TODO: create remote repo automatically
# echo "Provide a slug name for the new project on github"
# read GIT_REPO
# GIT_USER=`git config user.email`

#curl -u $GIT_USER https://api.github.com/orgs/DecisionByHeart/repos -d '{"name":"'$GIT_REPO'", "private": true, "has_wiki":false }'

# change upstream remote to new repo
echo "What is the adress of the new repo on github?"
echo "ex. git@github.com:DecisionByHeart/new-theme.git"
read -p "New repo: " GIT_REPO

echo " :: Changing upstream remote to new repo"
git remote set-url origin "$GIT_REPO" # && git push <- could do automatic push?≤

# config browsersync var
echo " :: Configuring browsersync"
sed -i.bak "s/local.dbyh.se/local.$SITENAME/" webpack.config.js # do a search/replace
rm webpack.config.js.bak # remove unecessary copy from macs implementation of sed

# install theme
echo " :: Installing dependencies"
npm run install:packages
npm run build:dev-blocks

# install composer packages if available
if [[ -f "composer.json" ]]
then
    composer install
fi

# TODO: can site be added to MAMP automatically? cli api seems sunsetted?

echo ""
echo ""
echo "Remember to set up your MAMP with:"
echo " - Site name/url: local.$SITENAME"
echo " - Document root: $SITE_PATH"