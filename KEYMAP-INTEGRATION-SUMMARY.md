# Glove80 Keymap Integration: Quick Start

## TL;DR - The Workflow

```bash
# 1. In glove80-keymaps repo - generate your custom keymap
cd ~/glove80-keymaps
make generate  # (or your generation command)

# 2. Copy to ZMK firmware
cd ~/zmk
./update-keymap-from-repo.sh

# 3. Build firmware
nix-build -A glove80_combined

# 4. Flash result/*.uf2 files to keyboard
```

## What You Get

### ✅ **64-Layer Support**
- Your firmware now supports **64 layers** (0-63) instead of standard 32
- All ZMK behaviors work with high layers: `&mo 63`, `&lt 50 SPACE`, etc.
- Successfully tested with layers up to 63

### ✅ **Sunaku Workflow Compatibility**
- Keep your existing templating system in glove80-keymaps repo
- Generate PDF documentation as before
- Just copy the output `.keymap` file to this firmware repo

### ✅ **MoErgo Web Compatibility**
- Generated keymaps use standard ZMK DTSI format
- Compatible with MoErgo web configurator syntax
- **Note**: Web UI may only edit layers 0-31, but firmware supports all 64

## Files Created for You

### 📄 `glove80-engram-64layer-template.keymap`
**Complete working template** for Engram layout with:
- Home row mods optimized for Engram
- 64-layer support built-in
- All required behaviors and macros
- Critical MAGIC layer for bootloader access
- Ready to use as-is or customize

**How to use**:
```bash
# Copy to your glove80-keymaps repo as starting point
cp glove80-engram-64layer-template.keymap ~/glove80-keymaps/keymap.template.c

# Customize with your templating workflow
# Generate final keymap
# Copy back to ZMK firmware and build
```

### 📄 `CUSTOM-KEYMAP-WORKFLOW.md`
**Complete workflow guide** covering:
- Step-by-step integration process
- Keymap structure requirements
- Templating workflow integration examples
- Troubleshooting guide
- Testing strategies

### 📄 `update-keymap-from-repo.sh` (executable)
**Automation script** that:
- Copies keymap from glove80-keymaps repo
- Validates keymap structure
- Creates timestamped backups
- Copies PDF documentation if available
- Shows next steps

## Key Concepts

### Why This Workflow?

**Traditional approach** (limited):
```
Edit keymap directly in firmware → Build → Flash
❌ No templating
❌ No automated documentation
❌ Hard to maintain complex layouts
```

**Your approach** (optimal):
```
Templates → Generate keymap + PDF → Copy to firmware → Build → Flash
✅ Use sunaku templating
✅ Auto-generate documentation
✅ Easy to maintain and iterate
✅ Support for 64 layers
```

### Keymap Structure

Your generated keymap must be a **complete ZMK DTSI file**:

```c
// Required headers
#include <behaviors.dtsi>
#include <dt-bindings/zmk/keys.h>
// ... other includes

/ {
    behaviors { ... };  // Optional custom behaviors
    macros { ... };     // Optional macros

    keymap {
        compatible = "zmk,keymap";

        layer_0 { bindings = < /* 80 bindings */ >; };
        layer_1 { bindings = < /* 80 bindings */ >; };
        // ... up to layer_63
    };
};
```

**Critical requirements**:
- Each layer: **exactly 80 key bindings** (Glove80 has 80 keys)
- Must include **MAGIC layer** with `&bootloader` and `&sys_reset` for firmware updates
- Layer indices: 0-63 (64 total)

### The MAGIC Layer (Critical!)

**Always include this layer** - it's your only way to enter bootloader mode:

```c
#define MAGIC 4  // Or any layer number you prefer

magic_layer {
    bindings = <
    &bt BT_CLR     ...                                          ... &bt BT_CLR_ALL
    ...
    &bootloader    &rgb_ug RGB_SPD ... &rgb_ug RGB_EFF         ... &bootloader
    &sys_reset     ...                                          ... &sys_reset
    ...
    >;
};
```

Access via: `&magic MAGIC 0` binding (hold for layer, tap for RGB status)

## Engram Layout Notes

The template includes **optimized home row mods** for Engram:

```
Engram home row:  C    I    E    A    ,    .    H    T    S    N
With mods:        Ctrl Alt  Shift Cmd       Cmd  Shift Alt  Ctrl
```

**Why home row mods?**
- Reduces hand movement
- No need for dedicated modifier keys
- Balanced between left/right hands
- Essential for ergonomic layouts like Engram

## Example: Extending to 64 Layers

Here's how to use the 64-layer capability:

