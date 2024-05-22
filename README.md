# Projeto_02_Shell_Scrips
 ## Shell Script para Configurar Ambiente de Desenvolvimento com Docker e Express

    #!/bin/bash: Define o interpretador do script como Bash.

 # Parte 01
    1. if [[ $EUID -ne 0 ]]; then ... fi: Verifica se o script está sendo executado como root. Se não, exibe uma mensagem de erro e sai.
    2. apt-get update: Atualiza a lista de pacotes do sistema.
    3. apt-get install -y ...: Instala as dependências necessárias (curl, gnupg2, etc.) e o Docker Engine e o Docker Compose.
    4. curl -fsSL ... | apt-key add -: Adiciona a chave GPG do repositório Docker.
    5. add-apt-repository ...: Adiciona o repositório Docker à lista de fontes.
    6. docker --version e docker-compose --version: Verifica se o Docker e o Docker Compose foram instalados corretamente.
        6.1 > /dev/null 2>&1  Isso impede que a saída seja exibida no terminal. 
        6.2 O código de saída do comando é armazenado na variável $?
        6.3 if [[ $? -ne 0 ]]; then ... fi: saída != 0, falhou, o script exibe uma mensagem de erro e sai.
        6.4 echo "Docker e Docker Compose instalados com sucesso!": se ambos os comandos docker --version e docker-compose --version tenham com sucesso.
    7. systemctl enable docker: Configura o Docker para iniciar automaticamente no boot.
    8. systemctl restart docker: Reinicia o serviço do Docker.
    9. echo "Docker e Docker Compose instalados com sucesso!": Exibe uma mensagem de sucesso

# Alterações feita do script 01 para o script 02 Explicação das alterações:
1. Remoção do apt-key add: O comando apt-key add foi removido, pois é descontinuado e menos seguro.
2. Adição da chave via gpg --dearmor:
3. Baixar a chave GPG do Docker usando curl.
4. Usar gpg --dearmor para converter a chave para o formato binário e salvar em /usr/share/keyrings/docker-archive-keyring.gpg.
5. Especificando a chave no add-apt-repository:
6. Adicição signed-by=/usr/share/keyrings/docker-archive-keyring.gpg ao comando add-apt-repository para indicar que o APT deve usar a chave que foi adicionada para verificar a autenticidade do repositório Docker.


# Parte 02
Explicação do Dockerfile:
FROM node:16-alpine: Define a imagem base como Node.js versão 16, com a distribuição Alpine Linux, que é mais leve.
WORKDIR /app: Define o diretório de trabalho dentro do container como /app.
COPY package*.json ./: Copia os arquivos package.json e package-lock.json do diretório atual para o diretório de trabalho dentro do container.
RUN npm install: Executa o comando npm install para instalar as dependências da aplicação.
COPY . .: Copia todos os arquivos e diretórios do diretório atual para o diretório de trabalho dentro do container.
CMD ["npm", "start"]: Define o comando padrão para iniciar o container. Neste caso, é executado o comando npm start, que geralmente inicia a aplicação Express.

Baixeo o arquivo chamado Script03.dockerfile.
Abra o terminal e navegue até o diretório onde está o Dockerfile.
Execute o comando docker build -t my-express-app . para construir a imagem.
Substitua my-express-app pelo nome da imagem que você deseja usar.
O ponto final (.) indica que o Dockerfile está no diretório atual.

Para executar o container:
Execute o comando docker run -p 3000:3000 my-express-app para iniciar o container.
-p 3000:3000 mapeia a porta 3000 do container para a porta 3000 do seu host.
my-express-app é o nome da imagem que você construiu.
Agora você poderá acessar a sua aplicação Express em http://localhost:3000.