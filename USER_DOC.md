# User Documentation

Hey! If you're an end user or administrator trying to figure out how to interact with my Inception project stack, this guide is for you.

## Understanding the Services
My project stack gives you a secure, fully functional web infrastructure made up of:
- **NGINX:** A web server I set up to securely handle all incoming HTTPS requests.
- **WordPress:** The Content Management System (CMS) I used so you can easily build and manage the website.
- **MariaDB:** A relational database that sits in the background. WordPress uses it to store all the website data, users, and content.

## Starting and Stopping the Project
I made things super easy by using a `Makefile` at the root of the repository.

- **To start everything up:** Just open a terminal in the root directory and run:
  ```bash
  make
  ```
  *(This will automatically create the necessary data folders and launch all my services in the background.)*

- **To stop the project:** Run:
  ```bash
  make down
  ```

## Accessing the Website and Administration Panel
Once you've got the project running:
- **Website:** Open your web browser and head over to `https://mel-mouh.42.fr` (just make sure you accept the self-signed SSL certificate I generated).
- **Administration Panel:** If you need to manage the site, go to `https://mel-mouh.42.fr/wp-admin` and log in with the administrator credentials.

## Locating and Managing Credentials
I kept security in mind, so all credentials and configuration variables are strictly separated from the codebase:
- **Environment Variables:** You'll find these in the `.env` file at the root of the repository.
- **Secrets:** For the really sensitive stuff (like database passwords), I stored them securely as text files in the `secrets/` directory at the root (e.g., `secrets/db_password.txt`). 
*Note: Please don't commit these files to version control!*

## Checking Service Status
If you want to make sure everything I built is running smoothly, you can run this command in your terminal:
```bash
docker ps
```
You should see three running containers named `nginx`, `wordpress`, and `mariadb`. Their status should say "Up". If something looks broken, you can always check the logs of a specific service by running:
```bash
docker logs <container_name>
```