```c
// Define layers for different contexts
#define BASE      0   // Engram base
#define SYM       1   // Symbols
#define NUM       2   // Numbers
#define FN        3   // Functions
#define MAGIC     4   // System

// Programming language layers
#define PYTHON    10  // Python-specific symbols
#define RUST      11  // Rust-specific symbols
#define JS        12  // JavaScript snippets

// International layers
#define FRENCH    20  // French accents
#define SPANISH   21  // Spanish characters
#define GERMAN    22  // German umlauts

// Special purpose
#define EMOJI     30  // Emoji shortcuts
#define GREEK     31  // Greek letters for math
#define GAMING    40  // Gaming layout (WASD-based)
#define CAD       50  // CAD software shortcuts

// Access from base layer
base_layer {
    bindings = <
    &lt PYTHON F1  &lt RUST F2  &lt JS F3  ...
    // Hold F1 = Python layer, F2 = Rust layer, etc.
    >;
};
```

## Workflow Variations

### One-Time Setup
```bash
# Just use the template directly
cp glove80-engram-64layer-template.keymap app/boards/arm/glove80/glove80.keymap
nix-build -A glove80_combined
# Flash and done!
```

### Iterative Development (Recommended)
```bash
# 1. Set up glove80-keymaps repo with sunaku workflow
cd ~/glove80-keymaps
# Configure templates, macros, layer definitions

# 2. Generate keymap whenever you make changes
make generate
cp output/glove80.keymap ~/zmk/app/boards/arm/glove80/

# 3. Test build
cd ~/zmk
nix-build -A glove80_combined

# 4. If build succeeds, flash to keyboard
# If build fails, fix in glove80-keymaps repo and repeat

# 5. Keep PDF documentation for reference
cp ~/glove80-keymaps/output/glove80-layout.pdf ~/reference/
```

### Multi-Keymap Management
```bash
# Maintain multiple keymap variants
~/zmk/app/boards/arm/glove80/
├── glove80.keymap              # Active keymap
├── keymaps/
│   ├── engram-main.keymap      # Your daily driver
│   ├── engram-experimental.keymap  # Testing new ideas
│   ├── colemak.keymap          # Backup layout
│   └── qwerty.keymap           # Emergency fallback

# Switch keymaps
cp keymaps/engram-experimental.keymap glove80.keymap
nix-build -A glove80_combined
```

## Testing Checklist

Before flashing to keyboard:

- [ ] Keymap builds successfully: `nix-build -A glove80_combined`
- [ ] MAGIC layer accessible (check for `&magic MAGIC 0` binding)
- [ ] Bootloader binding present (`&bootloader` in MAGIC layer)
- [ ] All layers have exactly 80 bindings
- [ ] High layers (32+) accessible if using 64-layer feature
- [ ] Home row mods configured correctly (if using)
- [ ] Layer switching works as expected

## Troubleshooting

### Build fails with "layer count exceeds maximum"
- **Old error** - shouldn't happen with this 64-layer firmware
- Verify you're on branch: `claude/generate-64-layer-outputs-018jA5uz6ENRzABGDmPos5FP`
- Check: `git branch --show-current`

### Keymap not updating after copy
- Clear Nix build cache: `rm -rf result`
- Rebuild: `nix-build -A glove80_combined`
- Verify file was actually copied: `cat app/boards/arm/glove80/glove80.keymap | head -20`

### Can't enter bootloader mode
- **CRITICAL**: Check MAGIC layer is defined
- Physical reset button: Small hole on keyboard PCB (emergency only)
- Verify `&bootloader` binding exists in keymap

### Some layers don't work
- **For layers 0-31**: Should work on any ZMK firmware
- **For layers 32-63**: Requires THIS firmware with 64-layer patch
- Check layer is defined and referenced correctly

## Additional Resources

- **Full workflow guide**: `CUSTOM-KEYMAP-WORKFLOW.md`
- **Template keymap**: `glove80-engram-64layer-template.keymap`
- **Update script**: `./update-keymap-from-repo.sh`
- **64-layer test**: `glove80-safe-64layer-test.keymap` (proof it works!)

## Questions?

**Q: Do I need to use the template?**
A: No, any valid ZMK keymap works. Template is just a good starting point.

**Q: Can I use only 10 layers instead of 64?**
A: Yes! Use as many or few as you need (1-64). Firmware supports up to 64.

**Q: Will this work with MoErgo web configurator?**
A: Generated keymaps are compatible, but web UI may only show 32 layers.

**Q: Can I still use factory reset?**
A: Yes, as long as you keep the MAGIC layer with bootloader bindings.

**Q: What if I don't have glove80-keymaps repo set up?**
A: Use the template directly or edit it manually. Templating is optional.

## Ready to Start?

```bash
# Quick start (using template as-is)
cd ~/zmk
cp glove80-engram-64layer-template.keymap app/boards/arm/glove80/glove80.keymap
nix-build -A glove80_combined
# Flash result/*.uf2 files!

# Or with glove80-keymaps workflow
cd ~/glove80-keymaps
# Set up your generation workflow
# Generate keymap
cd ~/zmk
./update-keymap-from-repo.sh
nix-build -A glove80_combined
# Flash result/*.uf2 files!
```

---

**Happy typing with your 64-layer Glove80 Engram layout! 🎉**
