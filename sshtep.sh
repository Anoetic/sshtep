#!/bin/bash

SSH_KEY_DIR="$HOME/.ssh"
DEFAULT_PRIVATE_KEY="$SSH_KEY_DIR/id_rsa"
DEFAULT_PUBLIC_KEY="$DEFAULT_PRIVATE_KEY.pub"
PRIVATE_KEY="$DEFAULT_PRIVATE_KEY"
PUBLIC_KEY="$DEFAULT_PUBLIC_KEY"
SSH_CONF_FILE="$SSH_KEY_DIR/config"
TARGET=""
USER_NAME=$(whoami)
PORT=""
SHORTCUT=""
PROXYJUMP=""

generate_keys() {
    echo "Generating new SSH key pair..."
    ssh-keygen -t rsa -b 4096 -f "$PRIVATE_KEY" -N ""
}

add_public_key() {
    PUB_KEY_CONTENT=$(cat "$PUBLIC_KEY")
    echo "echo '$PUB_KEY_CONTENT' >> ~/.ssh/authorized_keys"
}

configure_ssh_conf() {
    echo "Host $SHORTCUT
    HostName $TARGET" >> "$SSH_CONF_FILE"

    # Add port 
    if [ -n "$PORT" ]; then
        echo "    Port $PORT" >> "$SSH_CONF_FILE"
    fi

    echo "    User $USER_NAME
    IdentityFile $PRIVATE_KEY" >> "$SSH_CONF_FILE"

    # Add ProxyJump 
    if [ -n "$PROXYJUMP" ]; then
        echo "    ProxyJump $PROXYJUMP" >> "$SSH_CONF_FILE"
    fi

    echo "SSH configuration updated for target $TARGET with shortcut '$SHORTCUT'."
}

# Help screen
usage() {
    echo "Usage: $0 [-g] [-t <target>] [-u <username>] [-k <key path>] [-s <shortcut>] [-p <port>] [-j <proxyjump>] [-h]"
    echo "  -g              Generate a new SSH key pair"
    echo "  -t <target>     Set the target for automatic SSH connection"
    echo "  -u <username>   Specify the username for SSH connection (default: current user)"
    echo "  -k <key path>   Specify the private key file to use (default: ~/.ssh/id_rsa)"
    echo "  -s <shortcut>   Specify the shortcut to use for the SSH connection"
    echo "  -p <port>       Specify the port to use for the connection"
    echo "  -j <proxyjump>  Specify the ProxyJump host"
    echo "  -h              Show help message"
}

GENERATE_KEY=false

# Parse options
while getopts "gt:u:k:s:p:j:h" opt; do
    case ${opt} in
        g) GENERATE_KEY=true ;;
        t) TARGET=$OPTARG ;;
        u) USER_NAME=$OPTARG ;;
        k) PRIVATE_KEY=$OPTARG; PUBLIC_KEY="${PRIVATE_KEY}.pub" ;;
        s) SHORTCUT=$OPTARG ;;
        p) PORT=$OPTARG ;;
        j) PROXYJUMP=$OPTARG ;;
        h) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done

# Makes sure a target and shortcut name are provided
if [ -z "$TARGET" ]; then
    echo "Error: Target (-t) is required."
    exit 1
fi

if [ -z "$SHORTCUT" ]; then
    echo "Error: Shortcut (-s) is required."
    exit 1
fi

# Generate SSH key pair if the -g flag is provided
if $GENERATE_KEY; then
    generate_keys
fi

# Check if specified or default SSH keys exist
if [ ! -f "$PRIVATE_KEY" ] || [ ! -f "$PUBLIC_KEY" ]; then
    echo "SSH key pair not found. Please generate one using the -g flag or specify a valid key pair with -k."
    exit 1
fi

# Display public key command
add_public_key

# Configure SSH if target is specified
configure_ssh_conf