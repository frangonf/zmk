#!/bin/bash
#
# Script to create GACS layer files from existing CAGS layer files
# This automates the tedious process of duplicating and modifying layers
#

set -e  # Exit on error

LAYERS_DIR="app/boards/arm/glove80/includes/layers"

echo "=== Creating GACS layer files ==="

# Function to create GACS version of a layer file
create_gacs_version() {
    local source_file="$1"
    local gacs_file="$2"

    echo "Creating $gacs_file from $source_file..."

    # Copy the file
    cp "$source_file" "$gacs_file"

    # Replace layer names with _GACS variants
    sed -i 's/layer_QWERTY {/layer_QWERTY_GACS {/g' "$gacs_file"
    sed -i 's/layer_Typing {/layer_Typing_GACS {/g' "$gacs_file"
    sed -i 's/layer_LeftPinky {/layer_LeftPinky_GACS {/g' "$gacs_file"
    sed -i 's/layer_LeftRingy {/layer_LeftRingy_GACS {/g' "$gacs_file"
    sed -i 's/layer_LeftMiddy {/layer_LeftMiddy_GACS {/g' "$gacs_file"
    sed -i 's/layer_LeftIndex {/layer_LeftIndex_GACS {/g' "$gacs_file"
    sed -i 's/layer_RightPinky {/layer_RightPinky_GACS {/g' "$gacs_file"
    sed -i 's/layer_RightRingy {/layer_RightRingy_GACS {/g' "$gacs_file"
    sed -i 's/layer_RightMiddy {/layer_RightMiddy_GACS {/g' "$gacs_file"
    sed -i 's/layer_RightIndex {/layer_RightIndex_GACS {/g' "$gacs_file"
    sed -i 's/layer_Cursor {/layer_Cursor_GACS {/g' "$gacs_file"
    sed -i 's/layer_Number {/layer_Number_GACS {/g' "$gacs_file"
    sed -i 's/layer_Function {/layer_Function_GACS {/g' "$gacs_file"
    sed -i 's/layer_Symbol {/layer_Symbol_GACS {/g' "$gacs_file"

    # Replace LAYER_ constants with _GACS variants in behaviors
    sed -i 's/LAYER_QWERTY)/LAYER_QWERTY_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_Typing)/LAYER_Typing_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_LeftPinky)/LAYER_LeftPinky_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_LeftRingy)/LAYER_LeftRingy_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_LeftMiddy)/LAYER_LeftMiddy_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_LeftIndex)/LAYER_LeftIndex_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_RightPinky)/LAYER_RightPinky_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_RightRingy)/LAYER_RightRingy_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_RightMiddy)/LAYER_RightMiddy_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_RightIndex)/LAYER_RightIndex_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_Cursor)/LAYER_Cursor_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_Number)/LAYER_Number_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_Function)/LAYER_Function_GACS)/g' "$gacs_file"
    sed -i 's/LAYER_Symbol)/LAYER_Symbol_GACS)/g' "$gacs_file"

    # Shared layers stay the same (no _GACS suffix)
    # LAYER_Emoji, LAYER_World, LAYER_System, LAYER_Mouse*, LAYER_Factory, LAYER_Lower, LAYER_Magic

    echo "  ✓ Created $gacs_file"
}

# Create GACS versions of layer files that need separate GACS variants
create_gacs_version "$LAYERS_DIR/base-layers.dtsi" "$LAYERS_DIR/base-layers-gacs.dtsi"
create_gacs_version "$LAYERS_DIR/typing-layer.dtsi" "$LAYERS_DIR/typing-layer-gacs.dtsi"
create_gacs_version "$LAYERS_DIR/finger-layers.dtsi" "$LAYERS_DIR/finger-layers-gacs.dtsi"
create_gacs_version "$LAYERS_DIR/function-layers.dtsi" "$LAYERS_DIR/function-layers-gacs.dtsi"

echo ""
echo "=== GACS layer files created successfully! ==="
echo ""
echo "Next steps:"
echo "1. Clean up base-layers-linux.dtsi (remove unused layouts)"
echo "2. Remove Gaming layer from special-layers.dtsi and special-layers-linux.dtsi"
echo "3. Update glove80.keymap to include new GACS layers"
echo "4. Create Magic 8 and update Magic 9 macros"
