# Developer Documentation

Hey there, fellow dev! This file contains all the technical instructions you'll need to set up, build, and manage my Inception project environment.

## Setting Up the Environment

### Prerequisites
- Make sure you have Docker and Docker Compose installed on your machine.
- You'll also need to configure your local domain resolution. Just add this line to your `/etc/hosts` file (or `C:\Windows\System32\drivers\etc\hosts` if you're on Windows) to map the domain to localhost:
  ```text
  127.0.0.1 mel-mouh.42.fr
  ```

### Configuration Files and Secrets
I kept the configuration securely managed outside of version control. If you're setting up the environment from scratch, here's what you need to do:

1. **Environment Variables:** Create a `.env` file at the root of the repository with the necessary variables (like the database name and WordPress admin details).
2. **Secrets:** Create a `secrets/` directory at the root and add the required secret files:
   - `secrets/db_password.txt`
   - `secrets/db_root_password.txt`
   *(I set things up so these secrets are securely mounted into the MariaDB and WordPress containers using Docker Compose's `secrets` feature.)*
3. **Data Directories:** Make sure that `/home/mel-mouh/data/wordpress` and `/home/mel-mouh/data/db` exist on your machine. If they don't, my `Makefile` will try to create them automatically for you.

## Building and Launching the Project
I automated the build process using the `Makefile` in the root directory to save us some time.

- **To build and launch:**
  ```bash
  make
  # or
  make up
  ```
  This command creates the required host directories (if you don't have them yet) and runs `docker compose -f ./srcs/docker-compose.yml up --build`.

- **To rebuild from scratch (Force clean):**
  ```bash
  make re
  ```

## Managing Containers and Volumes

You can manage the containers using standard Docker commands or the handy Makefile aliases I provided.

- **Stop the project:**
  ```bash
  make down
  ```
- **Clean the environment (this stops containers and completely removes images/volumes):**
  ```bash
  make fclean
  ```
- **Inspect containers:**
  ```bash
  docker ps -a
  ```
- **Access a running container (e.g., if you need to debug NGINX):**
  ```bash
  docker exec -it nginx sh
  ```

## Project Data and Persistence

I handled data persistence by using custom local driver volumes mapped directly to directories on the host machine. 
If you check my `docker-compose.yml`:
- **WordPress Data:** It's stored on the host at `/home/mel-mouh/data/wordpress` and mounted to `/var/www/html` in the containers.
- **MariaDB Data:** It's stored on the host at `/home/mel-mouh/data/db` and mounted to `/var/lib/mysql` in the database container.

This setup ensures that even if you remove or recreate the containers, the website files and database records will safely persist on your host filesystem and be re-attached the next time you build the project.
