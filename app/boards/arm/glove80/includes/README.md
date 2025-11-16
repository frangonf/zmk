# Glove80 Modular Keymap Structure

This directory contains the modularized components of the Glove80 keymap, split from the original monolithic `glove80.keymap` file for better maintainability and organization.

## Directory Structure

```
includes/
├── README.md                    # This file
├── helpers.dtsi                 # Helper macros and layer definitions
├── custom-nodes.dtsi            # Custom device-tree nodes (RGB indicators, etc.)
├── behaviors.dtsi               # All custom behaviors, macros, and world characters
├── combos.dtsi                  # Combo definitions
└── layers/
    ├── base-layers.dtsi         # Base layout layers (QWERTY, Enthium, Engrammer, etc.)
    ├── typing-layer.dtsi        # Typing layer
    ├── finger-layers.dtsi       # Home row mod finger layers (Left/Right Pinky, Ringy, Middy, Index)
    ├── function-layers.dtsi     # Function layers (Cursor, Number, Function, Emoji, World, Symbol, System)
    ├── mouse-layers.dtsi        # Mouse control layers (Mouse, MouseFine, MouseSlow, MouseFast, MouseWarp)
    └── special-layers.dtsi      # Special layers (Gaming, Factory, Lower, Magic)
```

## File Descriptions

### helpers.dtsi (72 lines)
Contains preprocessor macros and layer number definitions:
- Helper macros from urob/zmk-helpers (VARGS, CONCAT, ZMK_BEHAVIOR, etc.)
- Layer number definitions (LAYER_QWERTY through LAYER_Magic)
- Tap-dance helper macros

### custom-nodes.dtsi (555 lines)
Custom device-tree nodes including:
- Per-key RGB layer indicators (requires PR36 beta firmware)
- RGB color definitions and macros
- Underglow layer configurations for all 32 layers

### behaviors.dtsi (10,819 lines)
The largest file containing:
- Input listeners
- System behaviors and macros
- Bluetooth behaviors (bt_0, bt_1, bt_2, bt_3)
- Home row mod behaviors for all layers
- Mod-morph behaviors
- World character definitions (Unicode/Compose sequences)
- Sticky key behaviors
- All custom macros

### combos.dtsi (176 lines)
Combo key definitions:
- Sticky modifier combos (Globe, RAlt, Shift)
- Tab switcher combos (Alt+Tab, Win+Tab, Ctrl+Tab)
- Special combos (Hyper, Meh, Caps Word, Caps Lock)
- Layer toggle combos (Gaming, Typing)
- Base layer reset combos

### Layer Files

#### base-layers.dtsi (76 lines)
The 7 base keyboard layouts:
- QWERTY (Layer 0)
- Enthium (Layer 1)
- Engrammer (Layer 2)
- Engram (Layer 3)
- Dvorak (Layer 4)
- Colemak (Layer 5)
- ColemakDH (Layer 6)

#### typing-layer.dtsi (10 lines)
- Typing Layer (Layer 7)

#### finger-layers.dtsi (87 lines)
Home row mod activation layers (8 layers):
- LeftPinky (Layer 8)
- LeftRingy (Layer 9)
- LeftMiddy (Layer 10)
- LeftIndex (Layer 11)
- RightPinky (Layer 12)
- RightRingy (Layer 13)
- RightMiddy (Layer 14)
- RightIndex (Layer 15)

#### function-layers.dtsi (76 lines)
Utility and symbol layers (7 layers):
- Cursor (Layer 16) - Navigation keys
- Number (Layer 17) - Number pad
- Function (Layer 18) - Function keys
- Emoji (Layer 19) - Emoji input
- World (Layer 20) - International characters
- Symbol (Layer 21) - Symbols and punctuation
- System (Layer 22) - System controls

#### mouse-layers.dtsi (54 lines)
Mouse control layers (5 layers):
- Mouse (Layer 23) - Standard mouse control
- MouseFine (Layer 24) - Precise mouse movement
- MouseSlow (Layer 25) - Slow mouse movement
- MouseFast (Layer 26) - Fast mouse movement
- MouseWarp (Layer 27) - Mouse warping

#### special-layers.dtsi (44 lines)
Special purpose layers (4 layers):
- Gaming (Layer 28) - Gaming optimized layout
- Factory (Layer 29) - Factory default layout
- Lower (Layer 30) - Numpad and layer toggles
- Magic (Layer 31) - Firmware controls (Bluetooth, RGB, reset)

## Working with the Modular Keymap

### Editing Layers
To modify a specific layer, edit the corresponding `.dtsi` file in `includes/layers/`. The layer definitions are plain devicetree nodes without wrapper structures, making them easy to read and modify.

Example: To change the QWERTY layout, edit `includes/layers/base-layers.dtsi` and find the `layer_QWERTY` node.

### Adding New Behaviors
Add custom behaviors, macros, or hold-taps to `includes/behaviors.dtsi`.

### Modifying Combos
Edit `includes/combos.dtsi` to add, remove, or modify key combinations.

### Changing Layer Numbers
If you need to reorder or add layers, update the layer definitions in `includes/helpers.dtsi`.

### Testing Changes
After editing any `.dtsi` file, rebuild using your normal build process:
```bash
nix-build -A glove80_combined
```

The modular structure is fully compatible with the original build system. The preprocessor will expand all includes during compilation.

## Original File
The original monolithic keymap has been preserved as `glove80.keymap.backup` (11,834 lines) for reference.

## Benefits of Modular Structure

1. **Easier Navigation**: Find specific features quickly in dedicated files
2. **Targeted Editing**: Modify one aspect without scrolling through thousands of lines
3. **Better Version Control**: Git diffs are more meaningful when changes are in separate files
4. **Collaborative Work**: Multiple people can work on different layers simultaneously
5. **Reusability**: Share specific layer configurations between different keymaps
6. **Maintainability**: Easier to understand and update individual components

## Compatibility

This modular structure is 100% compatible with:
- ZMK firmware build system
- Nix build process (`nix-build -A glove80_combined`)
- MoErgo Glove80 Layout Editor (can still export and merge updates)
- All existing behaviors and features

The devicetree preprocessor expands all `#include` directives before compilation, so the final compiled keymap is identical to the original monolithic version.
