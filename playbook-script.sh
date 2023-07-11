function conform {
    while true
    do
        read -p "$1 [y/n] : " yn
        case $yn in
            [Yy] ) echo "1"; break;;
            [Nn]  ) echo "0"; break;;
        esac
    done
}

function var {
    read -p "인벤토리 그룹 : " Target
    read -p "계정 명 : " Name
    read -p "패스워드 : " Password
    read -p "UID : " ADDUID
    read -p "그룹 명 : " Group
    read -p "GID : " ADDGID
    read -p "인벤토리 경로 : " ini
    read -p "플레이북 경로 : " ply

    clear
    echo "인벤토리 그룹 : $Target"
    echo "계정 명 : $Name"
    echo "패스워드 : $Password"
    echo "UID : $ADDUID"
    echo "그룹 명 : $Group"
    echo "GID : $ADDGID"
    echo "인벤토리 경로 : $ini"
    echo "플레이북 경로 : $ply"
}

function task {
  var
  if [ $(conform "해당 설정으로 수행하시겠습니까?") -eq "1" ]; then
          sshpass -p '${PW}' ansible-playbook -e Target=$Target -e Name=$Name -e Password=$Password -e UID=$ADDUID -e Group=$Group -e GID=$ADDGID -i $ini $ply --ask-pass
  else
          clear
          task
  fi
}

task
