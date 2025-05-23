<!-- /qompassai/yaml/ansible/README.md -->
<!-- ------------------------------------ -->
<!-- Copyright (C) 2025 Qompass AI, All rights reserved -->

<h3> One way to set up ansible </h3>

```ansible
#~/.ansible/

├── ansible.cfg
├── galaxy_cache
│   └── api.json
├── inventory
│   ├── 00-base.yml
│   ├── 10-aws
│   │   ├── ec2.yml
│   │   └── rds.yml
│   ├── 20-cloud
│   │   ├── azure.yml
│   │   ├── digitalocean.yml
│   │   └── gcp.yml
│   ├── 30-containers
│   │   ├── docker.yml
│   │   └── kubernetes.yml
│   ├── 40-vm
│   │   ├── proxmox.yml
│   │   └── vmware.yml
│   ├── 50-net
│   │   └── netbox.yml
│   ├── constructed.yml
│   └── hosts.ini
├── playbooks
│   ├── blaze.nvim
│   ├── gh
│   │   └── update-gh-meta.yml
│   ├── ghinit.yml
│   ├── gito.yml
│   ├── mojo
│   │   └── mojodocs.yml
│   ├── qai
│   │   └── update-qai.yml
│   ├── qpg
│   │   ├── buildqpg.yml
│   │   └── qpg-config.yml
│   └── run_tests.yml
├── requirements.yml
├── roles
├── tmp
└── vars
    └── logs

18 directories, 24 files
```
