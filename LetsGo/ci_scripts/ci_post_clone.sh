#!/bin/sh

#  ci_post_clone.sh
#  LetsGo
#
#  Created by Vishal Polepalli on 12/24/22.
#  
cd ~/LetsGo
touch GoogleService-Info.plist
echo '${googlePLIST}' >> GoogleService-Info.plist

cd ~/LetsGo/Secrets
touch secrets.json
echo '${secretsJSON}' >> secrets.json

