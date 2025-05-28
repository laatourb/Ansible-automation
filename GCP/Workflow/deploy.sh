#!/bin/bash

set -e

# =============================================
# Script de déploiement GCP avec Ansible
# =============================================

check_requirements() {
    for cmd in ansible gcloud; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "❌ L'outil requis '$cmd' n'est pas installé."
            exit 1
        fi
    done
}

create_env_if_missing() {
    if [ ! -f ".env" ]; then
        echo "📁 Fichier .env manquant. Création d’un exemple..."
        if [ -f ".env.example" ]; then
            cp .env.example .env
            echo "✏️  Complétez le fichier .env avant de relancer le script."
            exit 1
        else
            cat > .env <<EOL
# Credentials GCP (valeurs factices pour test)
GOOGLE_APPLICATION_CREDENTIALS=gcp-creds.json
GCP_PROJECT_ID=fake-gcp-project-id
GCP_SERVICE_ACCOUNT_EMAIL=fake-sa@fake-project.iam.gserviceaccount.com

# Mot de passe Ansible Vault
ANSIBLE_VAULT_PASSWORD=Bilal123\$*!

# Variables pour le vault
VAULT_GCP_PROJECT_ID=fake-gcp-project-id
VAULT_GCP_SERVICE_ACCOUNT_EMAIL=fake-sa@fake-project.iam.gserviceaccount.com
VAULT_GCP_CREDENTIALS_FILE=gcp-creds.json
VAULT_INSTANCE_ADMIN_PASSWORD=Bilal123\$*!
EOL
            echo "✏️  Fichier .env créé avec des valeurs factices."
            echo "✏️  Modifiez-les avant un déploiement réel."
            exit 1
        fi
    fi
}

load_env() {
    source .env
}

validate_gcp_connection() {
    if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
        echo "❌ Vous n'êtes pas connecté à GCP. Lancez 'gcloud auth login'."
        exit 1
    fi
}

validate_variables() {
    for var in GOOGLE_APPLICATION_CREDENTIALS GCP_PROJECT_ID GCP_SERVICE_ACCOUNT_EMAIL ANSIBLE_VAULT_PASSWORD VAULT_GCP_PROJECT_ID VAULT_GCP_SERVICE_ACCOUNT_EMAIL VAULT_GCP_CREDENTIALS_FILE VAULT_INSTANCE_ADMIN_PASSWORD; do
        if [ -z "${!var}" ]; then
            echo "❌ La variable $var est vide dans .env. Veuillez la renseigner."
            exit 1
        fi
    done
}

create_vault_password_file() {
    echo "$ANSIBLE_VAULT_PASSWORD" > .vault_pass
    chmod 600 .vault_pass
}

create_encrypted_vault_file() {
    VAULT_FILE="vars/vault.yml"
    mkdir -p vars

    if [ ! -f "$VAULT_FILE" ]; then
        echo "🔐 Création du fichier $VAULT_FILE (chiffré)..."
        cat > "$VAULT_FILE" <<EOL
---
gcp_project_id: ${VAULT_GCP_PROJECT_ID}
gcp_service_account_email: ${VAULT_GCP_SERVICE_ACCOUNT_EMAIL}
gcp_credentials_file: ${VAULT_GCP_CREDENTIALS_FILE}
instance_admin_password: ${VAULT_INSTANCE_ADMIN_PASSWORD}
EOL

        ansible-vault encrypt "$VAULT_FILE" --vault-password-file .vault_pass
        echo "✅ Fichier $VAULT_FILE chiffré avec succès."
    fi
}

run_playbook() {
    echo "🚀 Démarrage du déploiement GCP..."
    ansible-playbook main.yml --vault-password-file .vault_pass
}

cleanup() {
    rm -f .vault_pass
}

check_status() {
    if [ $? -eq 0 ]; then
        echo "✅ Déploiement GCP terminé avec succès !"
    else
        echo "❌ Erreur pendant le déploiement GCP."
        exit 1
    fi
}

# ================
# EXECUTION
# ================

check_requirements
create_env_if_missing
load_env
validate_gcp_connection
validate_variables
create_vault_password_file
create_encrypted_vault_file
run_playbook
cleanup
check_status
