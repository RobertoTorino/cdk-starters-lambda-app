#!/bin/bash
# Extended script to install software and tools. Only tested on macOS.
set -e

# List of software options
OPTIONS=("SKIP" "QUIT" "HOMEBREW" "AWSCLI" "GO" "MAKE" "NODE" "OPENJDK17" "PYTHON" "SAM")

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
            "HOMEBREW" | "AWSCLI" | "SAM" | "GO" | "PYTHON" | "OPENJDK17" | "TERRAFORM" | "NODE" | "MAKE")
                echo "Installing: $options"
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
                echo "Invalid selection. Please select a valid item or 'SKIP'/'QUIT'."
                continue
                ;;
            esac
            break
        done
    done
}

get_latest_version_homebrew() {
    curl -s https://api.github.com/repos/Homebrew/brew/releases/latest | jq -r '.tag_name'
}

get_latest_version_aws() {
    curl -s https://api.github.com/repos/aws/aws-cli/tags | jq -r '.[0].name'
}

get_latest_version_sam() {
    # curl -s https://api.github.com/repos/aws/aws-sam-cli/tags | jq -r '.[] | select(.name != "vNone") | .name' | head -n 1
    curl -s https://api.github.com/repos/aws/aws-sam-cli/tags | jq -r '.[] | select(.name != "vNone") | .name' | head -n 1 | sed 's/^v//'
}

latest_version_go() {
    # Scrape the latest version from the Go download page
    curl -s https://go.dev/dl/ | grep -o 'go[0-9]\+\.[0-9]\+\.[0-9]\+' | head -n 1
}

# Function to get the latest version of Go
get_latest_version_go() {
    # Use curl and grep/sed to fetch the latest Go version URL
    curl -s https://go.dev/dl/ | grep -o '/dl/go[0-9\.]*\.darwin-arm64\.pkg' | head -1
}

