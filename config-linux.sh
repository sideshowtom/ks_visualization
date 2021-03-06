#!/bin/bash

while getopts a:b:c:d:e:f:g:h:i:j:k:l:m:n: option
do
 case "${option}"
 in
	 a) USER=${OPTARG};;
	 b) PASSWORD=${OPTARG};;
	 c) FIRST_NAME=${OPTARG};;
	 d) LAST_NAME=${OPTARG};;
	 e) EMAIL=${OPTARG};;
	 f) TITLE=${OPTARG};;
	 g) DEPARMENT=${OPTARG};;
	 h) COMPANY=${OPTARG};;
	 i) INDUSTRY=${OPTARG};;
	 j) PHONE=${OPTARG};;
	 k) CITY=${OPTARG};;
	 l) STATE=${OPTARG};;
	 m) COUNTRY=${OPTARG};;
	 n) ZIP=${OPTARG};;
 esac
done

cd /tmp/

echo "{
 \"zip\" : \"$ZIP\",
 \"country\" : \"$COUNTRY\",
 \"city\" : \"$CITY\",
 \"industry\" : \"$INDUSTRY\",
 \"eula\" : \"trial\",
 \"title\" : \"$TITLE\",
 \"phone\" : \"$PHONE\",
 \"company\" : \"$COMPANY\",
 \"state\" : \"$STATE\",
 \"department\" : \"$DEPARMENT\",
 \"first_name\" : \"$FIRST_NAME\",
 \"last_name\" : \"$LAST_NAME\",
 \"email\" : \"$EMAIL\"
}" >> registration.json

echo '{
  "configEntities": {
    "identityStore": {
      "_type": "identityStoreType",
      "type": "local"
    }
  }
}' >> config.json
wait

sudo apt-get update
sudo apt-get -y install gdebi-core
wget https://downloads.tableau.com/esdalt/2020.3.3/tableau-server-2020-3-3_amd64.deb
sudo gdebi -n tableau-server-2020-3-3_amd64.deb
TABLEAU_PACKAGES_DIR=/opt/tableau/tableau_server/packages
TABLEAU_VER_STRING=20203.20.1110.1623
TABLEAU_SCRIPTS_DIR=$TABLEAU_PACKAGES_DIR/scripts.$TABLEAU_VER_STRING
sudo $TABLEAU_SCRIPTS_DIR/initialize-tsm -a $USER --accepteula --debug

TABLEAU_EXE_DIR=$TABLEAU_PACKAGES_DIR/bin.$TABLEAU_VER_STRING
sudo $TABLEAU_EXE_DIR/tsm licenses activate --trial
sudo $TABLEAU_EXE_DIR/tsm register -f /tmp/registration.json
sudo $TABLEAU_EXE_DIR/tsm pending-changes apply
sudo $TABLEAU_EXE_DIR/tsm settings import -f /tmp/config.json
sudo $TABLEAU_EXE_DIR/tsm pending-changes apply
sudo $TABLEAU_EXE_DIR/tsm initialize

#rm registration.json
#rm tableau-server-2020-3-2_amd64.deb
#rm config.json
