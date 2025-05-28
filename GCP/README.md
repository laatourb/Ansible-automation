# Déploiement GCP avec Ansible

Ce projet automatise le déploiement d'infrastructure Google Cloud Platform (GCP) en utilisant Ansible, avec une gestion sécurisée des secrets via Ansible Vault.

## Structure du Projet

```
GCP/
├── Workflow/
│   ├── deploy.sh           # Script principal de déploiement
│   ├── main.yml           # Playbook principal
│   ├── .env               # Variables d'environnement (créé automatiquement)
│   ├── .vault_pass        # Mot de passe pour Ansible Vault (généré automatiquement)
│   ├── vars/
│   │   ├── main.yml       # Variables principales
│   │   ├── defaults.yml   # Variables par défaut
│   │   └── vault.yml      # Variables sensibles chiffrées
│   └── tasks/
│       ├── 01_create_network.yml
│       ├── 02_create_subnet.yml
│       ├── 03_create_firewall.yml
│       ├── 04_create_router.yml
│       ├── 05_create_nat.yml
│       └── 06_create_vm.yml
```

## Prérequis

- Ansible installé
- Google Cloud SDK installé et configuré
- Accès à un projet GCP avec les permissions nécessaires

## Configuration

1. **Variables d'Environnement**
   - Le fichier `.env` est créé automatiquement lors de la première exécution
   - Remplissez les variables avec vos informations GCP :
     ```bash
     # Credentials GCP
     GCP_PROJECT_ID=votre_project_id
     GCP_AUTH_KIND=serviceaccount
     GCP_SERVICE_ACCOUNT_FILE=chemin/vers/service-account.json
     GCP_REGION=votre_region

     # Mot de passe pour le vault Ansible
     ANSIBLE_VAULT_PASSWORD=votre_mot_de_passe_vault

     # Variables pour le vault
     VAULT_GCP_PROJECT_ID=votre_project_id
     VAULT_GCP_SERVICE_ACCOUNT_FILE=chemin/vers/service-account.json
     VAULT_GCP_REGION=votre_region
     VAULT_VM_ADMIN_PASSWORD=votre_mot_de_passe_vm
     ```

2. **Gestion des Secrets**
   - Les variables sensibles sont stockées dans `vars/vault.yml`
   - Ce fichier est automatiquement chiffré lors de la première exécution
   - Pour voir le contenu :
     ```bash
     ansible-vault view vars/vault.yml --vault-password-file .vault_pass
     ```
   - Pour modifier le contenu :
     ```bash
     ansible-vault edit vars/vault.yml --vault-password-file .vault_pass
     ```

## Déploiement

1. **Préparation**
   ```bash
   # Vérifier la configuration GCP
   gcloud config list

   # Vérifier l'authentification
   gcloud auth list
   ```

2. **Exécution**
   ```bash
   # Rendre le script exécutable
   chmod +x deploy.sh

   # Lancer le déploiement
   ./deploy.sh
   ```

## Ressources Créées

Le playbook crée les ressources GCP suivantes :
- Réseau VPC
- Sous-réseaux
- Règles de pare-feu
- Routeur Cloud
- NAT Gateway
- Instance Compute Engine

## Sécurité

- Les mots de passe et secrets sont stockés de manière sécurisée dans `vault.yml`
- Le fichier `.vault_pass` est créé temporairement pendant l'exécution
- Les permissions sont restreintes sur les fichiers sensibles
- Le fichier `.env` ne doit pas être commité dans le dépôt Git

## Dépannage

1. **Erreur de Connexion GCP**
   ```bash
   # Vérifier la configuration
   gcloud config list
   # Vérifier l'authentification
   gcloud auth list
   ```

2. **Erreur de Vault**
   ```bash
   # Vérifier le contenu du vault
   ansible-vault view vars/vault.yml --vault-password-file .vault_pass
   # Recréer le vault si nécessaire
   rm vars/vault.yml
   ./deploy.sh
   ```

3. **Erreur de Variables**
   - Vérifier que toutes les variables sont définies dans `.env`
   - Vérifier les permissions sur les fichiers
   - Vérifier la syntaxe des variables dans `vars/main.yml`


