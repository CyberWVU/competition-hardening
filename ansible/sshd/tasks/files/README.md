Things to check and change based on competition:
- PasswordAuthentication to no if you are only using ssh keys
- X11 Forwarding
- PermitRootLogin -> Is this something you need?
- PubkeyAuthentication -> Are you using ssh keys?
Can also change for specific users. Ex. only allow whiteteam users to authenticate with a password