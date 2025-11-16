# Custom DTSI Workflow: glove80-keymaps → ZMK Firmware

This guide explains how to integrate your custom keymap from the `glove80-keymaps` repo (with sunaku workflow) into this 64-layer capable ZMK firmware.

## Overview

```
┌───────────────────────────────────────────────────────────┐
│ glove80-keymaps repo                                      │
│ https://github.com/frangonf/glove80-keymaps               │
│                                                           │
│ ├── Use sunaku templating workflow                       │
│ ├── Generate custom keymap with your layout              │
│ ├── Generate PDF documentation                           │
│ └── Output: glove80.dtsi or glove80.keymap               │
└────────────────────┬──────────────────────────────────────┘
                     │
                     │ Copy generated file
                     ▼
┌───────────────────────────────────────────────────────────┐
│ zmk firmware (this repo)                                  │
│ https://github.com/frangonf/zmk                           │
│                                                           │
│ ├── Place at: app/boards/arm/glove80/glove80.keymap      │
│ ├── Build: nix-build -A glove80_combined                 │
│ └── Flash to keyboard                                    │
└───────────────────────────────────────────────────────────┘
```

## Prerequisites

1. **glove80-keymaps repo** - Your keymap generation repo with sunaku workflow
2. **zmk repo** (this repo) - 64-layer capable firmware
3. **Nix** - For building firmware (already set up in this repo)

## Workflow Steps

### Step 1: Set Up glove80-keymaps Repo

In your `glove80-keymaps` repository:

1. **Use the template** as a base:
   ```bash
   # Copy the template from this repo as a starting point
   cp ~/zmk/glove80-engram-64layer-template.keymap ~/glove80-keymaps/keymap.template.c
   ```

2. **Configure your layout** using the sunaku workflow:
   - Edit your keymap configuration files
   - Use templating to generate layers
   - Customize behaviors and macros

3. **Generate the keymap**:
   ```bash
   cd ~/glove80-keymaps
   # Use whatever command your workflow uses, e.g.:
   make generate
   # or
   ./generate-keymap.sh
   ```

4. **Output file** should be named `glove80.keymap` or `glove80.dtsi`

### Step 2: Copy Generated Keymap to Firmware

**Option A: Manual Copy**
```bash
# From glove80-keymaps repo to ZMK firmware
cp ~/glove80-keymaps/generated/glove80.keymap ~/zmk/app/boards/arm/glove80/glove80.keymap
```

**Option B: Use the automation script** (recommended - see below)
```bash
cd ~/zmk
./update-keymap-from-repo.sh
```

### Step 3: Build Firmware

```bash
cd ~/zmk
nix-build -A glove80_combined
```

The firmware files will be in `result/`:
- `result/glove80_left.uf2` - Flash to left half
- `result/glove80_right.uf2` - Flash to right half

### Step 4: Flash to Keyboard

1. Put left half in bootloader mode (Magic + left bootloader key)
2. Drag `glove80_left.uf2` to the USB drive
3. Repeat for right half with `glove80_right.uf2`

## Keymap Structure Requirements

### For Compatibility with This 64-Layer Firmware

Your generated keymap must:

1. **Include required headers**:
   ```c
   #include <behaviors.dtsi>
   #include <dt-bindings/zmk/keys.h>
   #include <dt-bindings/zmk/bt.h>
   #include <dt-bindings/zmk/ext_power.h>
   #include <dt-bindings/zmk/outputs.h>
   #include <dt-bindings/zmk/rgb.h>
   ```

2. **Define up to 64 layers** (0-63):
   ```c
   #define BASE 0
   #define SYM 1
   // ... up to layer 63
   ```

3. **Include the MAGIC layer** for bootloader access:
   ```c
   #define MAGIC 4  // Or any layer number

   magic_layer {
       bindings = <
       // Must include &bootloader and &sys_reset
       &bootloader ... &sys_reset
       >;
   };
   ```

4. **Use Glove80 physical layout** (80 keys):
   - Each layer needs exactly 80 key bindings
   - Format matches the template (6 rows, varying columns per row)

### For MoErgo Web Configurator Compatibility

The keymap format is **already compatible** with MoErgo web configurator because:
- Uses standard ZMK DTSI syntax
- Follows MoErgo's layout conventions
- Same behavior/macro definitions

**However**: The web configurator may not support 64 layers (it likely caps at 32). Your generated keymap can exceed this limit, but you'll only be able to edit layers 0-31 in the web UI.

## Templating Workflow Integration

### Recommended Structure in glove80-keymaps Repo

```
glove80-keymaps/
├── config/
│   ├── base.yaml          # Base layer definitions
│   ├── symbols.yaml       # Symbol layer
│   ├── numbers.yaml       # Number layer
│   └── extended.yaml      # Additional layers (5-63)
├── templates/
│   ├── header.dtsi        # Includes and defines
│   ├── behaviors.dtsi     # Custom behaviors
│   ├── macros.dtsi        # Custom macros
│   └── layers.dtsi        # Layer template
├── generate.sh            # Generation script
└── output/
    ├── glove80.keymap     # Generated keymap (copy to ZMK)
    └── glove80-layout.pdf # Documentation
```

### Example Generation Script

