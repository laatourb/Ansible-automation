# AWS Automation avec Ansible

Ce répertoire contient les playbooks Ansible pour automatiser le déploiement d'infrastructure AWS.

## Structure du projet

```
AWS/
├── Workflow/
│   ├── main.yml           # Point d'entrée principal
│   ├── vars/
│   │   ├── main.yml       # Variables avec valeurs par défaut
│   │   └── defaults.yml   # Variables par défaut
│   └── tasks/
│       ├── 01-create_vpc.yml
│       ├── 02-create_security_group.yml
│       └── 03-create_ec2.yml
└── README.md
```

## Utilisation

Pour exécuter le playbook principal avec les variables par défaut :

```bash
ansible-playbook Workflow/main.yml
```

Pour surcharger les variables par défaut :

```bash
ansible-playbook Workflow/main.yml -e "aws_region=us-east-1 instance_type=t3.micro"
```

## Prérequis

- Ansible installé
- AWS CLI configuré avec les credentials appropriés
- Les collections Ansible suivantes :
  - amazon.aws
