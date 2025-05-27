# #!/bin/bash

# # Vérifier si les variables d'environnement sont définies
# if [ ! -f .env ]; then
#     echo "Le fichier .env n'existe pas. Veuillez le créer avec vos credentials Azure."
#     exit 1
# fi

# # Charger les variables d'environnement
# source .env

# Vérifier les prérequis
echo "Vérification des prérequis..."
command -v ansible >/dev/null 2>&1 || { echo "Ansible n'est pas installé. Installation..."; pip install ansible; }
command -v az >/dev/null 2>&1 || { echo "Azure CLI n'est pas installé. Installation..."; pip install azure-cli; }

# Installer les collections Ansible nécessaires
ansible-galaxy collection install azure.azcollection

# Exécuter le playbook
echo "Déploiement de l'infrastructure Azure..."
ansible-playbook main.yml

# Vérifier le statut du déploiement
if [ $? -eq 0 ]; then
    echo "Déploiement réussi !"
else
    echo "Erreur lors du déploiement."
    exit 1
fi 