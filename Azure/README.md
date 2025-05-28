# Déploiement Azure avec Ansible

Ce projet automatise le déploiement d'infrastructure Azure en utilisant Ansible, avec une gestion sécurisée des secrets via Ansible Vault.

## Structure du Projet

```
Azure/
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
│       ├── 01_create_rg.yml
│       ├── 02_create_vnet.yml
│       ├── 03_create_subnet.yml
│       ├── 04_create_nsg.yml
│       ├── 05_create_nic.yml
│       ├── 06_create_pip.yml
│       └── 07_create_vm.yml
```

## Prérequis

- Ansible installé
- Azure CLI installé et configuré
- Accès à un compte Azure avec les permissions nécessaires

## Configuration

1. **Variables d'Environnement**
   - Le fichier `.env` est créé automatiquement lors de la première exécution
   - Remplissez les variables avec vos informations Azure :
     ```bash
     # Credentials Azure
     AZURE_SUBSCRIPTION_ID=votre_subscription_id
     AZURE_TENANT_ID=votre_tenant_id
     AZURE_CLIENT_ID=votre_client_id
     AZURE_CLIENT_SECRET=votre_client_secret

     # Mot de passe pour le vault Ansible
     ANSIBLE_VAULT_PASSWORD=votre_mot_de_passe_vault

     # Variables pour le vault
     VAULT_AZURE_CLIENT_ID=votre_client_id
     VAULT_AZURE_SECRET=votre_client_secret
     VAULT_AZURE_SUBSCRIPTION_ID=votre_subscription_id
     VAULT_AZURE_TENANT=votre_tenant_id
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
   # Vérifier la connexion Azure
   az login

   # Vérifier l'abonnement actif
   az account show
   ```

2. **Exécution**
   ```bash
   # Rendre le script exécutable
   chmod +x deploy.sh

   # Lancer le déploiement
   ./deploy.sh
   ```

## Ressources Créées

Le playbook crée les ressources Azure suivantes :
- Groupe de ressources
- Réseau virtuel
- Sous-réseau
- Groupe de sécurité réseau
- Interface réseau
- Adresse IP publique
- Machine virtuelle

## Sécurité

- Les mots de passe et secrets sont stockés de manière sécurisée dans `vault.yml`
- Le fichier `.vault_pass` est créé temporairement pendant l'exécution
- Les permissions sont restreintes sur les fichiers sensibles
- Le fichier `.env` ne doit pas être commité dans le dépôt Git

## Dépannage

1. **Erreur de Connexion Azure**
   ```bash
   # Vérifier la connexion
   az login
   # Vérifier l'abonnement
   az account show
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

