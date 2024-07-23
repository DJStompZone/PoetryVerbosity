# Poetry Verbosity Wrapper Setup Script

This script sets up a wrapper for the Poetry command to control verbosity via the `POETRY_VERBOSITY` environment variable. It ensures that the wrapper takes precedence over the default Poetry command.

## Features

- Controls Poetry verbosity using the `POETRY_VERBOSITY` environment variable.
- Automatically determines the correct Python executable, whether in a virtual environment or globally.
- Updates the `PATH` to prioritize the wrapper script over the default Poetry command.
- Supports multiple shell profiles (`.profile`, `.bashrc`, `.zshrc`, and more) based on the current shell.

## Requirements

The only prerequisites for this utility are:
- A POSIX-compliant operating system (Linux, BSD, macOS)
- Python3 and `poetry` (technically optional, but strongly recommended 😅)

## Installation

1. Save [the setup script](https://github.com/DJStompZone/PoetryVerbosity/blob/main/setup-poetry-wrapper.sh) locally as `setup-poetry-wrapper.sh`.

2. Make sure the script is executable:

    ```sh
    chmod +x setup-poetry-wrapper.sh
    ```

3. Run the script:

    ```sh
    ./setup-poetry-wrapper.sh
    ```

## Usage

After running the setup script, you can control the verbosity of Poetry commands by setting the `POETRY_VERBOSITY` environment variable:

- `0` (or unset): Default verbosity.
- `1`: Verbose (`-v`).
- `2`: Very verbose (`-vv`).
- `3`: Extremely verbose (`-vvv`).

For example:

```sh
export POETRY_VERBOSITY=3
poetry install
```

This will run `poetry install` with maximally verbose output.

You can add `export POETRY_VERBOSITY=<verbosity level>` to your shell profile (e.g., `.bashrc`) if you want to persist the chosen configuration.

## How It Works

1. **Wrapper Script Creation**: The setup script creates a wrapper script that checks the `POETRY_VERBOSITY` environment variable and adjusts the verbosity of the Poetry command accordingly.
  
2. **Python Executable Detection**: The wrapper script dynamically determines the correct Python executable to use, prioritizing virtual environments if present.

3. **PATH Update**: The setup script adds the directory containing the wrapper script to the `PATH` in relevant shell profile files (e.g., `.profile`, `.$(basename $SHELL)rc`, and `.$(basename $SHELL)_profile`).

4. **Session Update**: The setup script sources the updated profile files to immediately apply the changes to the current session.

## Verification

After running the setup script, you can verify that the wrapper script is being used by checking the location of the `poetry` command:

```sh
which poetry
```

The output should show the path to the wrapper script, typically `$HOME/.local/bin/poetry`.

## Uninstalling

This script is non-destructive and easily reversible. You can disable or remove it by simply deleting or commenting out the line(s) added to your shell profile and removing the wrapper script (`$HOME/.local/bin/poetry`).

## Author

- [DJ Stomp](https://github.com/DJStompZone)
