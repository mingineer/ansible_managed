ns='${NAMESPACE}'
date=`date +"%Y%m%d"`

if [ -d $date ]; then
  continue
else
  mkdir $date
fi

for project in $ns
do
  echo "### $project backup ###"

  rt_list=(`oc get routes.route.openshift.io  -n $project --no-headers  | awk '{print $1}'`)

  if [ -d $date/$project ]; then
    continue
  else
    mkdir $date/$project
  fi


  for rt in ${rt_list[@]}
    do
      oc get route $rt -n $project -oyaml > ./$date/$project/${rt}.yaml
    done


done