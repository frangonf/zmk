# Safe 64-Layer Testing Guide for Glove80

## Why This Keymap is Safe

The `glove80-safe-64layer-test.keymap` preserves **all factory functionality**:

✅ **Layer 0 (DEFAULT)** - Your normal typing layout (with F1-F5 modified for testing)
✅ **Layer 1 (LOWER)** - Function/numpad layer (unchanged)
✅ **Layer 2 (MAGIC)** - **CRITICAL!** Bootloader, reset, RGB, Bluetooth (unchanged)
✅ **Layer 3 (FACTORY_TEST)** - Factory testing (unchanged)
✅ All factory macros and behaviors preserved

**You CANNOT brick your Glove80** because:
- MAGIC layer is intact (bootloader access via bottom-left palm key)
- Reset/bootloader functions work normally
- All emergency recovery methods preserved

## How to Test 64-Layer Support

### Step 1: Build with the Safe Keymap

```bash
# Copy safe keymap over the default
cp glove80-safe-64layer-test.keymap app/boards/arm/glove80/glove80.keymap

# If Nix was just installed or not in PATH, source it:
source ~/.nix-profile/etc/profile.d/nix.sh

# Build using Nix (recommended for this repo)
nix-build -A glove80_combined

# This creates a combined firmware file at:
# ./result/glove80.uf2

# Or build left/right separately:
nix-build -A glove80_left    # Creates ./result/zmk.uf2 (left)
nix-build -A glove80_right   # Creates ./result/zmk.uf2 (right)
```

**Note about `source ~/.nix-profile/etc/profile.d/nix.sh`:**
- Only needed if `nix-build` command is not found
- Required after installing Nix in the same terminal session
- Not needed if opening a fresh terminal after Nix install
- Check with: `which nix-build` (if it shows a path, you're good!)

### Step 2: Flash to Glove80

**Using combined firmware (simplest):**

1. **Flash left half first:**
   - Hold Magic key (bottom-left palm) + 0 key
   - USB drive "GLV80LHBOOT" appears
   - Copy: `cp result/glove80.uf2 /media/<user>/GLV80LHBOOT/`
   - Wait for it to reboot

2. **Flash right half:**
   - Hold Magic key (bottom-right palm) + 0 key
   - USB drive "GLV80RHBOOT" appears
   - Copy: `cp result/glove80.uf2 /media/<user>/GLV80RHBOOT/`
   - Wait for it to reboot

**Note:** The combined firmware file works for both halves!

### Step 3: Test the High Layers

Once flashed, test that layers 32-63 work:

| Key to Hold | Layer Activated | What You Should See |
|-------------|----------------|---------------------|
| **F1** | Layer 32 | F13-F24 function keys work |
| **F2** | Layer 40 | Bluetooth controls (pair/switch devices) |
| **F3** | Layer 50 | Media controls (play/pause, volume) |
| **F4** | Layer 60 | System keys (Print Screen, Scroll Lock, Insert) |
| **F5** | Layer 63 | Reset/bootloader access (highest layer!) |

**How to test:**
1. Hold F1 → Type where F13-F24 would be → Release F1
2. Hold F2 → Use Bluetooth controls → Release F2
3. Hold F3 → Test media keys → Release F3
4. Hold F4 → Test Print Screen, etc. → Release F4
5. Hold F5 → Access reset (top-left corner) → Release F5

**If any of these layers work, it PROVES 64-layer support is working!**

Layers 32-63 are impossible without the 64-bit patch.

## How &mo (Momentary) Works

All test layers use `&mo` behavior:
- **Hold key** = Layer activates
- **Release key** = Automatically return to base layer

Example:
```
Hold F1 → Layer 32 active → Press key → Get F13
Release F1 → Back to layer 0 → Press same key → Get normal character
```

No need to manually return - it's automatic when you release!

## Emergency Recovery (Just in Case)

If something goes wrong (it won't, but just in case):

### Method 1: MAGIC Layer (Always Works)
1. Hold **bottom-left palm key** (Magic)
2. Press **left pinky key** (bootloader) or **top-left corner** (sys_reset)
3. Re-flash factory firmware

### Method 2: Hardware Reset
1. Unplug keyboard
2. Remove battery (if comfortable doing so)
3. Reconnect and enter bootloader mode

### Method 3: Factory Firmware
Keep a backup of the original MoErgo firmware:
```bash
# Before testing, backup factory firmware
cp app/boards/arm/glove80/glove80.keymap glove80-factory-backup.keymap
```

## Understanding the Layers

```
Layers 0-3:   Factory MoErgo layers (SAFE - never modified)
Layers 4-31:  Placeholder layers (just pass-through with &trans)
Layers 32-63: TEST LAYERS - These PROVE 64-bit support works!
              Without the patch, these would crash or not work
```

## Why This Proves 64-Layer Support

**Without the 64-bit patch:**
- Layers 32-63 would be IMPOSSIBLE
- The firmware might compile but crash at runtime
- Layer activation beyond 31 would fail

**With the 64-bit patch:**
- All 64 layers (0-63) work correctly
- Layer state tracked in 64-bit variable
- BIT64() macros handle high layers properly

If you can activate layer 32, 40, 50, 60, or 63 and they work correctly, **it definitively proves the 64-layer implementation is successful!**

## Reverting to Factory Keymap

If you want to go back to stock:

```bash
# Restore from git
git checkout app/boards/arm/glove80/glove80.keymap

# Or use your backup
cp glove80-factory-backup.keymap app/boards/arm/glove80/glove80.keymap

# Rebuild and reflash
```

## FAQs

**Q: Will this brick my keyboard?**
A: No! All factory safety features (MAGIC layer, bootloader access, reset) are preserved.

**Q: Can I use my normal keymap after testing?**
A: Yes! The 64-layer support is in the firmware core, not the keymap. Any keymap can now use up to 64 layers.

**Q: What if the build fails?**
A: Check BUILD_INSTRUCTIONS.md for troubleshooting. Most issues are dependency-related.

**Q: Can I customize this keymap?**
A: Absolutely! Edit `glove80-safe-64layer-test.keymap` to add your own bindings to layers 32-63.

**Q: Why not make this the default?**
A: This is a TEST keymap. Once verified working, you can create your own custom 64-layer layout!
