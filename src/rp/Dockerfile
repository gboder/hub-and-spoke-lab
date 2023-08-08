# Use the official NGINX image as the base image
FROM nginx:alpine

# Remove the default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom NGINX configuration
COPY nginx.conf /etc/nginx/conf.d/

# Copy your SPA build files into the container
COPY dist/ /usr/share/nginx/html

# Expose the port that NGINX will listen on
EXPOSE 80

# Start NGINX when the container is run
CMD ["nginx", "-g", "daemon off;"]
