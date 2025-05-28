#!/bin/bash

set -e

# =============================================
# Script de déploiement AWS avec Ansible
# =============================================

check_requirements() {
    for cmd in ansible aws; do
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
# Credentials AWS (valeurs factices pour test)
AWS_ACCESS_KEY_ID=FAKEACCESSKEY123456
AWS_SECRET_ACCESS_KEY=FakeSecretKeyForTesting1234567890
AWS_DEFAULT_REGION=us-east-1

# Mot de passe Ansible Vault
ANSIBLE_VAULT_PASSWORD=Bilal123\$*!

# Variables pour le vault
VAULT_AWS_ACCESS_KEY=FAKEACCESSKEY123456
VAULT_AWS_SECRET_KEY=FakeSecretKeyForTesting1234567890
VAULT_AWS_REGION=us-east-1
VAULT_EC2_ADMIN_PASSWORD=Bilal123\$*!
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

validate_variables() {
    for var in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION ANSIBLE_VAULT_PASSWORD VAULT_AWS_ACCESS_KEY VAULT_AWS_SECRET_KEY VAULT_AWS_REGION VAULT_EC2_ADMIN_PASSWORD; do
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
aws_access_key: ${VAULT_AWS_ACCESS_KEY}
aws_secret_key: ${VAULT_AWS_SECRET_KEY}
aws_region: ${VAULT_AWS_REGION}
ec2_admin_password: ${VAULT_EC2_ADMIN_PASSWORD}
EOL

        ansible-vault encrypt "$VAULT_FILE" --vault-password-file .vault_pass
        echo "✅ Fichier $VAULT_FILE chiffré avec succès."
    fi
}

run_playbook() {
    echo "🚀 Démarrage du déploiement AWS..."
    ansible-playbook main.yml --vault-password-file .vault_pass
}

cleanup() {
    rm -f .vault_pass
}

check_status() {
    if [ $? -eq 0 ]; then
        echo "✅ Déploiement AWS terminé avec succès !"
    else
        echo "❌ Erreur pendant le déploiement."
        exit 1
    fi
}

# ================
# EXECUTION
# ================

check_requirements
create_env_if_missing
load_env
validate_variables
create_vault_password_file
create_encrypted_vault_file
run_playbook
cleanup
check_status
