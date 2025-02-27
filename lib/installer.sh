#!/bin/bash

# Set up logging
LOG_DIR="/tmp"
MAIN_LOG="$LOG_DIR/install_setup.log"

 # ANSI color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Log function that writes to both console and log file
log() {
  echo "$@" | tee -a "$MAIN_LOG"
}

# Execute command with redirected output and check exit status
execute_cmd() {
  local cmd="$1"
  local name="${2:-command}"  # Default to "command" if no name provided

  # Log the command being executed to the log file
  echo "COMMAND: $cmd" >> "$MAIN_LOG"
  echo "STARTED: $(date)" >> "$MAIN_LOG"
  echo "----------------------------------------" >> "$MAIN_LOG"

  printf "%-80s" "$name... "

  # Create a temporary file for output
  local temp_out=$(mktemp)

  # Execute command and capture both stdout and stderr to the temp file
  eval "$cmd" > "$temp_out" 2>&1

  exit_status=$?

  # Capture the output
  output=$(cat "$temp_out")
  rm "$temp_out"

  # Log command output and status
  echo "$output" >> "$MAIN_LOG"
  echo "----------------------------------------" >> "$MAIN_LOG"
  echo "FINISHED: $(date)" >> "$MAIN_LOG"
  echo "EXIT STATUS: $exit_status" >> "$MAIN_LOG"

  # Only show output on error, otherwise just show success
  if [ $exit_status -ne 0 ]; then
    printf "${RED}[FAIL]${RESET}\n"
    log "❌ Error executing $name (exit code: $exit_status)"
    return $exit_status
  else
    printf "${GREEN}[  OK]${RESET}\n"
    #printf "✓ $name completed successfully"
    return 0
  fi
}

# Check if a package is installed via apt
is_apt_installed() {
  dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

# Check is a simple package is already installed
is_custom_installed() {
  ! command -v $1 > /dev/null 2>&1
}

# Check if a package is installed via snap
is_snap_installed() {
  snap list 2>/dev/null | grep -q "^$1 "
}

# Check if a package is installed via brew
is_brew_installed() {
  brew list --formula | grep -q "^$1$" || brew list --cask | grep -q "^$1$"
}

MARKER_DIR="$HOME/.dotfiles_installed"

# Install custom packages with idempotence
install_custom_packages() {
  mkdir -p "$MARKER_DIR"
  local count=0

  while IFS=\#\# read name cmd; do
    [ -z "$name" ] && continue
    [[ "$name" == \#* ]] && continue

    if ! is_custom_installed "$name"; then
      if execute_cmd "$cmd" "Installing $name via custom method"; then
        # Create marker file with timestamp
        ((count++))
      fi
    else
      printf "%-82s" "✓ $name already installed (custom)"
      printf "${GREEN}[  OK]${RESET}\n"
    fi
#    local marker="$MARKER_DIR/custom_$name"
#    if [ ! -f "$marker" ]; then
#      echo "Installing $name via custom command..."
#      if execute_cmd "$cmd"; then
#        # Create marker file with timestamp
#        date > "$marker"
#        ((count++))
#      else
#        echo "Error installing $name"
#      fi
#    else
#      echo "✓ $name already installed (custom)"
#    fi
  done < "packages/simple/pkg.list"

  if [ $count -eq 0 ]; then
    echo "All custom packages already installed"
  else
    echo "✓ Installed $count new custom packages"
  fi
}

# Enhanced snap package installer with idempotence
install_snap_packages() {
  local count=0

  while read pkg; do
    [ -z "$pkg" ] && continue
    [[ "$pkg" == \#* ]] && continue

    if ! is_snap_installed "$pkg"; then
      execute_cmd "sudo snap install \"$pkg\"" "Installing $pkg via snap"
      exit_status=$?
      if [ $exit_status -eq 0 ]; then
          ((count++))
      fi
    else
      echo "✓ $pkg already installed (apt)"
    fi
  done < "packages/snap/pkg.list"


  if [ $count -eq 0 ]; then
    echo "No snap packages changed"
  else
    echo "✓ Installed $count new snap packages"
  fi
}

# Enhanced apt package installer with idempotence
install_apt_packages() {
  local count=0

  # Update package list first
  execute_cmd "sudo apt-get update" "Running apt-get update"
  while read pkg; do
    [ -z "$pkg" ] && continue
    [[ "$pkg" == \#* ]] && continue

    if ! is_apt_installed "$pkg"; then
      execute_cmd "sudo apt-get install -y \"$pkg\""  "Installing $pkg via apt"
      if [ $? -eq 0 ]; then
          ((count++))
      fi
    else
      printf "%-80s" "✓ $pkg already installed (apt)"
      printf "${GREEN}[  OK]${RESET}\n"
    fi
  done < "packages/apt/pkg.list"


  if [ $count -eq 0 ]; then
    echo "No apt packages changed"
  else
    echo "✓ Installed $count new apt packages"
  fi
}

# Install simple packages from list files
install_packages() {
  local type=$1
  local list_file="packages/$type/pkg.list"

  if [ ! -f "$list_file" ]; then
    echo "No packages defined for $type"
    return 0
  fi

  echo "Installing $type packages..."

  case "$type" in
    apt)
      # Install each package from the list
      install_apt_packages
      ;;

    snap)
      install_snap_packages
      ;;

    simple)
      install_custom_packages
      ;;

    brew)
      # Ensure Homebrew is installed
      if ! command -v brew &>/dev/null; then
        echo "Homebrew not installed. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi

      while read pkg; do
        [ -z "$pkg" ] && continue
        [[ "$pkg" == \#* ]] && continue
        echo "Installing $pkg via brew..."
        brew install "$pkg"
      done < "$list_file"
      ;;

    custom)
      while IFS=: read name cmd; do
        [ -z "$name" ] && continue
        [[ "$name" == \#* ]] && continue
        echo "Installing $name via custom command..."
        execute_cmd "$cmd"
      done < "$list_file"
      ;;

    *)
      echo "Unknown package type: $type"
      return 1
      ;;
  esac
}
