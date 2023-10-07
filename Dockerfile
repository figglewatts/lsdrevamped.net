FROM nginx:alpine

COPY ./site/static/ /usr/share/nginx/html/