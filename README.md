
# Docker Images for Development

A set of docker image build-files for local software development purposes.

# Motivation

The primary motivation behind creating these docker images is to setup a cluster of light-weight docker containers to experiment with different server/cluster environments (as close to real production environment as possible) on local development machine.

Consider following software development scenarios as possible use-cases:

- Have a local dev server that you can ssh to like a remote server (just like a light-weight VM running your local machine instead of on the VirtualBox/AWS/Google Cloud etc.).

- You, as developer, have build a SaaS product, now you want to make sure that the product works as expected when it is run behind a load-balancer (e.g. HAProxy or similar products on your production servers).

- You want to run PostgreSQL in some cluster mode (for database replication, testing, hacking etc).

- Want's to create a data ingestion pipeline for Analytics or a cluster of servers needed for an inherently distributed software product e.g. HDFS, on your local machine.

- And, more.


# Note (Important)

Docker image from 'images/sshd' build-file works both as a stand-alone and base-image for creating other images (e.g. postgres, node, etc) in this git repository.

When you want to use 'images/sshd' image as a base-image for creating, let's say, postgres docker image, it should be named as 'ubuntu/sshd:16.04' (as it's referenced in postgres docker build-file with this image name) or update the reference to *sshd* image with your local docker image's name in 'images/(postgres|node)/Dockerfile' files.

**Warning:**
These docker images are tailored specifically for **local development purposes only** as there are lots of packages installed which one don't want in production environment; therefore, **don't use it on your production server without significant modification.**

# Steps

```
$ export DOCKER_IMAGES_DIR=<docker>
$ alias docker='sudo docker'
$
$ docker pull ubuntu:16.04
$
$ cd $DOCKER_IMAGES_DIR/images
$ docker build --tag 'ubuntu/sshd:16.04' sshd/
$
$ docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ubuntu/sshd           16.04               3c9133a14589        2 hours ago         575.7 MB
ubuntu                16.04               bea8f41ae3e8        10 days ago         128.1 MB
```

# License

The MIT License
