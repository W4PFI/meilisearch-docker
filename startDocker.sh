#!/bin/bash

# Set the DOCUMENTS_DIR environment variable, default to './documents' if not provided
DOCUMENTS_DIR=${DOCUMENTS_DIR:-./documents}

# Build the Docker image
docker build -t meilisearch-with-ui .

# Run the Docker container with the DOCUMENTS_DIR mounted
docker run -d -p 7700:7700 -p 80:80 -v /path/to/your/documents:/documents meilisearch-with-ui

