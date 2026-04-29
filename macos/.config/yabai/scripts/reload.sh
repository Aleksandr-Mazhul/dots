#!/usr/bin/env bash

# reload.sh - Safe yabai and skhd reload script
# Validates configs before restarting services

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Validation functions
validate_yabai() {
  log_info "Validating yabai configuration..."
  
  if ! command -v yabai &>/dev/null; then
    log_error "yabai not found in PATH"
    return 1
  fi
  
  # Check if yabai scripting addition is loaded
  if ! yabai -m query --windows &>/dev/null; then
    log_error "yabai scripting addition not loaded"
    log_info "Try: sudo yabai --load-sa"
    return 1
  fi
  
  log_info "yabai configuration OK"
  return 0
}

validate_skhd() {
  log_info "Validating skhd configuration..."
  
  if ! command -v skhd &>/dev/null; then
    log_error "skhd not found in PATH"
    return 1
  fi
  
  # Check if config file exists and is readable
  if [[ ! -r ~/.config/skhd/skhdrc ]]; then
    log_error "skhd config not found or not readable at ~/.config/skhd/skhdrc"
    return 1
  fi
  
  log_info "skhd configuration OK"
  return 0
}

# Reload functions
reload_yabai() {
  log_info "Restarting yabai service..."
  
  # Check if yabai is running
  if pgrep -q yabai; then
    yabai --restart-service 2>/dev/null || {
      log_error "Failed to restart yabai"
      return 1
    }
    sleep 1
  fi
  
  log_info "yabai restarted successfully"
  return 0
}

reload_skhd() {
  log_info "Reloading skhd configuration..."
  
    skhd --reload 2>/dev/null || {
    log_error "Failed to reload skhd"
    return 1
  }
}

# Main execution
main() {
  log_info "Starting configuration reload..."
  
  local failed=0
  
  # Validate before reloading
  if ! validate_yabai; then
    failed=$((failed + 1))
  fi
  
  if ! validate_skhd; then
    failed=$((failed + 1))
  fi
  
  if [[ $failed -gt 0 ]]; then
    log_error "Validation failed - aborting reload"
    return 1
  fi
  
  # Perform reloads
  if ! reload_yabai; then
    failed=$((failed + 1))
  fi
  
  if ! reload_skhd; then
    failed=$((failed + 1))
  fi
  
  if [[ $failed -gt 0 ]]; then
    log_error "Reload completed with errors"
    return 1
  fi
  
  log_info "Configuration reloaded successfully"
  
  # Show desktop notification
  osascript -e 'display notification "Yabai + skhd reloaded" with title "Config Reloaded"' 2>/dev/null || true
  
  return 0
}

# Error handling
trap 'log_error "Script interrupted"; exit 1' INT TERM

main "$@"
exit $?
