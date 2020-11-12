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
 zip : $ZIP,
 country : $COUNTRY,
 city : $CITY,
 industry : $INDUSTRY,
 eula : [\"trial\"],
 title : $TITLE,
 phone : $PHONE,
 company : $COMPANY,
 state : $STATE,
 department : $DEPARMENT,
 first_name : $FIRST_NAME,
 last_name : $LAST_NAME,
 email : $EMAIL
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
wget https://downloads.tableau.com/esdalt/2020.3.2/tableau-server-2020-3-2_amd64.deb
sudo gdebi -n tableau-server-2020-3-2_amd64.deb
sudo /opt/tableau/tableau_server/packages/scripts.20203.20.1018.2303/initialize-tsm -a $USER --accepteula --debug

sudo -u $USER /usr/share/bash-completion/completions/tsm licenses activate --trial
sudo -u $USER /usr/share/bash-completion/completions/tsm register -f registration.json
sudo -u $USER /usr/share/bash-completion/completions/tsm settings import -f config.json
sudo -u $USER /usr/share/bash-completion/completions/tsm pending-changes apply
sudo -u $USER /usr/share/bash-completion/completions/tsm initialize

#rm registration.json
#rm tableau-server-2020-3-2_amd64.deb
#rm config.json
