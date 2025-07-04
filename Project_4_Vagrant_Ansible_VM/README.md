# Project 4: Local VM + Ansible
This project provisions a local virtual machine using Vagrant and configures it using Ansible instead of traditional shell scripts. It introduces core configuration management principles such as idempotency, use of inventory files, and task-based provisioning with Ansible playbooks.

the common role is usually used for basic system setup that every machine needs, regardless of its purpose (web server, DB server, etc.).

Ansible’s Declarative Approach
that’s one of the core strengths of Ansible: you describe the desired end state, and Ansible figures out how to reach and maintain that state, without you writing imperative steps.

a small example of what makes Ansible powerful. You're writing "what" should be true, and Ansible handles the "how."