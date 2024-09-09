#!/bin/bash

# Get the container ID of the running MeiliSearch container
CONTAINER_ID=$(docker ps -q --filter "ancestor=meilisearch-with-ui")

# Check if the container is running
if [ -n "$CONTAINER_ID" ]; then
    echo "Stopping the MeiliSearch container..."
    docker stop "$CONTAINER_ID"
    
    echo "Removing the MeiliSearch container..."
    docker rm "$CONTAINER_ID"
    
    echo "MeiliSearch container stopped and removed successfully."
else
    echo "No running MeiliSearch container found."
fi
