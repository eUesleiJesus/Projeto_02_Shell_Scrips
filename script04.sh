#!/bin/bash

# Verifica se o usuário tem privilégios de root
if [[ $EUID -ne 0 ]]; then
  echo "Este script requer privilégios de root. Execute-o com sudo."
  exit 1
fi

# Instala as dependências necessárias
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# ----> Início da alteração <----
# Adiciona a chave GPG do Docker (método recomendado)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adiciona o repositório Docker, usando a chave adicionada
add-apt-repository "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# ----> Fim da alteração <----

# Atualiza a lista de pacotes
apt-get update

# Instala o Docker Engine
apt-get install -y docker-ce docker-ce-cli containerd.io

# Instala o Docker Compose
apt-get install -y docker-compose

# Verifica se o Docker e o Docker Compose foram instalados com sucesso
docker --version > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Erro: Docker não instalado corretamente."
  exit 1
fi

docker-compose --version > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Erro: Docker Compose não instalado corretamente."
  exit 1
fi

# Configura o Docker para iniciar automaticamente no boot
systemctl enable docker

# Reinicia o serviço do Docker
systemctl restart docker

echo "Docker e Docker Compose instalados com sucesso!"

# Cria um diretório para o projeto
mkdir my-express-app

# Move para o diretório do projeto
cd my-express-app

# Cria um Dockerfile
cat > Dockerfile <<EOF
FROM node:16-alpine

WORKDIR /app

RUN npm install -g nodemon express-generator

RUN express --view=pug --force my-express-app

COPY package*.json ./

RUN npm install

RUN sed -i 's/<p>Welcome to Express</p>/<p>Hello World!</p>/g' my-express-app/views/index.pug

COPY . .

ENV PORT=3000

CMD ["nodemon", "my-express-app/bin/www"]
EOF

# Constrói a imagem do Docker
docker build -t my-express-app .

# Executa o container
docker run -p 3000:3000 my-express-app

echo "Ambiente de desenvolvimento configurado com sucesso!"
echo "Acesse http://localhost:3000 para ver a aplicação."
