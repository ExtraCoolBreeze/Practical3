FROM node:14
WORKDIR /app
COPY server.js .
RUN npm install http
CMD ["node", "server.js"]
EXPOSE 8080
