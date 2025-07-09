# Dockerfile

# Use a small, efficient base image with NGINX pre-installed
FROM nginx:alpine

# Remove the default NGINX index page (optional, for clarity)
RUN rm -rf /usr/share/nginx/html/*

# Copy your static site content into the container
COPY ./app /usr/share/nginx/html

# Expose port 80 (optional, for documentation)
EXPOSE 80
