# Imagem base do Node.js
FROM node:16-alpine

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Instala as dependências de desenvolvimento
RUN npm install -g nodemon express-generator

# Cria um novo projeto Express
RUN express --view=pug --force my-express-app

# Copia o arquivo package.json e package-lock.json para o container
COPY package*.json ./

# Altera o arquivo 'views/index.pug' para retornar 'Hello World!'
RUN sed -i 's/<p>Welcome to Express</p>/<p>Hello World!</p>/g' my-express-app/views/index.pug


# Instala as dependências
RUN npm install

# Copia o código da aplicação para o container
COPY . .

# Define a porta de escuta do servidor
ENV PORT=3000

# Define o comando para iniciar a aplicação
CMD ["npm", "start", "nodemon", "server.js",  "my-express-app/bin/www"]