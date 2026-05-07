# ---- Étape 1 : Build ---
FROM node:20-alpine AS build
WORKDIR /app

# Copier les dépendances
COPY src/package*.json ./

# Installer avec optimisation
RUN npm install --prefer-offline --no-audit --progress=false

# Copier le code source
COPY src/ .

# Build Angular (le dossier de sortie sera /app/dist)
RUN node --max_old_space_size=2048 ./node_modules/@angular/cli/bin/ng build --prod --optimization

# ---- Étape 2 : Serveur Nginx ---
FROM nginx:stable-alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/

# Copie générique : prend tout ce qui est dans /app/dist
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
