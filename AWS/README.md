# Déploiement AWS avec Ansible

Ce projet automatise le déploiement d'infrastructure AWS en utilisant Ansible, avec une gestion sécurisée des secrets via Ansible Vault.

## Structure du Projet

```
AWS/
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
│       ├── 01_create_vpc.yml
│       ├── 02_create_subnet.yml
│       ├── 03_create_security_group.yml
│       ├── 04_create_route_table.yml
│       ├── 05_create_internet_gateway.yml
│       └── 06_create_ec2.yml
```

## Prérequis

- Ansible installé
- AWS CLI installé et configuré
- Accès à un compte AWS avec les permissions nécessaires

## Configuration

1. **Variables d'Environnement**
   - Le fichier `.env` est créé automatiquement lors de la première exécution
   - Remplissez les variables avec vos informations AWS :
     ```bash
     # Credentials AWS
     AWS_ACCESS_KEY_ID=votre_access_key
     AWS_SECRET_ACCESS_KEY=votre_secret_key
     AWS_REGION=votre_region

     # Mot de passe pour le vault Ansible
     ANSIBLE_VAULT_PASSWORD=votre_mot_de_passe_vault

     # Variables pour le vault
     VAULT_AWS_ACCESS_KEY=votre_access_key
     VAULT_AWS_SECRET_KEY=votre_secret_key
     VAULT_AWS_REGION=votre_region
     VAULT_EC2_ADMIN_PASSWORD=votre_mot_de_passe_ec2
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
   # Vérifier la configuration AWS
   aws configure list

   # Vérifier les credentials
   aws sts get-caller-identity
   ```

2. **Exécution**
   ```bash
   # Rendre le script exécutable
   chmod +x deploy.sh

   # Lancer le déploiement
   ./deploy.sh
   ```

## Ressources Créées

Le playbook crée les ressources AWS suivantes :
- VPC
- Sous-réseaux (public et privé)
- Groupe de sécurité
- Table de routage
- Passerelle Internet
- Instance EC2

## Sécurité

- Les mots de passe et secrets sont stockés de manière sécurisée dans `vault.yml`
- Le fichier `.vault_pass` est créé temporairement pendant l'exécution
- Les permissions sont restreintes sur les fichiers sensibles
- Le fichier `.env` ne doit pas être commité dans le dépôt Git

## Dépannage

1. **Erreur de Connexion AWS**
   ```bash
   # Vérifier la configuration
   aws configure list
   # Vérifier les credentials
   aws sts get-caller-identity
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

## Maintenance

- Mettre à jour régulièrement les versions des ressources AWS
- Vérifier les règles de sécurité dans les groupes de sécurité
- Sauvegarder régulièrement le fichier `vault.yml`
- Maintenir à jour les variables dans `.env`

## Contribution

1. Fork le projet
2. Créer une branche pour votre fonctionnalité
3. Commiter vos changements
4. Pousser vers la branche
5. Créer une Pull Request

## Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
