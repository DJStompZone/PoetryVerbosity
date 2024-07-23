#!/bin/bash

# Poetry Verbosity Wrapper Setup Script

# This script sets up a wrapper for the Poetry command to control verbosity
# via the POETRY_VERBOSITY environment variable. It ensures that the wrapper
# takes precedence over the default Poetry command.

# Directory to place the wrapper script
WRAPPER_DIR="$HOME/.local/bin"

# Ensure the directory exists
mkdir -p "$WRAPPER_DIR"

# Path to the wrapper script
WRAPPER_PATH="$WRAPPER_DIR/poetry"

# Create the wrapper script
cat << 'EOF' > "$WRAPPER_PATH"
#!/bin/bash

# Poetry Verbosity Wrapper

# Checks for $POETRY_VERBOSITY environment variable
# Appends -v flags based on the value, if present (0-3)
# Will just invoke poetry normally if unset or set to 0

# Author: DJ Stomp <https://github.com/DJStompZone>
# Source: https://github.com/DJStompZone/PoetryVerbosity
# License: MIT

PVERBOSITY=""

# Set verbosity flag based on environment variable
case "$POETRY_VERBOSITY" in
  "1")
    PVERBOSITY="-v"
    ;;
  "2")
    PVERBOSITY="-vv"
    ;;
  "3")
    PVERBOSITY="-vvv"
    ;;
  *)
    PVERBOSITY=""
    ;;
esac

# Function to find the correct Python executable
find_python_executable() {
    if command -v python &>/dev/null; then
        echo "python"
    elif [ -n "$VIRTUAL_ENV" ]; then
        echo "$VIRTUAL_ENV/bin/python"
    elif command -v python3 &>/dev/null; then
        echo "python3"
    else
        echo ""
    fi
}

# Get the Python executable
PYTHON_EXECUTABLE=$(find_python_executable)

# Check if a Python executable was found
if [ -z "$PYTHON_EXECUTABLE" ]; then
    echo "Python could not be found. Please ensure Python is installed and available in your PATH."
    exit 1
fi

# Invoke the original poetry command with the verbosity flag
$PYTHON_EXECUTABLE -m poetry "$@" $PVERBOSITY
EOF

# Make the wrapper script executable
chmod +x "$WRAPPER_PATH"

# Function to add the wrapper directory to PATH in a given profile file
add_to_path() {
    local profile_file="$1"
    if ! grep -q "$WRAPPER_DIR" "$profile_file"; then
        echo "export PATH=\"$WRAPPER_DIR:\$PATH\"" >> "$profile_file"
        echo "Added $WRAPPER_DIR to PATH in $profile_file"
    fi
}

# Add the wrapper directory to PATH in relevant shell profiles
if [ -f "$HOME/.profile" ]; then
    add_to_path "$HOME/.profile"
fi
if [ -f "$HOME/.$(basename $SHELL)rc" ]; then
    add_to_path "$HOME/.$(basename $SHELL)rc"
fi
if [ -f "$HOME/.$(basename $SHELL)_profile" ]; then
    add_to_path "$HOME/.$(basename $SHELL)_profile"
fi

# Source the profiles to update the current session
if [ -f "$HOME/.profile" ]; then
    source "$HOME/.profile"
fi
if [ -f "$HOME/.$(basename $SHELL)rc" ]; then
    source "$HOME/.$(basename $SHELL)rc"
fi
if [ -f "$HOME/.$(basename $SHELL)_profile" ]; then
    source "$HOME/.$(basename $SHELL)_profile"
fi

# Verify the override
if command -v poetry | grep -q "$WRAPPER_DIR"; then
  echo "Poetry wrapper script successfully installed and overriding the default poetry command."
else
  echo "Failed to override the default poetry command. Please check your PATH."
fi
