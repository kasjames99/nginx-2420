#!/bin/bash

# Load configuration from the config file
CONFIG_FILE="/etc/mkuser.conf"
LOGIN_SHELL=$(<"$CONFIG_FILE")

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run with sudo or as root."
    exit 1
fi

# Check if configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found."
    exit 1
fi

# Check if username is provided
if [ -z "${1}" ]; then
    echo "Usage: sudo ./mkuser username"
    exit 1
fi

# Trim leading and trailing spaces from username
USERNAME=$(echo "${1}" | xargs)

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
    echo "Error: User '$USERNAME' already exists."
    exit 1
fi

# Generate a unique UID and GID
NEW_UID=$(date +%s)  # Using timestamp as UID
NEW_GID=$(date +%s)  # Using timestamp as GID

# Create the user's home directory
mkdir -p "/home/$USERNAME"

# Set ownership and permissions for the home directory
chown "$USERNAME:$USERNAME" "/home/$USERNAME"
chmod 755 "/home/$USERNAME"

# Set the login shell for the user
echo "$LOGIN_SHELL" >> "/home/$USERNAME/.bashrc"

echo "User '$USERNAME' created with UID $NEW_UID and GID $NEW_GID."