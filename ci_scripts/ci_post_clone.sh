#!/bin/sh

#  ci_post_clone.sh
#  LetsGo
#
#  Created by Vishal Polepalli on 12/24/22.
#

cd /Volumes/workspace/repository/LetsGo
touch GoogleService-Info.plist
echo "{$googlePLIST}" >> GoogleService-Info.plist

cd /Volumes/workspace/repository/LetsGo/Secrets
touch secrets.json
echo "{$secretsJSON}" >> secrets.json
