# Docker Basics

Remove all old containers

    docker rm $(docker ps -aq)

Start an elasticsearch container

    docker run -dp 9200:9200 elasticsearch

Run flags

    -d                 # Run in detached mode.
    -p 9200:9200       # Specify custom port forward.
    --name funny_name  # Container is named funny_name.

