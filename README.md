Script automates below steps:
https://about.gitlab.com/update/#ubuntu

### Make a backup (Optional)
If you would like to make a backup before updating, the below command will backup data in /var/opt/gitlab/backups by default.
```
sudo gitlab-rake gitlab:backup:create STRATEGY=copy
```

### Update GitLab
Update to the latest version of GitLab.
```
sudo apt-get update && sudo apt-get install gitlab-ce
```
