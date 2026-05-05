# ---- Étape 1 : Build ---
FROM node:20-alpine AS build
WORKDIR /app

# Copier les fichiers de dépendances depuis le dossier du frontend
COPY src/package*.json ./
RUN npm ci

# Copier le reste du code source Angular et builder
COPY src/ .
RUN npm run build --prod

# ---- Étape 2 : Serveur Nginx ---
FROM nginx:stable-alpine
# Copier la configuration Nginx par défaut pour les Single Page Application
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/

# Copier les fichiers statiques depuis l'étape de build
COPY --from=build /app/dist/wind-dev-ops-plattform /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
