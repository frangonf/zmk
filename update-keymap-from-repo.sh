#!/bin/bash
#
# Update Glove80 Keymap from glove80-keymaps Repository
#
# This script automates copying your generated keymap from the
# glove80-keymaps repo (sunaku workflow) to this ZMK firmware repo
# for building with 64-layer support.
#
# Usage:
#   ./update-keymap-from-repo.sh [source_keymap] [destination]
#
# Default paths:
#   Source: $HOME/glove80-keymaps/output/glove80.keymap
#   Destination: $PWD/app/boards/arm/glove80/glove80.keymap
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default paths (can be overridden with arguments)
KEYMAP_REPO="${KEYMAP_REPO:-$HOME/glove80-keymaps}"
KEYMAP_SRC="${1:-$KEYMAP_REPO/output/glove80.keymap}"
KEYMAP_DST="${2:-$(pwd)/app/boards/arm/glove80/glove80.keymap}"

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}Glove80 Keymap Update Script${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Check if we're in the ZMK repo
if [ ! -d "app/boards/arm/glove80" ]; then
    echo -e "${RED}Error: Not in ZMK repository root${NC}"
    echo "Please run this script from the zmk repository directory"
    exit 1
fi

# Check if source keymap exists
if [ ! -f "$KEYMAP_SRC" ]; then
    echo -e "${RED}Error: Source keymap not found${NC}"
    echo "Looked for: $KEYMAP_SRC"
    echo ""
    echo "Did you generate the keymap in glove80-keymaps repo?"
    echo "Try running: cd $KEYMAP_REPO && make generate"
    echo ""
    echo "Or specify custom source: $0 /path/to/keymap.keymap"
    exit 1
fi

echo -e "${GREEN}✓${NC} Found source keymap: $KEYMAP_SRC"

# Check destination directory exists
KEYMAP_DIR=$(dirname "$KEYMAP_DST")
if [ ! -d "$KEYMAP_DIR" ]; then
    echo -e "${RED}Error: Destination directory not found${NC}"
    echo "Missing: $KEYMAP_DIR"
    exit 1
fi

# Create backup if destination exists
if [ -f "$KEYMAP_DST" ]; then
    BACKUP_FILE="$KEYMAP_DST.backup-$(date +%Y%m%d-%H%M%S)"
    cp "$KEYMAP_DST" "$BACKUP_FILE"
    echo -e "${GREEN}✓${NC} Backed up current keymap to:"
    echo "  $BACKUP_FILE"
else
    echo -e "${YELLOW}!${NC} No existing keymap to backup"
fi

# Show file info
echo ""
echo -e "${BLUE}Source keymap info:${NC}"
echo "  File: $KEYMAP_SRC"
echo "  Size: $(du -h "$KEYMAP_SRC" | cut -f1)"
echo "  Modified: $(stat -c %y "$KEYMAP_SRC" 2>/dev/null || stat -f "%Sm" "$KEYMAP_SRC")"

# Quick validation (check for required elements)
echo ""
echo -e "${BLUE}Validating keymap...${NC}"

if ! grep -q "compatible = \"zmk,keymap\"" "$KEYMAP_SRC"; then
    echo -e "${RED}✗ Warning: Keymap missing 'compatible = \"zmk,keymap\"'${NC}"
    echo "  This may not be a valid ZMK keymap file"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓${NC} Valid ZMK keymap structure detected"
fi

# Count layers
LAYER_COUNT=$(grep -c "^\s*[a-zA-Z_][a-zA-Z0-9_]*\s*{" "$KEYMAP_SRC" | grep -v "behaviors\|macros\|keymap" || echo "0")
echo -e "${GREEN}✓${NC} Detected approximately $LAYER_COUNT layers defined"

if [ "$LAYER_COUNT" -gt 64 ]; then
    echo -e "${YELLOW}!${NC} Warning: More than 64 layers detected"
    echo "  ZMK supports maximum 64 layers (0-63)"
fi

# Copy the keymap
echo ""
echo -e "${BLUE}Copying keymap...${NC}"
cp "$KEYMAP_SRC" "$KEYMAP_DST"
echo -e "${GREEN}✓${NC} Keymap copied successfully to:"
echo "  $KEYMAP_DST"

# Check if PDF documentation exists
PDF_SRC="$KEYMAP_REPO/output/glove80-layout.pdf"
PDF_DST="$(pwd)/glove80-layout-reference.pdf"
if [ -f "$PDF_SRC" ]; then
    cp "$PDF_SRC" "$PDF_DST"
    echo -e "${GREEN}✓${NC} Also copied PDF documentation to:"
    echo "  $PDF_DST"
fi

# Done!
echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}Update complete!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the keymap (optional):"
echo "     ${BLUE}cat $KEYMAP_DST${NC}"
echo ""
echo "  2. Build the firmware:"
echo "     ${BLUE}nix-build -A glove80_combined${NC}"
echo ""
echo "  3. Flash to keyboard:"
echo "     - Left: ${BLUE}result/glove80_left.uf2${NC}"
echo "     - Right: ${BLUE}result/glove80_right.uf2${NC}"
echo ""
echo -e "${YELLOW}Tip:${NC} Keep a backup of working keymaps!"
echo "  Backups are in: $(dirname "$KEYMAP_DST")/*.backup-*"
echo ""
