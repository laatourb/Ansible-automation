# Azure Virtual Machine Provisioning with Ansible

Ce répertoire contient les playbooks Ansible pour automatiser le déploiement d'infrastructure Azure.

## Structure du projet

```
Azure/
├── Workflow/
│   ├── main.yml           # Point d'entrée principal
│   ├── vars/
│   │   ├── main.yml       # Variables avec valeurs par défaut
│   │   └── defaults.yml   # Variables par défaut
│   └── tasks/
│       ├── 01-create_resource_group.yml
│       ├── 02-create_vnet.yml
│       └── 03-create_vm.yml
└── README.md
```

## Utilisation

Pour exécuter le playbook principal avec les variables par défaut :

```bash
ansible-playbook Workflow/main.yml
```

Pour surcharger les variables par défaut :

```bash
ansible-playbook Workflow/main.yml -e "azure_location=francecentral vm_size=Standard_B1s"
```

## Prérequis

- Ansible installé
- Azure CLI configuré avec les credentials appropriés
- Les collections Ansible suivantes :
  - azure.azcollection
  - community.azure

## Variables principales

- `azure_location` : Région Azure (par défaut: francecentral)
- `vm_size` : Taille de la machine virtuelle (par défaut: Standard_B1s)
- `resource_group_name` : Nom du groupe de ressources
- `vnet_name` : Nom du réseau virtuel
- `subnet_name` : Nom du sous-réseau
