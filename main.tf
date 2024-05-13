resource "google_compute_instance" "default" {
  name         = "proxy"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // IP externo
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${path.module}/id_ed25519.pub")}"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y squid
    sudo systemctl stop squid
    cat <<-EOT > /etc/squid/squid.conf
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
    acl bloqueio_extensoes urlpath_regex \.src\$ \.exe\$ \.paf\$ \.mp3\$ \.mp4$
    
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
    EOT
    sudo systemctl start squid
  EOF

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["squid-vm"]
  
}
