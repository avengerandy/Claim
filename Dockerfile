FROM node:22.15.0

# install agent
WORKDIR /app
RUN npm install -g @google/gemini-cli
