*This project has been created as part of the 42 curriculum by mel-mouh.*

## Description
Hey there! Welcome to my "Inception" project. The goal here is to dive deep into system administration by using Docker. I had to set up a small infrastructure with different services running in separate containers under some pretty strict rules. The main objective was to build a fully functional LEMP/LNMP stack (NGINX, MariaDB, WordPress) using Docker Compose. The catch? No pre-made images or shortcuts allowed. I had to build everything from scratch, which forced me to really understand how these services are configured and how they talk to each other.

## Instructions
If you want to build and test my project:
1. Make sure your host has the proper domain mapping. You'll need to add `mel-mouh.42.fr` to `127.0.0.1` in your `/etc/hosts` file.
2. Provide the necessary credentials in the `.env` file at the root and in the `secrets/` directory.
3. Just run the following command at the root of the repository:
   ```bash
   make
   ```
4. When you're done and want to stop the containers, run `make down`.

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- **AI Usage:** I used AI as a helpful guide and sounding board while working on this project. It helped explain concepts and format this documentation, but I didn't blindly follow it. I made sure to fact-check everything, understand the core logic, and write the actual shell scripts and Dockerfiles myself.

## Project Description
I relied heavily on Docker to containerize all my services. One of my main design choices was to use Alpine Linux/Debian as a base image and install each service from scratch, linking them all together via a custom Docker network.

### Virtual Machines vs Docker
When I was learning about this, I realized Virtual Machines emulate a complete hardware system and require a full Guest OS. That makes them super heavy and resource-intensive. Docker, on the other hand, uses OS-level virtualization. My containers just share the host OS kernel, making them way lighter, faster to boot, and so much easier to deploy than bulky VMs.

### Secrets vs Environment Variables
I learned that environment variables can easily be exposed through process lists or basic inspect commands, which is a huge security risk for sensitive stuff like database passwords. So, I opted for Docker Secrets. They provide a much more secure mechanism by mounting my credentials as read-only, in-memory files inside the container. It really reduces the risk of accidental leaks.

### Docker Network vs Host Network
Using the Host Network mode removes network isolation, binding the container's services directly to the host's network. I didn't want that. Instead, I created a custom Docker Network (a bridge network). This gives me an isolated networking environment where my containers can securely communicate with each other using DNS resolution (by their container names) without exposing all their internal ports to the host—except for the ones I explicitly publish, like port 443 for NGINX.

### Docker Volumes vs Bind Mounts
Bind mounts just map a specific file or directory on the host machine to a path in the container. While they're handy, they depend a lot on the host's filesystem structure. I found Docker Volumes to be a better choice because they're fully managed by Docker and stored safely in a part of the host filesystem. This gives me better portability and safer data persistence. In my setup, I'm using local driver volumes that mimic bind mounts so my data stays persistent on the host machine even if the containers go down.