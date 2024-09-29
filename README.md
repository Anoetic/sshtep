# SSHtep
SSHtep (SSH Step) is a script that automates SSH key setup and connection shortcuts.

It can generate a new key pair if needed or let you use an existing one. It also prints out a command to add your public key to the authorized keys of a remote host. Plus, it updates your SSH config so you can connect to servers using simple shortcuts, set custom ports, choose a username, and add a ProxyJump if needed.

Basically, good for automating the process of setting up ssh configs.

## Usage

```
Usage: sshtep.sh [-g] [-t <target>] [-u <username>] [-k <key path>] [-s <shortcut>] [-p <port>] [-j <proxyjump>] [-h]
  -g              Generate a new SSH key pair
  -t <target>     Set the target for automatic SSH connection
  -u <username>   Specify the username for SSH connection (default: current user)
  -k <key path>   Specify the private key file to use (default: ~/.ssh/id_rsa)
  -s <shortcut>   Specify the shortcut to use for the SSH connection
  -p <port>       Specify the port to use for the connection
  -j <proxyjump>  Specify the ProxyJump host
  -h              Show help message
```

