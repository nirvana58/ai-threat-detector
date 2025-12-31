#!/bin/bash

# NIRVANA - AI Network Threat Detector Launcher
# This script sets up and runs the NTD client

# Color codes
RED='\033[38;5;196m'
RED2='\033[38;5;203m'
PINK='\033[38;5;210m'
LIGHT_PINK='\033[38;5;217m'
WHITE='\033[38;5;231m'
CYAN='\033[38;5;51m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Print banner
print_banner() {
    clear
    echo ""
    echo ""
    echo -e "        ${RED} ███╗   ██╗ ██╗ ██████╗  ██╗   ██╗  █████╗  ███╗   ██╗  █████╗ ${RESET}"
    echo -e "        ${RED} ████╗  ██║ ██║ ██╔══██╗ ██║   ██║ ██╔══██╗ ████╗  ██║ ██╔══██╗${RESET}"
    echo -e "        ${RED2} ██╔██╗ ██║ ██║ ██████╔╝ ██║   ██║ ███████║ ██╔██╗ ██║ ███████║${RESET}"
    echo -e "        ${PINK} ██║╚██╗██║ ██║ ██╔══██╗ ╚██╗ ██╔╝ ██╔══██║ ██║╚██╗██║ ██╔══██║${RESET}"
    echo -e "        ${LIGHT_PINK} ██║ ╚████║ ██║ ██║  ██║  ╚████╔╝  ██║  ██║ ██║ ╚████║ ██║  ██║${RESET}"
    echo -e "        ${WHITE} ╚═╝  ╚═══╝ ╚═╝ ╚═╝  ╚═╝   ╚═══╝   ╚═╝  ╚═╝ ╚═╝  ╚═══╝ ╚═╝  ╚═╝${RESET}"
    echo ""
    echo -e "                        ${CYAN}ai-threat detector${RESET}"
    echo ""
    echo ""
}

# Check if Python is installed
check_python() {
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}✗ Python 3 is not installed${RESET}"
        echo -e "${YELLOW}Please install Python 3.8 or higher${RESET}"
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    echo -e "${GREEN}✓ Python ${PYTHON_VERSION} detected${RESET}"
}

# Install requirements
install_requirements() {
    echo -e "\n${CYAN}Checking dependencies...${RESET}"
    
    if [ -f "requirements.txt" ]; then
        echo -e "${YELLOW}Installing/updating required packages...${RESET}"
        python3 -m pip install --upgrade pip > /dev/null 2>&1
        python3 -m pip install -r requirements.txt
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ All dependencies installed successfully${RESET}"
        else
            echo -e "${RED}✗ Failed to install dependencies${RESET}"
            exit 1
        fi
    else
        echo -e "${YELLOW}⚠ requirements.txt not found, installing basic packages...${RESET}"
        python3 -m pip install pandas requests tabulate
    fi
}

# Check if client file exists
check_client() {
    if [ ! -f "ntd-client.py" ]; then
        echo -e "${RED}✗ ntd-client.py not found in current directory${RESET}"
        echo -e "${YELLOW}Please ensure ntd-client.py is in the same directory as this script${RESET}"
        exit 1
    fi
    
    # Make client executable
    chmod +x ntd-client.py
    echo -e "${GREEN}✓ Client file found${RESET}"
}

# Main execution
main() {
    print_banner
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════${RESET}"
    echo -e "${WHITE}               NIRVANA Network Threat Detector Setup               ${RESET}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════${RESET}\n"
    
    # Check Python
    check_python
    
    # Check client file
    check_client
    
    # Install requirements
    install_requirements
    
    echo -e "\n${CYAN}═══════════════════════════════════════════════════════════════════${RESET}"
    echo -e "${GREEN}✓ Setup complete! Launching client...${RESET}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════${RESET}\n"
    
    sleep 2
    
    # Run the client
    if [ $# -eq 0 ]; then
        # No arguments - run in interactive mode
        python3 ntd-client.py interactive
    else
        # Pass all arguments to the client
        python3 ntd-client.py "$@"
    fi
}

# Run main function with all script arguments
main "$@"
