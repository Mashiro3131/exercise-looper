# Ubuntu Server

- dev

For development, we are currently using **Tailscale**.  
Tailscale allows us to connect directly to our server instead of forwarding a port to the WAN.

## How to Set Up a VPN

### Requirements
- A running Ubuntu Server (20.04 or later recommended)
- A user account with **sudo** privileges
- Internet access on the server
- A GitHub, Google, or Microsoft account (required for Tailscale login)
- System packages up to date:
  ```bash
  sudo apt update && sudo apt upgrade -y