```bash
#!/bin/bash
# In glove80-keymaps repo

# Generate keymap from templates
cat templates/header.dtsi > output/glove80.keymap
echo "/ {" >> output/glove80.keymap
cat templates/behaviors.dtsi >> output/glove80.keymap
cat templates/macros.dtsi >> output/glove80.keymap
echo "    keymap {" >> output/glove80.keymap
echo "        compatible = \"zmk,keymap\";" >> output/glove80.keymap

# Generate layers from YAML configs
python3 generate_layers.py config/*.yaml >> output/glove80.keymap

echo "    };" >> output/glove80.keymap
echo "};" >> output/glove80.keymap

# Generate PDF documentation
python3 generate_pdf.py config/*.yaml output/glove80-layout.pdf

echo "Generated: output/glove80.keymap"
echo "Generated: output/glove80-layout.pdf"
```

## Automation Script

Create `update-keymap-from-repo.sh` in this ZMK repo:

```bash
#!/bin/bash
# Automatically copy keymap from glove80-keymaps repo to ZMK firmware

KEYMAP_REPO="$HOME/glove80-keymaps"
KEYMAP_SRC="$KEYMAP_REPO/output/glove80.keymap"
KEYMAP_DST="$HOME/zmk/app/boards/arm/glove80/glove80.keymap"

# Check if source exists
if [ ! -f "$KEYMAP_SRC" ]; then
    echo "Error: Keymap not found at $KEYMAP_SRC"
    echo "Generate keymap first in glove80-keymaps repo"
    exit 1
fi

# Backup current keymap
if [ -f "$KEYMAP_DST" ]; then
    cp "$KEYMAP_DST" "$KEYMAP_DST.backup"
    echo "Backed up current keymap to glove80.keymap.backup"
fi

# Copy new keymap
cp "$KEYMAP_SRC" "$KEYMAP_DST"
echo "Copied keymap from $KEYMAP_SRC"
echo "Ready to build with: nix-build -A glove80_combined"
```

## Testing Your Keymap

### Test Builds

Before flashing to hardware:

```bash
# Build left half only (faster for testing)
nix-build -A glove80_left

# Build right half only
nix-build -A glove80_right

# Build both (full test)
nix-build -A glove80_combined
```

### Verify 64-Layer Support

To test that all 64 layers work:

1. Define test layers at high indices (e.g., layers 60-63)
2. Add test bindings accessible from base layer
3. Flash and verify the high layers activate correctly

Example test:
```c
#define TEST_HIGH 63

base_layer {
    bindings = <
    &mo TEST_HIGH  // Hold F1 to access layer 63
    ...
    >;
};

layer_63 {
    bindings = <
    &kp X  // Type 'X' when layer 63 is active
    ...
    >;
};
```

## Troubleshooting

### Build Errors

**"Layer count exceeds maximum"**
- Old issue - should NOT occur with 64-layer patch
- Verify you're building from this branch

**"Undefined reference to behavior"**
- Check all behaviors are defined in `behaviors` section
- Verify behavior names match usage (case-sensitive)

**"DTSI syntax error"**
- Validate matching braces `{ }`
- Check semicolons after each binding
- Ensure exactly 80 bindings per layer

### Keymap Not Working

**Some keys don't work**
- Verify 80 bindings per layer (Glove80 has 80 keys)
- Check for typos in key codes
- Test with simple `&kp` bindings first

**Layers don't activate**
- Check layer indices are correct
- Verify `&mo`, `&lt`, or `&to` references valid layers
- Test with basic layer switching first

**Bootloader inaccessible**
- CRITICAL: Always keep the MAGIC layer intact
- Verify `&bootloader` binding exists
- Can reset via physical reset button if needed

## Advanced: Using Multiple Keymap Variants

You can maintain multiple keymap variants:

```bash
# In glove80-keymaps repo
output/
├── glove80-engram.keymap       # Engram layout
├── glove80-colemak.keymap      # Colemak variant
└── glove80-experimental.keymap # Testing new ideas

# In ZMK repo
app/boards/arm/glove80/
├── glove80.keymap              # Current active keymap
├── glove80-engram.keymap       # Backup variants
├── glove80-colemak.keymap
└── glove80-experimental.keymap

# Switch keymaps
cp app/boards/arm/glove80/glove80-experimental.keymap \
   app/boards/arm/glove80/glove80.keymap
nix-build -A glove80_combined
```

## Reference: 64-Layer Capabilities

This firmware supports:

- **Total layers**: 64 (indices 0-63)
- **Layer state**: 64-bit (vs standard 32-bit)
- **Layer operations**: All ZMK behaviors work with 64 layers
  - `&mo` - Momentary layer
  - `&lt` - Layer-tap
  - `&to` - Switch to layer
  - `&tog` - Toggle layer
- **Tested**: Full 64-layer functionality verified

## Additional Resources

- **ZMK Documentation**: https://zmk.dev/docs
- **Glove80 Layout**: 80 keys, split, column-staggered
- **Engram Layout**: https://engram.dev/
- **MoErgo Support**: https://www.moergo.com/

## Quick Reference

```bash
# In glove80-keymaps repo
make generate                    # Generate keymap + PDF

# Copy to firmware
cp output/glove80.keymap ~/zmk/app/boards/arm/glove80/

# Build firmware
cd ~/zmk
nix-build -A glove80_combined

# Flash
# result/glove80_left.uf2 → left half
# result/glove80_right.uf2 → right half
```
