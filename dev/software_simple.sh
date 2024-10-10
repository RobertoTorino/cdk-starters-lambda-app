#!/bin/bash
# Script to install software and tools. Only tested on macOS.

set -e

OPTIONS=("SKIP" "QUIT" "HOMEBREW" "AWS" "GO" "MAKE" "NODE" "OPENJDK17" "PYTHON" "SAM")

# Function to display the selection menu
select_software() {
    while true; do
        # Display instructions over multiple lines
        echo "1. Select SKIP to move to the next option."
        echo "2. Select QUIT to exit the script."
        echo "Select the software title to install:"

        # Define the PS3 prompt for user input
        PS3="Please make your selection: "

        # The COLUMNS environment variable sets the terminal column width
        COLUMNS=3
        select options in "${OPTIONS[@]}"; do
            case $options in
            "HOMEBREW" | "AWS" | "SAM" | "GO" | "PYTHON" | "OPENJDK17" | "TERRAFORM" | "NODE" | "MAKE")
                echo "Install: $options"
                install_software "$options"
                ;;
            "SKIP")
                echo "Skipping installation."
                ;;
            "QUIT")
                echo "Exiting script."
                exit 0
                ;;
            *)
                echo "Invalid selection. Please select a valid item or 's' to skip."
                continue
                ;;
            esac
            break
        done
    done
}

install_software() {
    case $1 in
    "HOMEBREW")
        if command -v brew &>/dev/null; then
            echo "⚠️Homebrew is already installed. Using: $(brew -v)"
        else
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            if command -v brew -eq 0 &>/dev/null?; then
                echo "Homebrew installed successfully. ✨ ✨ "
            else
                echo "Error: Homebrew installation failed."
                exit 1
            fi
        fi
        ;;

    "AWS")
        if command aws --version &>/dev/null; then
            echo "⚠️AWS-CLI is already installed. Using: $(aws --version)"
            return
        else
            echo "Installing AWS-CLI..."
            # Download the file using the curl command.
            # The -o option specifies the file name that the downloaded package is written to.
            curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"

            # Run the macOS installer program, specifying the downloaded .pkg file as the source.
            # Use the -pkg parameter to specify the name of the package to install, and the -target / parameter for which drive to install the package to.
            # The files are installed to /usr/local/aws-cli, a symlink is created in /usr/local/bin.
            # You must include sudo on the command to grant write permissions to those folders.
            sudo installer -pkg AWSCLIV2.pkg -target /
            if command aws --version -eq 0 &>/dev/null?; then
                echo "AWS-CLI installed successfully. ✨ ✨ "
                command which aws
                command aws --version
            else
                echo "Error: AWS-CLI installation failed."
                exit 1
            fi
        fi
        ;;

    "GO")
        if command -v go &>/dev/null; then
            echo "⚠️Go is already installed. Using: $(go version)"
        else
            echo "Installing GoLang..."
            brew install go
            if command -v go -eq 0 &>/dev/null?; then
                echo "✅✅✅ GoLang installed successfully. ✨ ✨ "
            else
                echo "Error: GoLang installation failed."
                exit 1
            fi
        fi
        ;;

    "MAKE")
        if command make --version &>/dev/null; then
            echo "MAKE is already installed. Using: $(make --version)"
        else
            echo "Installing Make..."
            brew install make
            if command make --version -eq 0 &>/dev/null?; then
                echo "✅✅✅ Make installed successfully. ✨ ✨ "
            else
                echo "Error: Make installation failed."
                exit 1
            fi
        fi
        ;;

    "NODE")
        # install through homebrew
        # https://nodejs.org/en/download/package-manager
        if command node -v &>/dev/null; then
            echo "⚠️NODE is already installed. Using: $(node -v)"
            echo "⚠️NPM is already installed. Using: $(npm -v)"
        else
            echo "Installing Node and NPM..."
            brew install node@20
            if command node --version -eq 0 &>/dev/null?; then
                echo "✅✅✅ NODE and NPM installed successfully. ✨ ✨ "
            else
                echo "Error: NODE installation failed."
                exit 1
            fi
        fi
        ;;

    "OPENJDK17")
        if command java --version &>/dev/null; then
            echo "⚠️Java is already installed. Using: $(java --version)"
        else
            echo "Installing Java..."
            brew install openjdk@17
            if command java --version -eq 0 &>/dev/null?; then
                echo "✅✅✅ Java installed successfully. ✨ ✨ "
            else
                echo "Error: Java installation failed."
                exit 1
            fi
        fi
        ;;

    "PYTHON")
        if command python3 --version &>/dev/null; then
            echo "⚠️Python is already installed. Using: $(python3 --version)"
        else
            echo "Installing Python..."
            brew install python
            if command python3 --version -eq 0 &>/dev/null?; then
                echo "✅✅✅ Python installed successfully. ✨ ✨ "
            else
                echo "Error: Python installation failed."
                exit 1
            fi
        fi
        ;;

    "SAM")
        current_version=$(sam --version 2>&1 | awk '{print $4}' | cut -d/ -f2)
        # Check if software is installed
        if command sam --version &>/dev/null; then
            echo "⚠️ SAM-CLI is already installed. Using: Current version: $current_version."
        else
            echo "Installing SAM-CLI..."
            # Download the file using the curl command.
            # The -o option specifies the file name that the downloaded package is written to.
            curl "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-macos-arm64.pkg" -o "aws-sam-cli-macos-arm64.pkg"

            # Download the macOS pkg to a directory of your choice:
            # For Macs running Intel processors, choose x86_64 – aws-sam-cli-macos-x86_64.pkg
            # For Macs running Apple silicon, choose arm64 – aws-sam-cli-macos-arm64.pkg
            # You have the option of verifying the integrity of the installer before installation.
            # For instructions, see Optional: Verify the integrity of the AWS SAM CLI installer.
            # Run your downloaded file and follow the on-screen instructions to continue through the Introduction, Read Me, and License steps.
            # For Destination Select, select Install for all users of this computer.
            # For Installation Type, choose where the AWS SAM CLI will be installed and press Install.
            # The recommended default location is /usr/local/aws-sam-cli.
            sudo installer -pkg aws-sam-cli-macos-arm64.pkg -target /

            if command sam --version &>/dev/null; then
                echo "✅✅✅ SAM-CLI installed successfully. ✨ ✨"
            else
                echo "Error: SAM-CLI installation failed."
                exit 1
            fi
        fi
        ;;
    esac
}

# Main script
select_software
echo "✅✅✅ Script completed successfully. ✨ ✨ "
exit 0
