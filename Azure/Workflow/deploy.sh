#!/bin/bash

set -e

# =============================================
# Script de déploiement Azure avec Ansible
# =============================================

check_requirements() {
    for cmd in ansible az; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "❌ L'outil requis '$cmd' n'est pas installé."
            exit 1
        fi
    done
}

check_azure_login() {
    if ! az account show &> /dev/null; then
        echo "❌ Vous n'êtes pas connecté à Azure. Lancez 'az login'."
        exit 1
    fi
}

create_env_if_missing() {
    if [ ! -f ".env" ]; then
        echo "📁 Fichier .env manquant. Création d’un exemple..."
        cat > .env <<EOL
# Azure Credentials (valeurs fictives pour test)
AZURE_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000
AZURE_TENANT_ID=11111111-1111-1111-1111-111111111111
AZURE_CLIENT_ID=22222222-2222-2222-2222-222222222222
AZURE_CLIENT_SECRET=fake-client-secret-for-testing

# Mot de passe Ansible Vault
ANSIBLE_VAULT_PASSWORD=Bilal123\$*!

# Variables chiffrées dans vault.yml (valeurs fictives)
VAULT_AZURE_CLIENT_ID=22222222-2222-2222-2222-222222222222
VAULT_AZURE_SECRET=fake-client-secret-for-testing
VAULT_AZURE_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000
VAULT_AZURE_TENANT=11111111-1111-1111-1111-111111111111
VAULT_VM_ADMIN_PASSWORD=Bilal123\$*!
EOL
        echo "✏️  Fichier .env créé avec des valeurs par défaut fictives."
        echo "✏️  Pensez à modifier ces valeurs avant un déploiement réel."
        exit 1
    fi
}

load_env() {
    source .env
}

validate_variables() {
    if [ -z "${CLOUD_SHELL:-}" ]; then
        for var in \
            AZURE_SUBSCRIPTION_ID AZURE_TENANT_ID AZURE_CLIENT_ID AZURE_CLIENT_SECRET \
            ANSIBLE_VAULT_PASSWORD VAULT_VM_ADMIN_PASSWORD \
            VAULT_AZURE_CLIENT_ID VAULT_AZURE_SECRET VAULT_AZURE_SUBSCRIPTION_ID VAULT_AZURE_TENANT; do
            if [ -z "${!var}" ]; then
                echo "❌ La variable $var est vide dans .env. Veuillez la renseigner."
                exit 1
            fi
        done
    else
        echo "ℹ️ Mode Cloud Shell détecté : validation stricte désactivée."
    fi
}

create_vault_password_file() {
    echo "$ANSIBLE_VAULT_PASSWORD" > .vault_pass
    chmod 600 .vault_pass
}

create_encrypted_vault_file() {
    VAULT_FILE="vars/vault.yml"
    mkdir -p vars

    if [ ! -f "$VAULT_FILE" ]; then
        echo "🔐 Création du fichier $VAULT_FILE (chiffré en entier)..."

        cat > "$VAULT_FILE" <<EOL
---
azure_client_id: ${VAULT_AZURE_CLIENT_ID}
azure_secret: ${VAULT_AZURE_SECRET}
azure_subscription_id: ${VAULT_AZURE_SUBSCRIPTION_ID}
azure_tenant: ${VAULT_AZURE_TENANT}
admin_password: ${VAULT_VM_ADMIN_PASSWORD}
EOL

        ansible-vault encrypt "$VAULT_FILE" --vault-password-file .vault_pass
        echo "✅ Fichier $VAULT_FILE chiffré avec succès."
    fi
}

run_playbook() {
    echo "🚀 Lancement du déploiement avec Ansible..."
    ansible-playbook main.yml --vault-password-file .vault_pass
}

cleanup() {
    rm -f .vault_pass
}

check_status() {
    if [ $? -eq 0 ]; then
        echo "✅ Déploiement Azure terminé avec succès !"
    else
        echo "❌ Erreur pendant le déploiement."
        exit 1
    fi
}

# =============================
# EXECUTION PRINCIPALE
# =============================

check_requirements
check_azure_login
create_env_if_missing
load_env
validate_variables
create_vault_password_file
create_encrypted_vault_file
run_playbook
cleanup
check_status
