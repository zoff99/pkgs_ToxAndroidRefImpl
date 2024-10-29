#! /bin/bash

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/../"

cd "$basedir"

f3=$(ls -1tr local_maven_trifa_jni_1.0.*.zip|tail -1|tr -d " ")

cur_m_version=$(echo "$f3" | sed -e 's#^.*local_maven_trifa_jni_##'|sed -e 's#.zip$##')

# thanks to: https://stackoverflow.com/a/8653732
next_m_version=$(echo "$cur_m_version"|awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')

echo $cur_m_version
echo $next_m_version


furl=$(wget -q -O - 'https://circleci.com/api/v1.1/project/github/zoff99/ToxAndroidRefImpl/latest/artifacts?branch=zoff99%2Fmaven_artefact&filter=successful'|\
  grep 'local_maven_trifa_jni_'"$next_m_version"'.zip'|grep '"url"'|sed -e 's#^.* : "##'|sed -e 's#",$##')

echo $furl

wget -q -O 'local_maven_trifa_jni_'"$next_m_version"'.zip' "$furl"

