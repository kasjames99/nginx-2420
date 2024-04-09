This will be a continuation of the first tutorial. Assuming you have 

# UFW Installation

UFW stands for Uncomplicated Firewall. It will help manage iptables, the default management tool for ArchLinux.

1) install UFW using ```Bash sudo pacman -S ufw```. 

Sudo will use elevated privleges to find and install UFW using 'apt-get install ufw'

2) Allow SSH using 'sudo ufw allow ssh'.

This allows SSH connections, and since we're running a digitalocean droplet connecting to SSH, we must ensure that this is allowed first.

3) Allow HTTP and HTTPS traffic using:

'sudo ufw allow http'
'sudo ufw allow https'

This will allow traffic through the firewall, ensuring the web server can serve content through both HTTP and HTTPS protocols.

3) Enable and start UFW using 'sudo systemctl enable --now ufw.service'.

This enables and starts the Uncomplicated Firewall, starting default policies and configuring it to start at boot.

4) Ensure ufw is running using 'sudo ufw status'

This should return inactive if you have just installed ufw for the first time.

# Transfer Backend Binary and Create systemd Service

Here we will transfer the backend binary to your server using SFTP, placing the binary in a logical directory (/opt/backend/hello-server)

1) Create a systemd service file using 'sudo vim /etc/systemd/system/hello-server.service'

Add the following content to the file:

```Bash
[Unit]
Description=Backend Service
After=network.target

[Service]
Type=simple
ExecStart=/opt/backend/hello-server
Restart=always

[Install]
WantedBy=multi-user.target
```

2) Reload the system and start the backend service using these three commands:

'sudo systemctl daemon-reload'
'sudo systemctl start backend'
'sudo systemctl enable backend'

These commands reload the configuration file, which is necessary after changes, since systemd needs to be notified to update. This doesn't start or stop any services, only reloads the config.

These commands will also set backend to start automatically at startup.

3) Download the backend server from the github attachments location here: https://gitlab.com/cit2420/2420_notes_w24/-/tree/main/attachments?ref_type=heads

4) Using SFTP, use your arch username followed by your droplet IP to open a connection from your local machine to your droplet, using the command line 'sftp username@your_droplet_ip'.

5) Navigate to the directory where the file is located locally using cd, ie 'cd /path/to/local' on your home system.

6) Upload hello-server to your droplet using 'put hello-server /opt/backend/'. 

7) Type 'exit' to disconnect the SFTP connection

This command will use the 'put' command to place the server in the opt/backend location. 

# Edit Nginx Server Block for Reverse Proxy

1) Open the nginx server block config file using 'sudo vim /etc/nginx/sites-available/nginx-2420'

2) Add a location block to proxy requests on the backend by copy pasting the following:

```Bash
location /backend {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
```

Type :wq to save and exit the file.

3) Test the nginx file for syntax errors using 'sudo nginx -t'

4) If there are no errors, use 'sudo systemctl reload nginx'

This reloads nginx to update the reverse proxy block.

# Testing the server

1) Ensure the backend service is running using '