# Solutions Cloud avec Ansible Automation Platform

Ce dépôt contient des playbooks et scripts Ansible pour le provisionnement de machines virtuelles dans les environnements cloud Azure, AWS et GCP. Ces playbooks offrent une méthode simple pour déployer et configurer des machines virtuelles dans le cloud, et peuvent être facilement personnalisés selon vos besoins spécifiques.

## Prérequis
Pour utiliser ces playbooks, vous aurez besoin de :

* Un abonnement valide au service cloud souhaité (Azure, AWS ou GCP)
* Ansible Automation Platform installé sur votre machine locale ou sur un serveur distant
* Un fichier d'inventaire spécifiant l'environnement cloud cible et les identifiants nécessaires
* Les collections Ansible appropriées pour chaque cloud provider

## Structure du Projet

```
.
├── AWS/                    # Playbooks pour AWS
├── Azure/                  # Playbooks pour Azure
├── GCP/                    # Playbooks pour GCP
└── README.md              # Documentation principale
```

## Sécurité

Les informations sensibles (mots de passe, clés API, etc.) sont gérées de manière sécurisée via :
- Des fichiers de variables chiffrés avec Ansible Vault
- Des variables d'environnement
- Des secrets stockés dans un gestionnaire de secrets externe

## Utilisation

Pour chaque cloud provider, un script `deploy.sh` est fourni pour faciliter le déploiement :

```bash
# Pour AWS
cd AWS/Workflow
./deploy.sh

# Pour Azure
cd Azure/Workflow
./deploy.sh

# Pour GCP
cd GCP/Workflow
./deploy.sh
```

## Templates de Workflow et Jobs

Des templates de workflow et de jobs sont inclus dans ce dépôt pour une utilisation avec Ansible Automation Platform. Ces templates fournissent une interface graphique pour exécuter les playbooks et scripts, et peuvent être facilement personnalisés.

Pour utiliser ces templates :
* Importer les templates dans Ansible Automation Platform
* Créer un nouveau workflow ou job en utilisant le template importé
* Mettre à jour les variables et options selon vos besoins
* Exécuter le workflow ou le job

## Documentation

Chaque dossier cloud contient sa propre documentation détaillée :
- [Documentation AWS](AWS/README.md)
- [Documentation Azure](Azure/README.md)
- [Documentation GCP](GCP/README.md)

## Support

Pour toute question ou problème, veuillez créer une issue dans ce dépôt.

