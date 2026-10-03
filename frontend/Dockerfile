# Use the official Nginx unprivileged image (Native non-root, defaults to port 8080)
FROM nginx:1.27-alpine-slim

# Redirect access and error logs directly to stdout/stderr for real-time cloud logging
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY --chown=nginx:nginx default.conf /etc/nginx/conf.d/default.conf

# Copy your frontend code into the default Nginx web directory
COPY --chown=nginx:nginx index.html /usr/share/nginx/html/
COPY --chown=nginx:nginx Images /usr/share/nginx/html/Images
# Document the port layout explicitly
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
