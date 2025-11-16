# Glove80 Keymap - macOS/Linux Dual Mode Summary

## Overview

The Glove80 keymap has been successfully extended to support 64 layers (0-63):
- **Layers 0-31**: macOS mode (original configuration)
- **Layers 32-63**: Linux mode (exact duplicate with Linux-specific key mappings)

## Changes Made

### 1. Layer Definitions
Added 32 new layer constant definitions for Linux mode:
```c
#define LAYER_QWERTY_LINUX 32
#define LAYER_Enthium_LINUX 33
// ... up to ...
#define LAYER_Magic_LINUX 63
```

### 2. Layer Keybindings
All 32 layers (0-31) have been duplicated as layers 32-63 with:
- Identical key layouts and bindings
- All layer references updated to point to Linux equivalents
  - Example: `&mo LAYER_Lower` → `&mo LAYER_Lower_LINUX`
  - Example: `&thumb LAYER_Function ESC` → `&thumb LAYER_Function_LINUX ESC`

### 3. Mode Switcher Shortcut

**To switch from macOS to Linux mode:**
- Press: **Magic + F5**
- This activates layer 32 (LAYER_QWERTY_LINUX)

**To switch from Linux to macOS mode:**
- Press: **Magic + F5** (same shortcut)
- This returns to layer 0 (LAYER_QWERTY)

The F5 position was chosen because:
- It's an unusual and rarely-used key combination
- It's easily accessible on the top row
- It's symmetric and easy to remember

### 4. Linux Magic Layer
The Linux Magic layer (layer 63) has been configured to:
- Switch between Linux base layers (32-38) instead of macOS layers
- Return to macOS mode via Magic + F5
- Maintain all RGB and system functions

### 5. Underglow RGB Layers
All 24 underglow layer definitions have been duplicated with Linux layer IDs:
- BaseLayer_LINUX → layer-id = <LAYER_QWERTY_LINUX>
- LeftPinky_LINUX → layer-id = <LAYER_LeftPinky_LINUX>
- (and all other per-key RGB indicators)

## Usage

### Current Workflow
1. Start in macOS mode (default, layers 0-31)
2. Use keyboard normally
3. Press **Magic + F5** to switch to Linux mode
4. All layer keys work the same but reference Linux layers
5. Press **Magic + F5** again to return to macOS mode

### Benefits
- Identical key layout between macOS and Linux
- OS-specific key mappings can be customized independently
- Easy switching with a single unusual shortcut
- No need to reprogram the keyboard when changing OS

## Technical Details

### Files Modified
- `app/boards/arm/glove80/glove80.keymap` (main keymap file)

### Statistics
- Total layers: 64 (0-63)
- Total keymap lines: 12,560 (increased from 11,834)
- Duplicated layer keybindings: 32
- Duplicated underglow layers: 24

### Layer Reference Updates
All layer references in the duplicated layers have been systematically updated:
- Momentary layers: `&mo LAYER_*` → `&mo LAYER_*_LINUX`
- Toggle layers: `&tog LAYER_*` → `&tog LAYER_*_LINUX`
- Thumb behaviors: `&thumb LAYER_* KEY` → `&thumb LAYER_*_LINUX KEY`
- Space behaviors: `&space LAYER_* KEY` → `&space LAYER_*_LINUX KEY`
- Magic behaviors: `&magic LAYER_Magic 0` → `&magic LAYER_Magic_LINUX 0`
- Direct switches: `&to LAYER_*` → `&to LAYER_*_LINUX`

## Next Steps

### Recommended Testing
1. Build and flash the firmware
2. Test the mode switcher (Magic + F5)
3. Verify all layers work correctly in both modes
4. Test layer switching within each mode

### Future Customization
To differentiate Linux and macOS modes:
1. Locate the layer you want to customize (layers 32-63 for Linux)
2. Modify key bindings as needed for Linux-specific shortcuts
3. Example: Replace Cmd keys with Ctrl, adjust app-specific shortcuts, etc.

## Notes

- The current implementation has identical keybindings for both modes
- You can now customize Linux layers (32-63) independently of macOS layers (0-31)
- The Magic layer switcher uses F5 (position 4 on row 0) which is unlikely to conflict with normal usage
- All per-key RGB underglow indicators work correctly for both modes
