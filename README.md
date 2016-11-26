GitLab Remote Mirror Script
===========================

This simple bash script provides functionality for mirroring repositories from GitLab Community Edition to any git server (even with Git LFS support).


### Requirements

* Git
* Git LFS (for repositories with LFS)


### Configuration

The script will load each `*.cnf` file from the `repositories.d` directory.  
Example of a `*.cnf` file:  
```bash
SOURCE_PATH="/var/opt/gitlab/git-data/repositories/group/local-repo.git" # Path to the local GitLab bare repository
TARGET_URL="https://user:pass@example.org/remote-repo.git" # HTTPS or SSH url to the target repository
# LFS=1 # (optional) enable LFS mirroring
# GITLAB_LFS_OBJECTS_PATH="/var/opt/gitlab/gitlab-rails/shared/lfs-objects" # (optional) path to the GitLab LFS storage
```  
The script will push all changes from the local repository specified in the `SOURCE_PATH` variable to the remote repository specified in the `TARGET_URL`.


## Docker image

You can install the mirror script as an isolated Docker image.
This way you don't even need to install Git and Git LFS and configure cron.


### Docker image requirements

* 64-bit Linux system
* [Docker Engine](https://docs.docker.com/engine/installation/linux/)  (`wget -qO- https://get.docker.com/ | sh`)
* [Docker Compose](https://docs.docker.com/compose/install/) version 1.6 or higher


### Installation

#### Configure
Copy `docker-compose.yml.dist` into `docker-compose.yml` and change as you need.  
Copy `crontab.dist` into `crontab` and change the script run time as needed.  
Place your repository mirror configurations into the `repositories.d` folder (see details above).


#### Build the image and start the container
```
docker-compose build
docker-compose up -d
```


### Administration

#### Log into the running container
```
docker exec -ti gitlab-remote-mirror env TERM=xterm bash -l
```
