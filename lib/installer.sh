#!/bin/bash

# Check if a package is installed via apt
is_apt_installed() {
  dpkg -l "$1" 2>/dev/null | grep -q "^ii"
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

    local marker="$MARKER_DIR/custom_$name"
    if [ ! -f "$marker" ]; then
      echo "Installing $name via custom command..."
      if eval "$cmd"; then
        # Create marker file with timestamp
        date > "$marker"
        ((count++))
      else
        echo "Error installing $name"
      fi
    else
      echo "✓ $name already installed (custom)"
    fi
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
      echo "Installing $pkg via snap..."
      sudo snap install "$pkg"
      ((count++))
    else
      echo "✓ $pkg already installed (apt)"
    fi
  done < "packages/snap/pkg.list"


  if [ $count -eq 0 ]; then
    echo "All snap packages already installed"
  else
    echo "✓ Installed $count new snap packages"
  fi
}

# Enhanced apt package installer with idempotence
install_apt_packages() {
  local count=0

  while read pkg; do
    [ -z "$pkg" ] && continue
    [[ "$pkg" == \#* ]] && continue

    if ! is_apt_installed "$pkg"; then
      echo "Installing $pkg via apt..."
      sudo apt-get install -y "$pkg"
      ((count++))
    else
      echo "✓ $pkg already installed (apt)"
    fi
  done < "packages/apt/pkg.list"


  if [ $count -eq 0 ]; then
    echo "All apt packages already installed"
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
      # Update package list first
      sudo apt-get update
      # Install each package from the list
      install_apt_packages
      ;;

    snap)
      while read pkg; do
        [ -z "$pkg" ] && continue
        [[ "$pkg" == \#* ]] && continue
        echo "Installing $pkg via snap..."
        sudo snap install "$pkg"
      done < "$list_file"
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
        eval "$cmd"
      done < "$list_file"
      ;;

    *)
      echo "Unknown package type: $type"
      return 1
      ;;
  esac

  echo "✓ All $type packages installed"
}
