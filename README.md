# Remote SSH Access Behind Firewall
This repository contains documentation and guides for establishing secure remote SSH access to systems located behind restrictive firewalls or NAT, utilizing a reverse SSH proxy via a jump host.

## Purpose
Many client machines are situated behind firewalls and do not have public IP addresses, making direct inbound SSH connections impossible. This setup provides a robust and secure method to bypass these limitations by leveraging a publicly accessible jump host as an intermediary.

## How it Works
The core concept relies on SSH reverse tunneling. Instead of an external machine directly connecting to the client, the client machine initiates an outbound SSH connection to a publicly available jump host. This connection creates a tunnel. The jump host then listens on a specific port, and any incoming connections to that port are securely forwarded through the established tunnel back to the client's SSH service (port 22). This allows authorized external machines to connect to the client indirectly via the jump host.

## Documentation
This repository includes the following detailed guides:

- SSH Remote Connect Behind Firewall: Comprehensive guide for setting up the reverse tunnel from the client side and connecting from an authorized machine.

- Server Setup: Instructions for configuring the jump host (proxy server), including key management and tunnel restrictions.

- Root Access: Various methods for temporarily gaining root access on a remote system, which might be necessary for initial setup or maintenance.

## Getting Started
To get started, follow the instructions in the [server setup](docs/server_setup.md) to configure your jump host, then proceed with the [client and connection setup](docs/ssh_remote_connect.md). For temporary root access use this [guideline](docs/root_access.md).

https://remote-connect.miraitech.dev/
