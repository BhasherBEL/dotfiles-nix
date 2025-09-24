#!/usr/bin/env bash

offline=false
safe=false
update=false
update_only=false
clean=false
clean_only=false
slow=false
fast=false

# Parse arguments
while [[ $# -gt 0 ]]; do
	case $1 in
		--offline)
			offline=true
			shift
			;;
		--safe)
			safe=true
			shift
			;;
		--update)
			update=true
			shift
			;;
		--update-only)
			update_only=true
			shift
			;;
		--clean)
			clean=true
			shift
			;;
		--clean-only)
			clean_only=true
			shift
			;;
		--slow)
			slow=true
			shift
			;;
		--fast)
			fast=true
			shift
			;;
		*)
			echo "Unknown option: $1"
			echo "Usage: nb [--offline] [--safe] [--update] [--update-only] [--clean] [--clean-only] [--slow] [--fast]"
			echo "  --offline     Build without substitutes"
			echo "  --safe        Ignore current specialisation"
			echo "  --update      Update flake before building"
			echo "  --update-only Only update flake, don't rebuild"
			echo "  --clean       Clean after building"
			echo "  --clean-only  Only clean, don't rebuild"
			echo "  --slow        Limit resources usage"
			echo "  --fast        Reuse previous build's resources"
			exit 1
			;;
	esac
done

# Handle clean-only
if [[ "$clean_only" == true ]]; then
	echo "Cleaning system..."
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d
	exit $?
fi

# Handle update-only
if [[ "$update_only" == true ]]; then
	echo "Updating flake..."
	nix flake update --flake /etc/nixos
	exit $?
fi

# Update flake if requested
if [[ "$update" == true ]]; then
	echo "Updating flake..."
	nix flake update --flake /etc/nixos || exit 1
fi

# Detect current specialisation
current_spec=""
if [[ "$safe" == false ]]; then
	if [ ! -e /run/current-system/specialisation/light ] && [ -e /nix/var/nix/profiles/system/specialisation/light ]; then
		current_spec="light"
	fi
fi

# Build command
cmd="nixos-rebuild switch --flake /etc/nixos#$(hostname) --sudo"

if [[ "$slow" == true ]]; then
	cmd="$cmd --max-jobs 1 --cores 1"
	echo "Building in slow mode (limited resources)"
fi

if [[ "$fast" == true ]]; then
	cmd="$cmd --no-reexec"
	echo "Reuse previous build's resources"
fi

# Add specialisation if detected and not in safe mode
if [[ -n "$current_spec" && "$safe" == false ]]; then
	cmd="$cmd --specialisation $current_spec"
	echo "Rebuilding with specialisation: $current_spec"
else
	echo "Rebuilding default configuration"
fi

# Add offline option
if [[ "$offline" == true ]]; then
	cmd="$cmd --option substitute false"
	echo "Building offline (no substitutes)"
fi

# Execute rebuild
eval $cmd || exit 1

# Clean if requested
if [[ "$clean" == true ]]; then
	echo "Cleaning system..."
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && nix-collect-garbage -d
fi
