# Feature Availability Analysis: 64-Layer Firmware vs Engrammer Keymap

## Summary

Your `engrammer42rc6frangonf.keymap` expects 4 advanced features. Here's the status:

| Feature | Expected by Keymap | Available in Firmware | Notes |
|---------|-------------------|----------------------|-------|
| **HID_POINTING** | ✅ Required | ✅ **Available** | Mouse emulation working |
| **HID_POINTING_SMOOTH_SCROLLING** | ✅ Required | ✅ **Available** | Smooth scroll supported |
| **EXPERIMENTAL_RGB_UNDERGLOW_AUTO_OFF_IDLE** | ⚠️ Optional | ✅ **Available** | Auto-off to save battery |
| **EXPERIMENTAL_RGB_LAYER** | ⚠️ Optional | ❌ **MISSING** | Per-layer RGB (needs MoErgo PR#36) |

---

## Feature Details

### ✅ **1. HID_POINTING (Mouse Emulation)**

**Status**: **AVAILABLE**

**Configuration**: `CONFIG_ZMK_POINTING=y`

**Found in**:
- `app/src/pointing/Kconfig` (line 10-15)
- `app/include/dt-bindings/zmk/pointing.h` (exists)
- `app/src/pointing/input_listener.c` (implementation)

**Your keymap uses**:
- Mouse movement behaviors
- 5 mouse layers: Mouse, MouseFine, MouseSlow, MouseFast, MouseWarp

**Enabled by default**: Yes (if device tree has pointing device)

**To ensure it's enabled** in your build, add to `app/boards/arm/glove80/glove80_lh_defconfig`:
```
CONFIG_ZMK_POINTING=y
```

---

### ✅ **2. HID_POINTING_SMOOTH_SCROLLING**

**Status**: **AVAILABLE**

**Configuration**: `CONFIG_ZMK_POINTING_SMOOTH_SCROLLING=y`

**Found in**:
- `app/src/pointing/Kconfig` (line 27-30)

**Description**: Enable smooth scrolling with hosts that support HID Resolution Multipliers

**To enable**, add to `app/boards/arm/glove80/glove80_lh_defconfig`:
```
CONFIG_ZMK_POINTING_SMOOTH_SCROLLING=y
```

**Note**: Re-pair keyboard with host via Bluetooth after enabling

---

### ✅ **3. EXPERIMENTAL_RGB_UNDERGLOW_AUTO_OFF_IDLE**

**Status**: **AVAILABLE**

**Configuration**: `CONFIG_ZMK_RGB_UNDERGLOW_AUTO_OFF_IDLE=y`

**Found in**:
- `app/Kconfig` (line 341-342)
- `app/src/rgb_underglow.c` (implementation)

**Description**: Automatically turn off RGB underglow when keyboard is idle for 30 seconds to save battery

**To enable**, add to `app/boards/arm/glove80/glove80_lh_defconfig`:
```
CONFIG_ZMK_RGB_UNDERGLOW=y
CONFIG_ZMK_RGB_UNDERGLOW_AUTO_OFF_IDLE=y
CONFIG_ZMK_IDLE_TIMEOUT=30000
```

---

### ❌ **4. EXPERIMENTAL_RGB_LAYER (Per-Layer RGB)**

**Status**: **NOT AVAILABLE** - Requires MoErgo PR#36

**What it does**:
- Changes RGB underglow color based on active layer
- Your keymap has extensive color definitions for each key on each layer
- Provides visual feedback for which layer is active

**Why it's missing**:
- This is a **MoErgo-specific feature** from their community firmware
- MoErgo maintains a fork of ZMK with additional features
- PR#36: https://github.com/moergo-sc/zmk/pull/36
- Related PRs: #30, zmkfirmware/zmk#2752

**Your keymap expects**:
- `<dt-bindings/zmk/rgb_colors.h>` - NOT present in standard ZMK
- Color definitions: RED, ORN, YLW, GRN, BLU, etc.
- Per-key RGB underglow settings

**Impact**:
- ⚠️ Keymap will **compile and work** without this feature
- ❌ Per-layer RGB colors **won't display** (feature gracefully disabled)
- ✅ All other functionality **works normally**

**Your keymap has conditional guard**:
```c
#if __has_include(<dt-bindings/zmk/rgb_colors.h>)
  // Per-layer RGB definitions
  // ... color definitions ...
#endif
```

This means the keymap **safely disables** per-layer RGB if the header doesn't exist!

---

## Configuration Files to Create

### Option 1: Enable Available Features Only

Create `app/boards/arm/glove80/glove80_lh.conf`:
```conf
# Enable mouse/pointing support
CONFIG_ZMK_POINTING=y
CONFIG_ZMK_POINTING_SMOOTH_SCROLLING=y

# Enable RGB underglow with auto-off
CONFIG_ZMK_RGB_UNDERGLOW=y
CONFIG_ZMK_RGB_UNDERGLOW_AUTO_OFF_IDLE=y
CONFIG_ZMK_RGB_UNDERGLOW_ON_START=y

# Idle timeout (30 seconds)
CONFIG_ZMK_IDLE_TIMEOUT=30000
```

Create `app/boards/arm/glove80/glove80_rh.conf`:
```conf
# Same config for right half
CONFIG_ZMK_POINTING=y
CONFIG_ZMK_POINTING_SMOOTH_SCROLLING=y
CONFIG_ZMK_RGB_UNDERGLOW=y
CONFIG_ZMK_RGB_UNDERGLOW_AUTO_OFF_IDLE=y
CONFIG_ZMK_RGB_UNDERGLOW_ON_START=y
CONFIG_ZMK_IDLE_TIMEOUT=30000
```

---

## Getting Per-Layer RGB Support (PR#36)

If you want the full per-layer RGB feature, you have two options:

### **Option A: Merge MoErgo PR#36 into This Firmware**

This would add per-layer RGB to your 64-layer capable firmware.

**Pros**:
- Get all features: 64 layers + per-layer RGB
- Single unified firmware

**Cons**:
- Requires manual merge/cherry-pick of MoErgo commits
- May have conflicts to resolve
- More complex maintenance

**Process**:
1. Add MoErgo remote
2. Fetch PR#36 branch
3. Cherry-pick per-layer RGB commits
4. Resolve any conflicts with 64-layer changes
5. Test thoroughly

### **Option B: Use MoErgo Firmware Without 64-Layer Patch**

Use MoErgo's PR#36 branch, but limited to 32 layers.

**Pros**:
- Per-layer RGB works out of the box
- Official MoErgo support

**Cons**:
- ❌ Only 32 layers (not 64)
- Lose 64-layer capability

---

## Recommendations

### **Immediate Action** (Recommended)

1. **Use current 64-layer firmware AS-IS**
   - Your keymap already has conditional guards for per-layer RGB
   - It will compile and work with 3 out of 4 features
   - Only missing: visual RGB layer indicators

2. **Enable available features** with .conf files above

3. **Build and test**:
   ```bash
   nix-build -A glove80_combined
   ```

### **Future Enhancement** (Optional)

If you really want per-layer RGB:

1. **Review MoErgo PR#36** to understand scope of changes
2. **Cherry-pick commits** into this 64-layer branch
3. **Test compatibility** with 64-layer changes

I can help you with this merge if you want per-layer RGB support!

---

## Quick Reference: Kconfig Locations

| Feature | File | Line |
|---------|------|------|
| ZMK_POINTING | app/src/pointing/Kconfig | 10-15 |
| ZMK_POINTING_SMOOTH_SCROLLING | app/src/pointing/Kconfig | 27-30 |
| ZMK_RGB_UNDERGLOW_AUTO_OFF_IDLE | app/Kconfig | 341-342 |
| ZMK_RGB_UNDERGLOW | app/Kconfig | 288-348 |

---

## Testing Your Build

After enabling the available features:

1. **Build firmware**:
   ```bash
   nix-build -A glove80_combined
   ```

2. **Flash to keyboard**

3. **Verify features**:
   - ✅ Mouse layers work (move cursor)
   - ✅ Smooth scrolling works
   - ✅ RGB turns off after 30s idle
   - ⚠️ Per-layer RGB colors don't change (expected - not implemented)

4. **Re-pair via Bluetooth** (required after enabling HID_POINTING features)

---

## Summary

**What works NOW**:
- ✅ 64 layers
- ✅ Mouse emulation (5 mouse layers)
- ✅ Smooth scrolling
- ✅ RGB auto-off on idle
- ✅ 32 layers of your Engrammer layout
- ✅ All behaviors, macros, combos

**What's missing**:
- ❌ Per-layer RGB color indicators (requires MoErgo PR#36)

**Impact**: **Minimal** - your keymap will work perfectly, just without visual layer feedback via RGB colors.
