# VPN On-demand server

This project provides infrastructure-as-code and configuration management scripts to deploy a personal WireGuard VPN server on Hetzner Cloud completely on demand. It ensures you only pay for resources while the VPN server is actively running.

## How it Works

The deployment process is fully automated using GitHub Actions:

1.  **Trigger:** Manually trigger the `Manage VPN On-Demand` workflow via the GitHub Actions tab, selecting either `create` or `destroy`.
2.  **Infrastructure (Terraform):**
    * If `create` is selected, Terraform provisions the necessary Hetzner Cloud resources (server, firewall, SSH key association).
    * If `destroy` is selected, Terraform tears down all resources previously created by this project.
3.  **Pause:** After a successful `create` action, a short pause allows the new server time to fully initialize.
4.  **Configuration (Ansible):**
    * Following the pause, Ansible connects to the new server via SSH.
    * An Ansible playbook installs WireGuard, generates the server's WireGuard keys, and configures the WireGuard interface (`wg0.conf`) using a template, incorporating your client's public key.
5.  **Output:** For a `create` action, the server's public IP address and its generated WireGuard public key are printed in the GitHub Actions workflow logs. These are needed to configure your WireGuard client.
6.  **Cost Control:** The `destroy` action ensures no resources are left running, stopping costs effectively when the VPN is not needed.

## Core Technologies

* **Terraform:** For provisioning and managing Hetzner Cloud infrastructure lifecycle.
* **Ansible:** For configuring the server software (installing and setting up WireGuard).
* **GitHub Actions:** For orchestrating the workflow (triggering, running Terraform/Ansible, handling secrets, pauses).
* **Hetzner Cloud:** The target cloud provider chosen for its cost-effectiveness.
* **WireGuard:** The modern, fast, and secure VPN protocol used.

## Usage

1.  **Prerequisites:**
    * A Hetzner Cloud account and API token.
    * An SSH key pair (public key uploaded to Hetzner, private key kept secure).
    * Your WireGuard client's public key (generate locally if needed).
    * (Optional but Recommended) A Terraform Cloud account for remote state management.
2.  **Secrets:** Configure the required secrets in your GitHub repository settings (`Settings` -> `Secrets and variables` -> `Actions`):
    * **See the full list of variables and secrets in the table below**
3.  **Run Workflow:** Navigate to the "Actions" tab of your repository, select the "Manage Hetzner VPN On-Demand" workflow, choose `create` or `destroy`, and click "Run workflow".
    * Also there is `plan_create` and `plan_destroy` for just testing terraform. Does not create or destroy any resources
4.  **Configure Client:** If you ran `create`, check the completed workflow logs for the server's public IP and its WireGuard public key. Use these details, along with your client's private key, to configure your local WireGuard application.
5.  **Destroy Resources:** When you no longer need the VPN, run the workflow again selecting `destroy` to remove all cloud resources and stop incurring costs.

## TL;DR
### Runs automation on Github Actions and does the following:
- Creates VM to Hetzner cloud with firewall
- Install and configure Wireguard server
- Add server IP to DNS record on CloudFlare
- Destroys all resources after use --> no costs when not in use.
- Create and Destroy done by one click


## Variables and secrets:
Some Github variables and secrets must be set before use:

Variables for Terraform:

| Variable | Desc.|
|---|---|
|`TF_VAR_hcloud_token`| Hetzner API key |
|`TF_VAR_cloudflare_token`| CloudFlare API key |
|`TF_VAR_cloudflare_zone_id`| CloudFlare zone ID |
|`TF_VAR_domain_name`| CloudFlare domain name for VPN |
|`TF_VAR_ssh_key_name`| SSH key in Hetzner |
|`TF_TOKEN_app_terraform_io`| Terraform Cloud API key |
|`TF_CLOUD_ORGANIZATION`| Terraform Cloud Organization name |
|`TF_WORKSPACE`| Terraform Cloud Workspace name |
|`TF_VAR_ansible_ssh_pubkey`| Ansible user SSH public key |
| __Optional__ | |
|`TF_VAR_wireguard_port`| Wireguard port for firewall and config. __Default 51820__ |
|`TF_VAR_USERNAME`| You user name. __Default vpnuser__ |


Variables for Ansible:
| Variable | Desc.|
|---|---|
|`WG_SERVER_PRIVATE_KEY`| Wireguard Server private key |
|`WG_CLIENT_PUBLIC_KEY`| Wireguard client public key |
|`ANSIBLE_SSH_PRIVATE_KEY`| Ansible user SSH private key |