#!/bin/bash

# 1. Verificar se o usuário tem privilégios de root
if [[ $EUID -ne 0 ]]; then
  echo "Este script requer privilégios de root. Execute-o com sudo."
  exit 1
fi

# 2. Atualizar e Instalar as dependências necessárias
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# 3. Adicionar a chave GPG do repositório Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# 4. Adicionar o repositório Docker
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# 5. Atualizar a lista de pacotes
apt-get update

# 6. Instalar o Docker Engine
apt-get install -y docker-ce docker-ce-cli containerd.io

# 7. Instalar o Docker Compose
apt-get install -y docker-compose

# 8. Verificra se o Docker e o Docker Compose foram instalados com sucesso
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

# 9. Configurar o Docker para iniciar automaticamente no boot
systemctl enable docker

# 10. Reiniciar o serviço do Docker
systemctl restart docker

echo "Docker e Docker Compose instalados com sucesso!"