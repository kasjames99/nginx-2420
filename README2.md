Assuming you have ArchLinux running on a DigitalOcean droplet:

# Update the system

Run `sudo pacman -Syu` to update and synchronize your database with the newest software.


# Setting up the project directory

We will first create a directory called `/web/html/nginx-2420`, which will serve as the project root. This directory will hold the website documents.

Run `sudo mkdir -p /web/html/nginx-2420` to create the directory, and any necessary parent directories by adding the `-p` flag.

# Downloading Vim

Running `sudo pacman -S vim` will download and install vim to archlinux for use.

# Downloading nginx

NGINX is a http server and reverse proxy. running `sudo pacman -S nginx` will download it for use. -S will sync the databases and repositories in `/etc/pacman.conf`

# configuring nginx

You'll now want to change directory into the nginx location using `cd /etc/nginx/`.

We will create a new server block for nginx-2420 using `sudo vim sites-available/nginx-2420`

Inside this file, type `i` to enter insert mode, and add the following configuration:

```
server {
    listen 80; 
    #This line specifies that the server will listen on port 80
    server_name <droplet_ip>; 
    #enter your droplet IP address here

    root /web/html/nginx-2420; 
    #This line sets the root directory of the server
    index index.html; 
    #This line specifies the default file to serve when a directory is requested

    location / {
        try_files $uri $uri/ =404;
    }
}
```
You can find your digitalocean IP under 'server details' in your digitalocean account.

Once copied, press `esc` to exit insert mode, and type `:wq` to save the file changes.

Create a symbolic link to enable the server block by running `sudo ln -s /etc/nginx/sites-available/nginx-2420 /etc/nginx/sites-enabled/`. 
`ln -s` creates the symbolic link, and the `-s` flag specifies the link being created is symbolic. 

`/etc/nginx/sites-available/nginx-2420` this will be the source file for the directory, 

`/etc/nginx/sites-enabled/` while this will be the destination directory where the symbolic link will be created. 

When nginx starts, it reads the config files in this directory and applies them.

# Setting up the demo document

Create the new HTML file for the demo document using `sudo vim /web/html/nginx-2420/index.html`. This will open up a vim text editor. Press `i` to enter insert mode, and paste the following into the editor:

```<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>2420</title>
    <style>
        * {
            color: #db4b4b;
            background: #16161e;
        }
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        h1 {
            text-align: center;
            font-family: sans-serif;
        }
    </style>
</head>
<body>
    <h1>All your base are belong to us</h1>
</body>
</html>
```
Press `:wq` to save changes and exit the file.

# Managing Nginx

Start nginx by running `sudo systemctl start nginx`

Enable nginx to start on boot by running `sudo systemctl enable nginx`

Check the status of nginx to ensure it's running using `sudo systemctl status nginx`

# Accessing the demo page

Open a web browser and enjter your droplet's IP address. You should see the demo page with the message "All your base are belong to us"

