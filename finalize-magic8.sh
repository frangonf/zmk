#!/bin/bash
#
# Finalize Magic 8 implementation:
# - Remove unused layouts from Linux
# - Check for Gaming layer in special layers
# - Update main keymap
#

set -e

LAYERS_DIR="app/boards/arm/glove80/includes/layers"

echo "=== Step 1: Cleaning up base-layers-linux.dtsi (keeping QWERTY only) ==="

# Count how many layers in Linux base file
linux_layer_count=$(grep -c "^        layer_" "$LAYERS_DIR/base-layers-linux.dtsi" || true)
echo "Found $linux_layer_count layers in base-layers-linux.dtsi"

# Extract just the QWERTY_Linux layer
echo "Extracting QWERTY_Linux layer..."

# Find the start and end of layer_QWERTY_Linux
start_line=$(grep -n "^        layer_QWERTY_Linux {" "$LAYERS_DIR/base-layers-linux.dtsi" | cut -d: -f1)
# Find the closing brace (look for first standalone "};" after start)
end_line=$(tail -n +$start_line "$LAYERS_DIR/base-layers-linux.dtsi" | grep -n "^        };" | head -1 | cut -d: -f1)
end_line=$((start_line + end_line - 1))

echo "QWERTY_Linux layer is at lines $start_line-$end_line"

# Extract the layer
sed -n "${start_line},${end_line}p" "$LAYERS_DIR/base-layers-linux.dtsi" > "$LAYERS_DIR/base-layers-linux.dtsi.tmp"
mv "$LAYERS_DIR/base-layers-linux.dtsi.tmp" "$LAYERS_DIR/base-layers-linux.dtsi"

echo "  ✓ Cleaned up base-layers-linux.dtsi"

echo ""
echo "=== Step 2: Checking for Gaming layer in special layers ==="

# Check if Gaming layer exists in special-layers.dtsi
if grep -q "layer_Gaming" "$LAYERS_DIR/special-layers.dtsi"; then
    echo "Found Gaming layer in special-layers.dtsi"
    echo "Note: Gaming layer will be commented out (not deleted) for safety"

    # Comment out the Gaming layer
    sed -i '/layer_Gaming {/,/^        };/s/^/\/\/ /' "$LAYERS_DIR/special-layers.dtsi"
    echo "  ✓ Commented out Gaming layer in special-layers.dtsi"
else
    echo "  No Gaming layer found in special-layers.dtsi"
fi

# Check if Gaming layer exists in special-layers-linux.dtsi
if grep -q "layer_Gaming_Linux" "$LAYERS_DIR/special-layers-linux.dtsi"; then
    echo "Found Gaming_Linux layer in special-layers-linux.dtsi"

    # Comment out the Gaming layer
    sed -i '/layer_Gaming_Linux {/,/^        };/s/^/\/\/ /' "$LAYERS_DIR/special-layers-linux.dtsi"
    echo "  ✓ Commented out Gaming_Linux layer in special-layers-linux.dtsi"
else
    echo "  No Gaming_Linux layer found in special-layers-linux.dtsi"
fi

echo ""
echo "=== Cleanup complete! ==="
echo ""
echo "Files modified:"
echo "  - $LAYERS_DIR/base-layers-linux.dtsi (QWERTY only)"
echo "  - $LAYERS_DIR/special-layers.dtsi (Gaming commented out)"
echo "  - $LAYERS_DIR/special-layers-linux.dtsi (Gaming commented out)"
