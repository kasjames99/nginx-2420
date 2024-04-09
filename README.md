# mkuser Script

The `mkuser` script is used to create a new user on the system with specified configurations.

## Usage

To use the `mkuser` script, follow these steps:

1. Make sure you have root privileges or run the script with `sudo`.
2. Ensure that the configuration file `/etc/mkuser.conf` exists and contains the desired login shell.
3. Run the script with the username of the new user as an argument. For example:
   ```bash
   sudo ./mkuser username
   ```
   You can replace `username` with whatever username you'd like to use.

## Notes

The script generates a unique UID and GID based on the current timestamp.

The script sets the ownership and permissions for the home directory and appends the login shell to the user's .bashrc file.

The script creates a new home directory for the user in /home/username.