## Change Password Playbook

3개월마다 계정 패스워드 만료
crontab으로 패스워드 만료 전 갱신

- passwd.yaml

## 정기점검 스크립트 수행

정기점검 스크립트 수행 및 결과 파일 전달 자동화
정기점검 날짜에 맞춰 자동으로 스크립트 수행 후 메일 전달 (Windows Scheduler + Ansible)

- server_inspection.yaml
- send_mail.yaml

## USER / GROUP 생성
user, pw, uid, gid, install package

- playbook-script.sh
- install_packages.yaml
- create_directory.yaml
- create_account.yaml

## RHEL 8 보안 취약점 조치 (약식)
VM 초기 생성 보안 취약점 조치

- rhel8.sh
- rhel8_playbook.yaml


## OPENSHIFT ROUTE BACKUP 백업 스크립트

- rt-backup.yaml
- rt_backup.sh