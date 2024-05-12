# gcp-vm-terraform

## Descrição
gcp-vm-terraform é um projeto utilizando Terraform para provisionar e gerenciar uma instância de VM no Google Cloud Platform (GCP) com uma configuração automatizada para acesso SSH. Este projeto visa simplificar a criação de uma VM Ubuntu com configuração de segurança pronta para uso.

## Pré-requisitos
Para utilizar este projeto, você precisará dos seguintes itens instalados e configurados:
- Terraform 0.12.x ou superior
- CLI do Google Cloud (gcloud) autenticada e configurada
- Acesso ao Google Cloud Platform com permissões apropriadas

## Instalação
### Clonar o Repositório
Primeiro, clone este repositório em sua máquina local:
```bash
git clone https://github.com/seu-usuario/gcp-vm-terraform.git
cd gcp-vm-terraform
```

### Configuração do Terraform
Antes de executar o Terraform, inicialize o diretório do Terraform com:
```bash
terraform init
```

## Uso
Para criar a VM no GCP, siga estas etapas:

1. **Modifique os Arquivos de Configuração**:
   - Abra o arquivo `main.tf` e atualize as configurações conforme necessário, como o tipo de máquina e o nome da VM.

2. **Configuração do Arquivo .env**:
   - Crie um arquivo `.env` na raiz do projeto e adicione suas variáveis de ambiente:
     ```env
     GOOGLE_CREDENTIALS=path/to/your-service-account-key.json
     GOOGLE_PROJECT=your-gcp-project-id
     GOOGLE_REGION=us-central1
     ```

3. **Plano do Terraform**:
   - Execute o plano para ver as mudanças que serão aplicadas:
     ```bash
     terraform plan
     ```

4. **Aplicar o Plano**:
   - Aplique o plano para criar sua VM:
     ```bash
     terraform apply
     ```
   - Confirme as mudanças com `yes` quando solicitado.

5. **Acesso à VM**:
   - Após a criação da VM, conecte-se via SSH usando:
     ```bash
     ssh -i ./id_ed25519 ubuntu@<IP_DA_VM>
     ```

## Contribuições
Contribuições são sempre bem-vindas! Sinta-se livre para forkar o repositório e submeter suas contribuições via pull request.

## Licença
Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para detalhes.

### Notas
- **Customização**: Certifique-se de personalizar as URLs do repositório e outros detalhes específicos para o seu projeto.
- **Segurança**: Sempre revise e garanta a segurança das suas configurações, especialmente ao expor informações em repositórios públicos.
- **Documentação**: Manter uma boa documentação é essencial para que outros possam entender e colaborar com seu projeto.

Esse README fornece um ponto de partida robusto para o seu projeto "gcp-vm-terraform" e pode ser expandido conforme necessário para incluir mais detalhes técnicos, screenshots, ou seções de FAQ.