# Function to handle software installation with version check
install_software() {
    case $1 in
    "HOMEBREW")
        current_version=$(brew -v 2>&1 | awk '{print $2}')
        latest_version=$(get_latest_version_homebrew)
        # Check if software is installed
        if command -v brew &>/dev/null; then
            echo "⚠️ Homebrew is already installed. Using: $current_version. Latest version: $latest_version."
            # Check if installed version is the latest
            read -p "Do you want to check for the latest version? (Yes/No): " check_for_latest
            if [[ "$check_for_latest" == "Yes" || "$check_for_latest" == "yes" ]]; then

                if [[ "$current_version" == "$latest_version" ]]; then
                    echo "✅ Homebrew is already up-to-date (Version: $current_version). Skipping installation."
                # Install if software is not installed
                else
                    echo "Installing Homebrew..."
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    # Check if install was successful
                    if command -v brew -eq 0 &>/dev/null?; then
                        echo "✅✅✅ Homebrew installed successfully. ✨ ✨ "
                        echo "using version: $latest_version now."
                    else
                        echo "⚠️ Error: Homebrew installation failed."
                        exit 1
                    fi
                    # Check if you want to upgrade
                    read -p "Do you want to install the latest version? (Yes/No): " install_latest
                    if [[ "$install_latest" == "Yes" || "$install_latest" == "yes" ]]; then

                        if [[ "$current_version" == "$latest_version" ]]; then
                            echo "✅ Homebrew is already up-to-date (Version: $current_version). Skipping installation."
                        else
                            # Installing software
                            echo "Installing Homebrew..."
                            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                            if command -v brew &>/dev/null; then
                                echo "✅✅✅ Homebrew installed successfully. ✨ ✨"
                                echo "using version: $latest_version now."
                            else
                                echo "⚠️ Error: HOMEBREW installation failed."
                                exit 1
                            fi
                        fi
                    fi
                fi
            fi
        fi
        ;;

    "AWSCLI")
        current_version=$(aws --version 2>&1 | awk '{print $1}' | cut -d/ -f2)
        latest_version=$(get_latest_version_aws)
        # Check if software is installed
        if command -v aws &>/dev/null; then
            echo "⚠️AWS-CLI is already installed. Using: $current_version. Latest version: $latest_version."
            # Check if installed version is the latest
            read -p "Do you want to check for the latest version? (Yes/No): " check_for_latest
            if [[ "$check_for_latest" == "Yes" || "$check_for_latest" == "yes" ]]; then

                if [[ "$current_version" == "$latest_version" ]]; then
                    echo "✅ AWS CLI is already up-to-date (Version: $current_version). Skipping installation."
                # Install if software is not installed
                else
                    echo "Installing AWS CLI..."
                    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
                    sudo installer -pkg AWSCLIV2.pkg -target /
                    if command aws --version &>/dev/null; then
                        echo "✅✅✅ AWS-CLI installed successfully. ✨ ✨"
                        echo "Using version: $latest_version now."
                    else
                        echo "⚠️ Error: AWS-CLI installation failed."
                        exit 1
                    fi
                    # Check if you want to upgrade
                    read -p "Do you want to install the latest version? (Yes/No): " install_latest
                    if [[ "$install_latest" == "Yes" || "$install_latest" == "yes" ]]; then

                        if [[ "$current_version" == "$latest_version" ]]; then
                            echo "✅ AWS CLI is already up-to-date (Version: $current_version). Skipping installation."
                        else
                            # Installing software
                            echo "Installing AWS CLI..."
                            curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
                            sudo installer -pkg AWSCLIV2.pkg -target /
                            if command aws --version &>/dev/null; then
                                echo "✅✅✅ AWS-CLI installed successfully. ✨ ✨"
                                echo "Using version: $latest_version now."
                            else
                                echo "⚠️ Error: AWS-CLI installation failed."
                                exit 1
                            fi
                        fi
                    fi
                fi
            fi
        fi
        ;;

    "GO")
        # Check if Go is installed
        if command -v go &>/dev/null; then
            current_version=$(go version | awk '{print $3}')
            latest_version_check=$(latest_version_go)
            latest_version=$(get_latest_version_go)
            echo "⚠️ GO is already installed. Using: $current_version. Latest version: $latest_version_check."
            # Check if the installed version is the latest
            read -p "Do you want to check for the latest version? (Yes/No): " check_for_latest
            if [[ "$check_for_latest" == "Yes" || "$check_for_latest" == "yes" ]]; then
                if [[ "$current_version" == "$latest_version_check" ]]; then
                    echo "✅ GO is already up-to-date (Version: $current_version). Skipping installation."
                else
                    echo "Be patient this could take a few minutes, now installing GO..."
                    pkg_url="https://go.dev${latest_version}"
                    echo "Downloading Go version from $pkg_url ..."
                    curl -L -o "go_latest.pkg" "$pkg_url"
                    sudo installer -pkg go_latest.pkg -target /
                    sleep 5 # Give the system a moment to reflect the installation
                    if command -v go &>/dev/null; then
                        echo "✅✅✅ GO installed successfully. ✨ ✨"
                        echo "Using version: $latest_version_check now."
                    else
                        echo "⚠️ Error: GO installation failed."
                        exit 1
                    fi
                fi
            fi
        else
            # Go is not installed, install the latest version
            echo "Go is not installed. Try installing the latest version..."
            echo "Be patient this could take a few minutes, now installing GO..."
            latest_version=$(get_latest_version_go)
            pkg_url="https://go.dev${latest_version}"
            echo "Downloading Go version from $pkg_url ..."
            curl -L -o "go_latest.pkg" "$pkg_url"
            sudo installer -pkg go_latest.pkg -target /
            sleep 5 # Wait for a moment to allow the system to recognize the installation
            if command -v go &>/dev/null; then
                echo "✅✅✅ GO installed successfully. ✨ ✨"
                echo "Using version: $latest_version_check now."
            else
                echo "⚠️ Error: GoLang installation failed."
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
                echo "⚠️ Error: Make installation failed."
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
                echo "Using: $(node -v now.)"
                echo "Using: $(npm -v now)"
            else
                echo "⚠️ Error: NODE installation failed."
                exit 1
            fi
        fi
        ;;

    "OPENJDK17")
        latest_openjdk_version="openjdk 17.0.12 2024-07-16 LTS"
        if command java --version &>/dev/null; then
            current_version=$(java --version | grep 'openjdk')
            latest_version=$latest_openjdk_version
            #echo "⚠️Java is already installed. Using: $current_version. Latest version: $latest_version."
            # Check if installed version matches the latest version
            if [[ "$current_version" == "$latest_version" ]]; then
                echo "✅ OpenJDK is already up-to-date. Using: $current_version. Latest version: $latest_version."
            else
                echo "Installing Java..."
                brew install openjdk@17
                if command java --version -eq 0 &>/dev/null?; then
                    echo "✅✅✅ Java installed successfully. ✨ ✨ "
                    echo "Using $latest_version now."
                else
                    echo "⚠️ Error: Java installation failed."
                    exit 1
                fi
            fi
        fi
        ;;

    "PYTHON")
        # Function to check if a URL exists
        url_exists() {
            curl --head --silent --fail "$1" >/dev/null
        }
        # Fetch all Python versions dynamically from the official website
        all_python_versions=$(curl -s https://www.python.org/ftp/python/ | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | sort -Vr)

        # Loop through versions and find the first one that has a valid macOS installer package
        for version in $all_python_versions; do
            python_pkg_url="https://www.python.org/ftp/python/$version/python-$version-macos11.pkg"
            if url_exists "$python_pkg_url"; then
                latest_python_version="$version"
                break
            fi
        done

        # If no valid version was found
        if [[ -z "$latest_python_version" ]]; then
            echo "⚠️ Error: Could not find a valid Python version with an available macOS installer package."
            exit 1
        fi

        # Construct the download URL based on the latest version found
        python_pkg_url="https://www.python.org/ftp/python/$latest_python_version/python-$latest_python_version-macos11.pkg"

        # Check if Python is installed
        if command -v python3 &>/dev/null; then
            current_version=$(python3 --version | awk '{print $2}')
            echo "⚠️ Python3 is already installed. Current version: $current_version. Latest version: $latest_python_version."

            # Check if installed version matches the latest version
            if [[ "$current_version" == "$latest_python_version" ]]; then
                echo "✅ Python3 is already up-to-date (Version: $current_version). Skipping installation."
            else
                read -p "Do you want to install the latest version? (Yes/No): " install_latest
                if [[ "$install_latest" == "Yes" || "$install_latest" == "yes" ]]; then
                    echo "Downloading and installing the latest Python3 version..."
                    curl -o "python-latest.pkg" "$python_pkg_url"
                    sudo installer -pkg "python-latest.pkg" -target /

                    if command -v python3 &>/dev/null; then
                        echo "✅✅✅ Python3 installed successfully. ✨ ✨"
                        echo "Using version: $latest_python_version now."
                    else
                        echo "⚠️ Error: Python3 installation failed."
                        exit 1
                    fi
                fi
            fi
        else
            echo "Python3 is not installed. Installing the latest version..."
            curl -o "python-latest.pkg" "$python_pkg_url"
            sudo installer -pkg "python-latest.pkg" -target /

            if command -v python3 &>/dev/null; then
                echo "✅✅✅ Python3 installed successfully. ✨ ✨"
                echo "Using version: $latest_python_version now."
            else
                echo "⚠️ Error: Python3 installation failed."
                exit 1
            fi
        fi
        ;;

    "SAM")
        current_version=$(sam --version 2>&1 | awk '{print $4}' | cut -d/ -f2)
        latest_version=$(get_latest_version_sam)
        # Check if software is installed
        if command sam --version &>/dev/null; then
            echo "⚠️ SAM-CLI is already installed. Using: $current_version. Latest version: $latest_version."
            # Check if installed version is the latest
            read -p "Do you want to check for the latest version? (Yes/No): " check_for_latest
            if [[ "$check_for_latest" == "Yes" || "$check_for_latest" == "yes" ]]; then

                if [[ "$current_version" == "$latest_version" ]]; then
                    echo "✅ SAM-CLI is already up-to-date (Version: $current_version). Skipping installation."
                    # Install if software is not installed
                else
                    echo "Installing SAM-CLI..."
                    curl -L -o "aws-sam-cli-macos-arm64.pkg" "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-macos-arm64.pkg"
                    sudo installer -pkg "aws-sam-cli-macos-arm64.pkg" -target /

                    if command sam --version &>/dev/null; then
                        echo "✅✅✅ SAM-CLI installed successfully. ✨ ✨"
                        echo "Using version: $latest_version now."
                    else
                        echo "⚠️ Error: SAM-CLI installation failed."
                        exit 1
                    fi
                    # Check if you want to upgrade
                    read -p "Do you want to install the latest version? (Yes/No): " install_latest
                    if [[ "$install_latest" == "Yes" || "$install_latest" == "yes" ]]; then

                        if [[ "$current_version" == "$latest_version" ]]; then
                            echo "✅ SAM-CLI is already up-to-date (Version: $current_version). Skipping installation."
                        else
                            # Installing software
                            echo "Installing SAM-CLI..."
                            curl -L -o "aws-sam-cli-macos-arm64.pkg" "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-macos-arm64.pkg"
                            sudo installer -pkg "aws-sam-cli-macos-arm64.pkg" -target /
                            if command SAM --version &>/dev/null; then
                                echo "✅✅✅ SAM-CLI installed successfully. ✨ ✨"
                                echo "using version: $latest_version now."
                            else
                                echo "⚠️ Error: SAM-CLI installation failed."
                                exit 1
                            fi
                        fi
                    fi
                fi
            fi
        fi
        ;;

    esac
}

# Main script
select_software
echo "✅✅✅ Script completed successfully. ✨ ✨ "
exit 0
