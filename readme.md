# GCP VM Terraform Project

Este projeto utiliza Terraform para provisionar uma instância de VM no Google Cloud Platform (GCP) com Ubuntu 22.04 LTS. A instância é configurada para rodar o Squid, um servidor proxy HTTP, com configurações personalizadas.

## Pré-requisitos

- Conta no Google Cloud Platform
- Google Cloud SDK instalado e configurado
- Terraform instalado
- Chave SSH pública (`id_ed25519.pub`) para acesso à VM

## Estrutura do Projeto

- `main.tf`: Define os recursos principais do GCP, incluindo a instância da VM.
- `variables.tf`: Contém as variáveis usadas no projeto.
- `provider.tf`: Configura o provedor do GCP.
- `outputs.tf`: Define os outputs do Terraform.

## Configuração do Squid

O Squid é instalado e configurado automaticamente na instância da VM. A configuração personalizada do Squid é definida no script de inicialização da instância.

### squid.conf

O arquivo de configuração do Squid (`/etc/squid/squid.conf`) é definido com as seguintes configurações básicas:

```plaintext
# Arquivo de Configuração Básico do Squid

# Porta em que o Squid escutará as requisições
http_port 8088

# Define o diretório de cache
cache_dir ufs /var/spool/squid 100 16 256

# Define o arquivo de log de acesso
access_log /var/log/squid/access.log

# Definições de ACL (Listas de Controle de Acesso)
acl rede_local src 192.168.1.0/24   # Sub-rede interna
acl gerencia src 192.168.1.100      # IP específico da gerência
acl recepcao src 192.168.1.15       # IP da recepção

# Definindo tipos de arquivo proibidos
acl bloqueio_extensoes urlpath_regex \.src\$ \.exe\$ \.paf\$ \.mp3\$ \.mp4\$

# Bloqueio de domínios específicos
acl bloqueio_dominios dstdomain .twitter.com .youtube.com

# Bloqueio de palavras específicas nas URLs
acl bloqueio_palavras url_regex -i terra
acl excecao_terraviva dstdomain .terraviva.com.br

# ACLs para portas e métodos seguros
acl SSL_ports port 443         # HTTPS
acl Safe_ports port 80         # HTTP
acl Safe_ports port 21         # FTP
acl Safe_ports port 443        # HTTPS
acl Safe_ports port 70         # Gopher (exemplo histórico)
acl CONNECT method CONNECT     # Permite métodos CONNECT para HTTPS

# Regras de acesso
http_access deny bloqueio_extensoes
http_access deny bloqueio_dominios
http_access deny bloqueio_palavras
http_access allow excecao_terraviva
http_access allow gerencia
http_access allow CONNECT SSL_ports
http_access allow Safe_ports
http_access deny !Safe_ports  # Negar acesso a qualquer porta que não seja 'segura'

# Configurações adicionais para otimizar o desempenho e segurança
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320

# Desabilita o cache para páginas de erro
error_directory /usr/share/squid/errors/English

# Configurações de segurança
forwarded_for off
request_header_access Referer deny all
request_header_access X-Forwarded-For deny all
request_header_access Via deny all
request_header_access Cache-Control deny all

# Uso do DNS
dns_nameservers 8.8.8.8 8.8.4.4
```

## Instruções de Uso

### Passo 1: Clonar o Repositório

Clone o repositório para a sua máquina local:

```sh
git clone https://github.com/seu-usuario/gcp-vm-terraform.git
cd gcp-vm-terraform
```

### Passo 2: Configurar as Variáveis

Edite o arquivo `variables.tf` para ajustar as variáveis conforme suas necessidades.

### Passo 3: Inicializar o Terraform

Inicialize o Terraform para baixar os provedores necessários:

```sh
terraform init
```

### Passo 4: Aplicar as Configurações

Aplicar as configurações do Terraform para provisionar a VM:

```sh
terraform apply
```

### Passo 5: Destruir a Infraestrutura

Para destruir a infraestrutura provisionada quando ela não for mais necessária:

```sh
terraform destroy
```

## Acesso à VM

Você pode acessar a VM usando a chave SSH configurada:

```sh
ssh -i path/to/your/id_ed25519 ubuntu@<external-ip>
```

## Logs do Squid

Os logs de acesso do Squid são armazenados em `/var/log/squid/access.log`. Para visualizar os logs, use:

```sh
sudo tail -f /var/log/squid/access.log
```

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## Licença

Este projeto está licenciado sob a Licença MIT. Consulte o arquivo LICENSE para obter mais informações.