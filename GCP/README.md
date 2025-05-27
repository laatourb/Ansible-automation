# GCP Cloud Instances Provisioning with Ansible

Ce répertoire contient les playbooks Ansible pour automatiser le déploiement d'infrastructure GCP.

## Structure du projet

```
GCP/
├── Workflow/
│   ├── main.yml           # Point d'entrée principal
│   ├── vars/
│   │   ├── main.yml       # Variables avec valeurs par défaut
│   │   └── defaults.yml   # Variables par défaut
│   └── tasks/
│       ├── 01-create_network.yml
│       ├── 02-create_firewall.yml
│       └── 03-create_instance.yml
└── README.md
```

## Utilisation

Pour exécuter le playbook principal avec les variables par défaut :

```bash
ansible-playbook Workflow/main.yml
```

Pour surcharger les variables par défaut :

```bash
ansible-playbook Workflow/main.yml -e "gcp_region=europe-west1 machine_type=e2-micro"
```

## Prérequis

- Ansible installé
- GCP CLI configuré avec les credentials appropriés
- Les collections Ansible suivantes :
  - google.cloud
  - community.google

## Variables principales

- `gcp_region` : Région GCP (par défaut: europe-west1)
- `machine_type` : Type de machine (par défaut: e2-micro)
- `project_id` : ID du projet GCP
- `network_name` : Nom du réseau
- `subnet_name` : Nom du sous-réseau
