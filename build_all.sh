#!/bin/bash

# Parar em caso de erro
set -e

# Compilar Go
echo "Compilando Go project..."
cd golang
go build -o bootstrap
cd ..

# Compilar Java (assumindo uso do Maven)
echo "Compilando Java project..."
cd java
mvn clean install
cd ..

# Compilar .NET
echo "Compilando .NET project..."
cd dotnet
dotnet build
cd ..

# Para Python, Ruby, e Node.js, geralmente não há um processo de 'compilação',
# mas você pode querer configurar ambientes, instalar dependências, etc.

# Instalar dependências Python
echo "Configurando Python project..."
cd python
pip3 install -r requirements.txt
cd ..

# Instalar dependências Ruby
echo "Configurando Ruby project..."
cd ruby
bundle install
cd ..

# Instalar dependências Node.js
echo "Configurando Node.js project..."
cd nodejs
npm install
cd ..

# Compilar Rust
echo "Compilando Rust project..."
cd rust
cargo build --release
cd ..

echo "Todos os projetos foram compilados/configurados com sucesso!"
