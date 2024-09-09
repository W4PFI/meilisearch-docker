# Start from the official MeiliSearch image
FROM getmeili/meilisearch:latest

# Install Python for indexing script
RUN apt-get update && apt-get install -y python3 python3-pip

# Install the MeiliSearch Python client
RUN pip3 install meilisearch

# Copy the front-end UI (search interface) to a directory that can be served
COPY search_interface /usr/share/nginx/html

# Copy the Python script for indexing files
COPY index_files.py /usr/local/bin/index_files.py

# Copy Nginx configuration file to override the default config
COPY nginx.conf /etc/nginx/nginx.conf

# Expose MeiliSearch on port 7700
EXPOSE 7700 80

# Start MeiliSearch and Nginx concurrently and ensure the Python script runs before starting Nginx
CMD meilisearch --http-addr 0.0.0.0:7700 & \
    python3 /usr/local/bin/index_files.py /documents && \
    nginx -g 'daemon off;'
