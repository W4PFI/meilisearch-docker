# Start from the official MeiliSearch image, based on Alpine Linux
FROM getmeili/meilisearch:latest

# Install Python3, Pip, Virtualenv, and Nginx
RUN apk add --no-cache python3 py3-pip py3-virtualenv nginx

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate the virtual environment and install MeiliSearch client
RUN /opt/venv/bin/pip install meilisearch

# Copy the front-end UI (search interface) to the Nginx default directory
COPY search_interface /usr/share/nginx/html

# Copy the Python script for indexing files
COPY index_files.py /usr/local/bin/index_files.py

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Activate the virtual environment by default
ENV PATH="/opt/venv/bin:$PATH"

# Expose MeiliSearch on port 7700 and Nginx on port 80
EXPOSE 7700 80

# Start MeiliSearch, run the indexing script, and start Nginx
CMD meilisearch --http-addr 0.0.0.0:7700 --master-key & \
    python3 /usr/local/bin/index_files.py /documents && \
    nginx -g 'daemon off;'
