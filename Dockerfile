
FROM node:7.8.0

# Argumento para el puerto de React (opcional)
ARG REACT_APP_PORT=3000

WORKDIR /opt

# Copiar archivos del proyecto
ADD . /opt

# Instalar dependencias
RUN npm install

# Exponer el puerto 3000 (puerto interno del contenedor React)
EXPOSE 3001

# Iniciar la aplicación
ENTRYPOINT npm run start