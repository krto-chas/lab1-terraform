#!/bin/bash
apt-get update
apt-get install -y ufw fail2ban unattended-upgrades auditd

# Enable firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable

# Enable automatic security updates
dpkg-reconfigure -plow unattended-upgrades

# Basic SSH hardening
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart ssh || systemctl restart sshd

# Enable audit daemon
systemctl enable --now auditd

echo "Startup script completed at $(date)" > /var/log/startup-complete.log