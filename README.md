# EC2 Apache Automation with Ansible

After many attempts at trying to set up apache server using my ec2 instance on codespace, i finally did it!

This project demonstrates the automation of a web server deployment on an AWS EC2 instance using Ansible, managed directly from a GitHub Codespace.

## 🚀 Project Overview
This repository contains the configuration files used to bridge a cloud-based development environment (GitHub Codespaces) with a remote AWS EC2 instance to automate the installation and configuration of an Apache HTTP server.

## 🛠️ Technologies Used
* **AWS EC2**: Remote host for the web server.
* **Ansible**: Configuration management and automation tool.
* **GitHub Codespaces**: Cloud IDE used as the Ansible control node.
* **Git**: Version control for tracking progress.

## 📁 Key Files
- `inventory.ini`: Contains the connection details for the EC2 instance, including the public IP and the path to the private key.
- `install_apache.yml`: The Ansible Playbook that handles package installation, service management, and custom HTML deployment.
- `Keypair1.pem`: (Excluded from Git) The private key used for secure SSH access.

## 🔧 Configuration Steps
1.  **Connectivity**: Established SSH communication between Codespace and EC2.
2.  **Validation**: Used the `ansible -m ping` command to verify the link.
3.  **Automation**: Executed the `ansible-playbook` to:
    - Install the `httpd` package.
    - Start and enable the service.
    - Deploy a custom `index.html` landing page.

## ✅ Outcome
The server is successfully serving web content at the EC2 Public IPv4 address.
