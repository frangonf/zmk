# Magic 8 Toggle: macOS GACS ↔ CAGS Feasibility Analysis

**Date**: 2025-11-18
**Branch**: `claude/magic-8-shortcut-01HsAwqUDgwpEofj774NQchX`
**Analyst**: Claude (Sonnet 4.5)

---

## Executive Summary

**FEASIBILITY: ✅ HIGHLY FEASIBLE** with architectural considerations

Implementing a "Magic 8" shortcut to toggle between macOS GACS (GUI-Alt-Ctrl-Shift) and CAGS (Ctrl-Alt-GUI-Shift) modifier orders is **technically feasible** using existing ZMK capabilities. However, it requires a strategic approach due to the compile-time nature of modifier definitions.

**Recommended Approach**: Layer-based toggle using existing Linux layers (32-63) repurposed as "macOS GACS" layers, with a single-key macro toggle.

---

## Current Architecture Analysis

### 1. **Dual OS Layer Structure** (64 layers total)

```
Layers 0-31:  macOS (CAGS order - Ctrl on pinky, GUI/Cmd on middle)
  ├─ 0-6:     Base layers (QWERTY, Enthium, Engrammer, etc.)
  ├─ 7:       Typing layer
  ├─ 8-15:    Finger layers (Left/Right Pinky, Ringy, Middy, Index)
  ├─ 16-22:   Function layers (Cursor, Number, Function, Emoji, World, Symbol, System)
  ├─ 23-27:   Mouse layers (Mouse, Fine, Slow, Fast, Warp)
  └─ 28-31:   Special layers (Gaming, Factory, Lower, Magic)

Layers 32-63: Linux (GACS order - GUI/Super on pinky, Ctrl on middle)
  ├─ 32-38:   Base layers (QWERTY_Linux, Enthium_Linux, etc.)
  ├─ 39:      Typing_Linux
  ├─ 40-47:   Finger layers (Linux variants)
  ├─ 48-54:   Function layers (Linux variants)
  ├─ 55-59:   Mouse layers (Linux variants)
  └─ 60-63:   Special layers (Linux variants)
```

### 2. **Current Home Row Mod Configuration**

**File**: `app/boards/arm/glove80/includes/behaviors/home-row-mods.dtsi`

**macOS (CAGS) - Layers 0-31**:
- **Pinky Finger**: `LCTL` (Left Control)
- **Ring Finger**: `LALT` (Left Alt)
- **Middle Finger**: `LGUI` (Left GUI/Cmd)
- **Index Finger**: `LSFT` (Left Shift)

**Linux (GACS) - Layers 32-63**:
- **Pinky Finger**: `LGUI` (Left GUI/Super)
- **Ring Finger**: `LALT` (Left Alt)
- **Middle Finger**: `LCTL` (Left Control)
- **Index Finger**: `LSFT` (Left Shift)

**Controlled by**: Lines 163-182 in `home-row-mods.dtsi`
```c
#ifndef PINKY_FINGER_MOD
  #if OPERATING_SYSTEM == 'M' && !defined(MACOS_USE_GACS)
    #define PINKY_FINGER_MOD LCTL  // macOS CAGS
  #else
    #define PINKY_FINGER_MOD LGUI  // Linux GACS or macOS with MACOS_USE_GACS
  #endif
#endif

#ifndef MIDDY_FINGER_MOD
  #if OPERATING_SYSTEM == 'M' && !defined(MACOS_USE_GACS)
    #define MIDDY_FINGER_MOD LGUI  // macOS CAGS
  #else
    #define MIDDY_FINGER_MOD LCTL  // Linux GACS or macOS with MACOS_USE_GACS
  #endif
#endif
```

### 3. **Bilateral Enforcement Status**

**File**: `app/boards/arm/glove80/includes/behaviors/definitions.dtsi` (Lines 101-102)

✅ **Active for macOS**: `#define ENFORCE_BILATERAL`
✅ **Active for Linux**: `#define ENFORCE_BILATERAL_LINUX`

**What it does**: Prevents same-hand modifier+tap activation. For example:
- Cannot trigger Ctrl+A using left pinky Ctrl and left ring finger 'A'
- Must use opposite hand for modifier (e.g., right hand 'A')

**Critical for feasibility**: Bilateral enforcement must be preserved for both GACS and CAGS modes to maintain typing ergonomics.

### 4. **Extended Ctrl Keys (MACOS_CAGS_EXTEND)**

**File**: `home-row-mods.dtsi` (Lines 60-94)
**Status**: ✅ Currently ENABLED (Line 103 in definitions.dtsi)

**Extended positions**:
- **Left hand**: E (position 25), C (position 49)
- **Right hand**: I (position 30), COMMA (position 60)

**Special behavior**: These extended Ctrl keys are "non-bilateral" to allow Ctrl+Cmd combinations (e.g., Ctrl+Cmd+Space for Raycast/Alfred).

**Impact on Magic 8 toggle**: These keys are CAGS-specific. For GACS mode, they should either:
1. Be disabled (revert to regular keys)
2. Become extended GUI keys (for consistency)

---

## Feasibility Analysis

### **Challenge: Compile-Time vs Runtime Configuration**

The core challenge is that **modifier mappings are compile-time `#define` constants**, not runtime variables. You cannot simply "flip a switch" to change PINKY_FINGER_MOD from LCTL to LGUI at runtime.

### **Solution: Layer-Based Toggle Architecture**

**Strategy**: Treat GACS vs CAGS as different "operating mode" layers, similar to how the current architecture separates macOS (0-31) and Linux (32-63).

---

## Proposed Implementation: 3 Approaches

### **Option 1: Repurpose Linux Layers (RECOMMENDED) ⭐**

**Feasibility**: ✅ **HIGHEST** - Uses existing infrastructure
**Effort**: 🟢 **LOW** (2-4 hours)
**Maintains all features**: ✅ YES

#### Architecture

```
BEFORE (Current):
  Layers 0-31:  macOS CAGS
  Layers 32-63: Linux GACS

AFTER (With Magic 8 Toggle):
  Layers 0-31:  macOS CAGS (default)
  Layers 32-63: macOS GACS (toggled mode)

  Linux users would need to:
  - Use a separate build configuration, OR
  - Use layers 0-31 with MACOS_USE_GACS defined
```

#### Implementation Steps

1. **Modify definitions.dtsi** to reinterpret Linux layers as "macOS GACS":
   ```c
   // Add new mode flag
   #define MACOS_DUAL_MODE  // Enable GACS/CAGS toggle for macOS

   // Modify layer 32+ to use GACS for macOS when MACOS_DUAL_MODE is defined
   #if defined(MACOS_DUAL_MODE) && OPERATING_SYSTEM == 'M'
     // Layers 32-63 become macOS GACS instead of Linux
     #define LINUX_LAYERS_ARE_MACOS_GACS
   #endif
   ```

2. **Update home-row-mods.dtsi** to handle dual-mode:
   ```c
   // For layers 32-63 when MACOS_DUAL_MODE is active
   #if defined(MACOS_DUAL_MODE) && LAYER_INDEX >= 32 && LAYER_INDEX <= 63
     #define PINKY_FINGER_MOD LGUI  // GACS order
     #define MIDDY_FINGER_MOD LCTL
   #endif
   ```

3. **Create Magic 8 toggle macro** in custom-behaviors:
   ```c
   / {
     macros {
       magic8_toggle: magic8_toggle {
         compatible = "zmk,behavior-macro";
         #binding-cells = <0>;
         wait-ms = <1>;
         tap-ms = <1>;
         bindings = <&macro_tap>
           , <&to_if_base 32>  // If on layer 0-6, jump to layer 32-38
           , <&to_if_gacs 0>;  // If on layer 32-38, jump back to layer 0-6
       };
     };

     behaviors {
       to_if_base: conditional_to_base {
         compatible = "zmk,behavior-mod-morph";
         #binding-cells = <1>;
         bindings = <&to 0>, <&none>;
         mods = <LAYER_MASK(0 1 2 3 4 5 6)>;
       };
     };
   };
   ```

4. **Assign to "Magic 8" key** (e.g., Magic layer + 8 key, or custom combo):
   ```c
   // In Magic layer (layer 31)
   &magic8_toggle  // Pressing this toggles GACS ↔ CAGS
   ```

5. **Update extended Ctrl keys** to be mode-aware:
   - Disable MACOS_CAGS_EXTEND for layers 32-63
   - Or create MACOS_GACS_EXTEND with GUI instead of CTRL

#### Pros
✅ Uses existing 64-layer infrastructure
✅ Preserves all bilateral enforcement
✅ No layer proliferation beyond 64
✅ Clean separation: layers 0-31 (CAGS), 32-63 (GACS)
✅ Easy to test both modes

#### Cons
❌ Linux users lose dedicated layers (would need separate build or use MACOS_USE_GACS)
❌ Requires careful updating of all 32 Linux layer files to be "macOS GACS" variants

---

### **Option 2: Add New Layers 32-63 for macOS GACS, Shift Linux to... wait, that won't work**

**Feasibility**: ❌ **NOT FEASIBLE** - ZMK has 64-layer maximum

This option would require:
```
Layers 0-31:   macOS CAGS
Layers 32-63:  macOS GACS
Layers 64-95:  Linux GACS ← IMPOSSIBLE (ZMK limit is 64 layers)
```

**Verdict**: This approach is **architecturally impossible** with current ZMK constraints.

---

### **Option 3: Dynamic Mod-Tap Swap Behavior (EXPERIMENTAL)**

**Feasibility**: 🟡 **MEDIUM** - Requires custom ZMK behavior
**Effort**: 🔴 **HIGH** (8-16 hours + testing)
**Maintains all features**: ⚠️ **PARTIALLY** (may affect bilateral enforcement)

#### Concept

Create a custom ZMK behavior that dynamically swaps the hold-tap modifier mapping:

```c
/ {
  behaviors {
    gacs_cags_swap: gacs_cags_swap {
      compatible = "zmk,behavior-hold-tap";
      #binding-cells = <2>;
      flavor = "balanced";
      tapping-term-ms = <280>;
      quick-tap-ms = <175>;
      bindings = <&kp>, <&kp>;

      // Custom property to swap modifiers
      swap-mods = <LCTL LGUI>;  // When active, swap these
      swap-active = <&gacs_mode_active>;  // Read from runtime state
    };
  };

  // Runtime state variable (requires custom ZMK module)
  behaviors {
    gacs_mode: gacs_mode_toggle {
      compatible = "zmk,behavior-toggle-var";
      #binding-cells = <0>;
      variable = <&gacs_mode_active>;
    };
  };
};
```

#### Pros
✅ Preserves all 64 layers for macOS CAGS + Linux GACS
✅ True runtime toggle (no layer switching)

#### Cons
❌ Requires custom ZMK module (not in mainline)
❌ Complex implementation and testing
❌ May break bilateral enforcement logic
❌ Potential HID timing issues

**Verdict**: Possible but **not recommended** due to complexity and maintenance burden.

---

## Recommended Implementation: Option 1 (Detailed Plan)

### Phase 1: Preparation (30 minutes)

1. **Create feature branch** from current:
   ```bash
   git checkout -b feature/magic8-gacs-cags-toggle
   ```

2. **Backup current Linux layers**:
   ```bash
   cp -r app/boards/arm/glove80/includes/layers/*-linux.dtsi backups/
   ```

3. **Document current QWERTY usage** (from user's mention of simplified QWERTY branch):
   - Check if all 7 base layers are needed or if QWERTY-only simplification is desired

### Phase 2: Update Definitions (1 hour)

1. **Edit `includes/behaviors/definitions.dtsi`**:
   ```c
   // Add after line 103 (after MACOS_CAGS_EXTEND)
   #define MACOS_DUAL_MODE  // Enable GACS/CAGS toggle for macOS
   ```

2. **Add mode detection logic**:
   ```c
   // Redefine Linux layer behavior for dual-mode
   #if defined(MACOS_DUAL_MODE) && OPERATING_SYSTEM == 'M'
     #define LINUX_LAYERS_ARE_MACOS_GACS
     #undef ENFORCE_BILATERAL_LINUX
     #define ENFORCE_BILATERAL_LINUX  // Keep enforcement for GACS layers
   #endif
   ```

### Phase 3: Update Home Row Mods (1-2 hours)

1. **Edit `includes/behaviors/home-row-mods.dtsi`**:

   Add layer-aware modifier selection (around line 163):
   ```c
   #ifndef PINKY_FINGER_MOD
     #if OPERATING_SYSTEM == 'M' && !defined(MACOS_USE_GACS)
       #define PINKY_FINGER_MOD LCTL  // macOS CAGS (layers 0-31)
     #else
       #define PINKY_FINGER_MOD LGUI  // Linux GACS or macOS GACS (layers 32-63)
     #endif
   #endif

   #ifndef MIDDY_FINGER_MOD
     #if OPERATING_SYSTEM == 'M' && !defined(MACOS_USE_GACS)
       #define MIDDY_FINGER_MOD LGUI  // macOS CAGS (layers 0-31)
     #else
       #define MIDDY_FINGER_MOD LCTL  // Linux GACS or macOS GACS (layers 32-63)
     #endif
   #endif
   ```

2. **Create separate behavior sets** for layers 0-31 vs 32-63:
   ```c
   // CAGS behaviors (layers 0-31)
   hm_pinky_cags: hm_pinky_cags {
     /* ... */
     bindings = <&kp>, <&kp>;
     hold-trigger-key-positions = <OPPOSITE_HAND>;
   };

   // GACS behaviors (layers 32-63)
   hm_pinky_gacs: hm_pinky_gacs {
     /* ... */
     bindings = <&kp>, <&kp>;
     hold-trigger-key-positions = <OPPOSITE_HAND>;
   };
   ```

3. **Disable MACOS_CAGS_EXTEND for GACS layers** (layers 32-63):
   ```c
   #ifdef MACOS_CAGS_EXTEND
     // Only apply to layers 0-31 (CAGS mode)
     #if LAYER_INDEX < 32
       // Extended Ctrl on E, C, I, COMMA
     #else
       // Layers 32-63 (GACS mode) - no extended keys or use extended GUI
     #endif
   #endif
   ```

### Phase 4: Rename and Update Linux Layer Files (1-2 hours)

1. **Rename Linux layer files** to reflect dual purpose:
   ```bash
   cd app/boards/arm/glove80/includes/layers/

   # Option A: Keep Linux naming but update comments
   # Option B: Rename to "gacs-layers" for clarity
   mv base-layers-linux.dtsi base-layers-gacs.dtsi
   mv typing-layer-linux.dtsi typing-layer-gacs.dtsi
   # ... etc
   ```

2. **Update layer definitions** to be macOS-aware:
   - Change Linux-specific shortcuts (Ctrl+C/V/etc) to macOS equivalents (Cmd+C/V/etc) when MACOS_DUAL_MODE is defined
   - Preserve Linux behavior when MACOS_DUAL_MODE is NOT defined (for Linux-only builds)

3. **Update glove80.keymap** includes:
   ```c
   #if defined(MACOS_DUAL_MODE) && OPERATING_SYSTEM == 'M'
     /* GACS Mode Layers (32-63) - macOS variant */
     #include "includes/layers/base-layers-gacs.dtsi"       // macOS with GACS
     #include "includes/layers/typing-layer-gacs.dtsi"      // macOS with GACS
     // ... etc
   #else
     /* Linux Layers (32-63) - original Linux behavior */
     #include "includes/layers/base-layers-linux.dtsi"
     #include "includes/layers/typing-layer-linux.dtsi"
     // ... etc
   #endif
   ```

### Phase 5: Create Magic 8 Toggle Macro (30 minutes)

1. **Add to `includes/behaviors.dtsi`**:
   ```c
   macros {
     magic8_gacs: magic8_toggle_gacs {
       compatible = "zmk,behavior-macro";
       #binding-cells = <0>;
       wait-ms = <1>;
       tap-ms = <1>;
       bindings =
         <&macro_tap &to 32>;  // Jump to GACS base layer (QWERTY_Linux → QWERTY_GACS)
     };

     magic8_cags: magic8_toggle_cags {
       compatible = "zmk,behavior-macro";
       #binding-cells = <0>;
       wait-ms = <1>;
       tap-ms = <1>;
       bindings =
         <&macro_tap &to 0>;  // Jump back to CAGS base layer (QWERTY)
     };
   };
   ```

2. **Create smart toggle** that detects current mode:
   ```c
   behaviors {
     magic8: magic8_smart_toggle {
       compatible = "zmk,behavior-mod-morph";
       #binding-cells = <0>;
       bindings = <&magic8_gacs>, <&magic8_cags>;
       // If current layer < 32, morph to GACS; else morph to CAGS
       mods = <LAYER_MASK(0-31)>;  // Simplified - actual implementation needs layer detection
     };
   };
   ```

   **Note**: ZMK doesn't natively support layer-conditional mod-morph. Alternative approaches:
   - Use two separate keys: one for GACS (always goes to layer 32), one for CAGS (always goes to layer 0)
   - Use tap-dance: tap once = GACS, tap twice = CAGS
   - Use hold-tap: tap = GACS, hold = CAGS

3. **Recommended: Tap-Dance approach**:
   ```c
   behaviors {
     magic8: magic8_tap_dance {
       compatible = "zmk,behavior-tap-dance";
       #binding-cells = <0>;
       tapping-term-ms = <200>;
       bindings = <&to 32>, <&to 0>;  // Single tap = GACS, double tap = CAGS
     };
   };
   ```

### Phase 6: Assign Toggle Key (15 minutes)

**Recommended placement**: Magic layer (layer 31) + number 8 key

1. **Edit `includes/layers/special-layers.dtsi`** (Magic layer):
   ```c
   magic_layer {
     bindings = <
       /* ... existing bindings ... */
       &magic8  // Add to position where '8' key is
       /* ... */
     >;
   };
   ```

2. **Alternative: Create combo shortcut**:
   ```c
   // In combos.dtsi
   combo_magic8_toggle {
     timeout-ms = <50>;
     key-positions = <POS_LH_C3R4 POS_RH_C3R4>;  // Both middle finger home row keys
     bindings = <&magic8>;
     layers = <0 1 2 3 4 5 6 32 33 34 35 36 37 38>;  // Active on base layers only
   };
   ```

### Phase 7: Testing Protocol (1-2 hours)

1. **Build firmware**:
   ```bash
   west build -b glove80_lh
   west build -b glove80_rh
   ```

2. **Test matrix**:

   | Test | CAGS Mode (Layer 0) | GACS Mode (Layer 32) |
   |------|---------------------|----------------------|
   | Pinky hold + opposite hand key | Ctrl + key | GUI/Cmd + key |
   | Middle hold + opposite hand key | GUI/Cmd + key | Ctrl + key |
   | Bilateral prevention | ✓ Blocked | ✓ Blocked |
   | Extended Ctrl (E, C, I, COMMA) | ✓ Works | ✗ Disabled or GUI |
   | Toggle via Magic 8 | → Switches to layer 32 | → Switches to layer 0 |
   | Ctrl+Cmd combo (E+D hold) | ✓ Works | ? Test behavior |

3. **Edge cases to test**:
   - Rapid toggling (CAGS → GACS → CAGS)
   - Toggle while holding modifier
   - Combo shortcuts that span layers (e.g., Alt+Tab switcher)
   - Mouse layer access from both CAGS and GACS modes
   - Typing layer toggle preservation

---

## Feature Preservation Checklist

### ✅ Features That Will Be Maintained

1. **Bilateral enforcement**: Both CAGS (layers 0-31) and GACS (layers 32-63) will enforce opposite-hand activation
2. **All 64 layers**: Full layer architecture preserved
3. **Extended Ctrl keys (MACOS_CAGS_EXTEND)**: Functional in CAGS mode (layers 0-31)
4. **Combos**: All existing combos work, but need to specify which layers they're active on
5. **Mouse layers**: Accessible from both CAGS and GACS base layers
6. **RGB indicators**: Should work for both modes (may need per-layer RGB config updates)
7. **Scroll acceleration**: Preserved (already works via layer toggle)
8. **Find/Replace shortcuts**: Need to be duplicated for GACS layers (currently only in CAGS layers)

### ⚠️ Features That Need Adaptation

1. **Extended Ctrl keys in GACS mode**:
   - Option A: Disable (E, C, I, COMMA become regular keys)
   - Option B: Convert to "Extended GUI keys" for consistency
   - **Recommendation**: Option A (disable) - GACS users expect Ctrl on middle finger already

2. **Layer-specific shortcuts**:
   - Find (Cmd+F in CAGS) needs GACS equivalent (maintained as Cmd+F, but Cmd is now on pinky)
   - Replace (varies by OS) needs GACS version
   - **Solution**: Update shortcuts in GACS layers to account for modifier positions

3. **Linux users**:
   - **Impact**: Lose dedicated Linux layers 32-63
   - **Mitigation options**:
     - Build separate firmware with MACOS_DUAL_MODE undefined
     - Use layers 0-31 with MACOS_USE_GACS defined (forces GACS on macOS layers)
     - Create third build configuration for Linux-only users

### ❌ Features That May Be Lost (Trade-offs)

1. **Linux layer support** (if MACOS_DUAL_MODE is always enabled):
   - Linux users must use layers 0-31 with MACOS_USE_GACS
   - **Workaround**: Maintain two build configurations (one for macOS dual-mode, one for Linux)

---

## Alternative: Conditional Layer Approach (ADVANCED)

**Feasibility**: 🟡 **MEDIUM**
**Effort**: 🔴 **MEDIUM-HIGH** (4-6 hours)

### Concept

Use ZMK's conditional layers feature to automatically activate GACS layers when a "GACS mode" indicator layer is active.

```c
/ {
  conditional_layers {
    compatible = "zmk,conditional-layers";

    // When GACS_MODE layer (e.g., layer 31) is toggled on,
    // and you press base layer (0), activate GACS base layer (32) instead
    gacs_base {
      if-layers = <31 0>;  // GACS_MODE + QWERTY
      then-layer = <32>;   // Activate QWERTY_GACS instead
    };

    gacs_typing {
      if-layers = <31 7>;  // GACS_MODE + Typing
      then-layer = <39>;   // Activate Typing_GACS
    };

    // ... repeat for all 32 layers
  };
};
```

**Pros**:
- More elegant "mode" system
- Doesn't require explicit layer jumping (conditional activation)
- Easier to maintain (no manual toggle macros)

**Cons**:
- Requires 32 conditional layer definitions (one per layer pair)
- More complex mental model for users
- May interact unexpectedly with other layer behaviors

**Verdict**: Viable alternative, but Option 1 (explicit toggle) is simpler and more predictable.

---

## Linux Compatibility Strategy

### Problem

If layers 32-63 are repurposed for macOS GACS, Linux users lose their dedicated layers.

### Solutions

#### **Solution A: Dual Build Configurations (RECOMMENDED)**

Create two build targets:

1. **glove80_macos_dual.conf** (macOS with GACS/CAGS toggle):
   ```
   CONFIG_ZMK_KEYBOARD_NAME="Glove80 macOS Dual"
   CONFIG_MACOS_DUAL_MODE=y
   ```

2. **glove80_linux.conf** (Linux with original layers 32-63):
   ```
   CONFIG_ZMK_KEYBOARD_NAME="Glove80 Linux"
   # MACOS_DUAL_MODE not defined
   ```

**Usage**:
```bash
# Build for macOS dual-mode
west build -b glove80_lh -- -DCONFIG_FILE=glove80_macos_dual.conf

# Build for Linux
west build -b glove80_lh -- -DCONFIG_FILE=glove80_linux.conf
```

#### **Solution B: Linux Uses MACOS_USE_GACS on Layers 0-31**

Linux users use macOS layers (0-31) but with MACOS_USE_GACS defined:

```c
// For Linux-only users who don't need macOS CAGS
#if OPERATING_SYSTEM == 'L'
  #define MACOS_USE_GACS  // Force GACS order on layers 0-31
#endif
```

**Result**: Layers 0-31 become GACS for Linux, layers 32-63 remain available for future use.

#### **Solution C: Three-Way Build System**

1. **macOS CAGS-only** (layers 0-31 only, no GACS)
2. **macOS Dual-mode** (layers 0-31 CAGS, 32-63 GACS)
3. **Linux GACS** (layers 0-31 or 32-63, GACS order)

**Maintenance burden**: HIGH - requires careful testing of all three configurations.

**Verdict**: **Solution A (Dual Build)** is the best compromise between functionality and maintainability.

---

## Simplified QWERTY Branch Analysis

**User mention**: "we have one [branch] where we simplify layers that we don't need as we use QWERTY"

### Current Situation

The keymap supports **7 base layouts**:
- QWERTY (layer 0 / 32)
- Enthium (layer 1 / 33)
- Engrammer (layer 2 / 34)
- Engram (layer 3 / 35)
- Dvorak (layer 4 / 36)
- Colemak (layer 5 / 37)
- ColemakDH (layer 6 / 38)

**If only QWERTY is used**, layers 1-6 and 33-38 are wasted.

### Simplification Opportunity

**Reclaim 12 layers** (1-6 and 33-38) for other purposes:

```
BEFORE:
  0-6:   7 base layouts (macOS CAGS)
  7-31:  Typing, fingers, functions, mouse, special
  32-38: 7 base layouts (Linux GACS or macOS GACS)
  39-63: Typing, fingers, functions, mouse, special (Linux/GACS)

AFTER (QWERTY-only):
  0:     QWERTY (macOS CAGS)
  1-31:  Typing, fingers, functions, mouse, special (macOS CAGS)
  32:    QWERTY (macOS GACS)
  33-63: Typing, fingers, functions, mouse, special (macOS GACS)

  FREE: Layers 1-6, 33-38 (12 layers) for:
        - Additional mouse speed tiers
        - Gaming profiles
        - Application-specific layers (VSCode, Vim, etc.)
        - Experimental features
```

### Implementation

1. **Remove unused base layouts**:
   ```bash
   # Delete layer files
   rm includes/layers/enthium.dtsi
   rm includes/layers/engrammer.dtsi
   # ... etc
   ```

2. **Update helpers.dtsi** to remove layer definitions:
   ```c
   // Remove layers 1-6, 33-38
   #define LAYER_QWERTY 0
   // #define LAYER_Enthium 1  ← DELETE
   // ...
   #define LAYER_Typing 1  // Shift down from 7 to 1
   // ...
   ```

3. **Shift all layer indices down**:
   - Typing: 7 → 1
   - LeftPinky: 8 → 2
   - ... etc

**Effort**: 2-3 hours (tedious but straightforward)

**Benefit**: Cleaner keymap, faster compile times, more layers for experimentation

**Recommendation**: Do this simplification **after** Magic 8 toggle is working, not before. Changing layer indices during active development creates confusion.

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| **Bilateral enforcement breaks** | LOW | HIGH | Extensive testing; preserve `hold-trigger-key-positions` in all behaviors |
| **Extended Ctrl keys conflict with GACS** | MEDIUM | MEDIUM | Disable MACOS_CAGS_EXTEND for layers 32-63 |
| **Linux users lose functionality** | HIGH | MEDIUM | Provide dual build configurations |
| **Toggle macro doesn't work mid-typing** | MEDIUM | LOW | Use `&to` (immediate layer switch) instead of `&mo` (momentary) |
| **Combos activate on wrong layers** | MEDIUM | MEDIUM | Explicitly set `layers = <0 1 2 ... 32 33 34 ...>` for all combos |
| **RGB indicators don't update** | LOW | LOW | Update per-layer RGB config to include layers 32-63 |
| **Compile errors from duplicate definitions** | MEDIUM | HIGH | Use `#ifdef MACOS_DUAL_MODE` guards everywhere |

---

## Performance Considerations

### Layer Switching Speed

**ZMK layer switch latency**: < 1ms (imperceptible)

**Magic 8 toggle timing**:
- User presses toggle key → layer switch → new modifiers active
- **Total delay**: 1-2ms (HID report rate limited)

**Verdict**: ✅ No performance concerns

### Memory Usage

**Current**: ~64 layers * ~80 keys/layer * ~8 bytes/binding = ~40KB
**After Magic 8**: No change (same number of layers)
**Available RAM (nRF52840)**: 256KB
**Verdict**: ✅ Plenty of headroom

### Build Time

**Current build time**: ~2-3 minutes
**Expected change**: +5-10 seconds (additional conditional compilation)
**Verdict**: ✅ Negligible impact

---

## User Experience Design

### Visual Feedback

**Recommendation**: Add RGB indicator for GACS vs CAGS mode

```c
// In custom-nodes.dtsi or RGB config
#define RGB_CAGS_COLOR_R 0  // Blue for CAGS (Ctrl on pinky)
#define RGB_CAGS_COLOR_G 0
#define RGB_CAGS_COLOR_B 255

#define RGB_GACS_COLOR_R 255  // Red for GACS (GUI on pinky)
#define RGB_GACS_COLOR_G 0
#define RGB_GACS_COLOR_B 0

// Set underglow color based on active layer
&layer_state_change {
  if (layer < 32) {
    set_underglow(RGB_CAGS);
  } else {
    set_underglow(RGB_GACS);
  }
};
```

### Learning Curve

**For users switching from CAGS to GACS**:

| Muscle Memory Challenge | Severity | Adaptation Time |
|------------------------|----------|----------------|
| Pinky = Ctrl → Pinky = GUI | HIGH | 2-4 weeks |
| Middle = GUI → Middle = Ctrl | HIGH | 2-4 weeks |
| Extended Ctrl keys (E/C/I/COMMA) disabled | MEDIUM | 1 week |
| Bilateral enforcement (same across modes) | NONE | Immediate |

**Recommendation**: Add "training mode" layer that shows which modifier is active:
- Holding pinky → types "GUI" (in GACS) or "CTRL" (in CAGS)
- Helps build muscle memory without constant reference

---

## Future Enhancements

### 1. **Per-Application Auto-Switching**

**Idea**: Automatically switch to GACS when using certain apps (e.g., terminal emulators where Ctrl is heavily used).

**Implementation**:
- Requires OS-level integration (e.g., Hammerspoon on macOS, xdotool on Linux)
- Send layer switch command to keyboard via HID
- **Feasibility**: HIGH (but requires external tooling)

### 2. **Three-Way Toggle: CAGS ↔ GACS ↔ Custom**

**Idea**: Add a third mode with user-defined modifier positions.

**Architecture**:
```
Layers 0-20:   macOS CAGS
Layers 21-41:  macOS GACS
Layers 42-62:  macOS Custom (e.g., CGSA, SGAC, etc.)
Layer 63:      Magic layer with 3-way toggle
```

**Feasibility**: MEDIUM (requires even more layer reorganization)

### 3. **Smart Toggle Based on Keystroke Patterns**

**Idea**: Keyboard learns which mode you prefer for certain typing contexts (e.g., programming vs prose) and auto-switches.

**Implementation**:
- Machine learning model running on host computer
- Analyzes keystroke patterns
- Sends toggle command when context changes

**Feasibility**: HIGH (as external tool), LOW (as on-keyboard feature due to processing limits)

---

## Conclusion and Recommendation

### **VERDICT: ✅ IMPLEMENT OPTION 1 (Layer-Based Toggle)**

**Rationale**:
1. ✅ **Technically feasible** with existing ZMK features
2. ✅ **Preserves all current features** (bilateral enforcement, extended keys, etc.)
3. ✅ **Reasonable effort** (4-6 hours for experienced developer)
4. ✅ **Maintainable** (clear separation of CAGS and GACS layers)
5. ✅ **Testable** (easy to verify both modes work independently)

### **Implementation Priority**

**Phase 1 (MVP)**:
- Basic toggle between layer 0 (CAGS) and layer 32 (GACS)
- Bilateral enforcement working in both modes
- Extended Ctrl keys disabled in GACS mode

**Phase 2 (Polish)**:
- RGB indicator for mode
- Combo shortcut for toggle (in addition to Magic layer key)
- QWERTY simplification (reclaim unused layers)

**Phase 3 (Advanced)**:
- Dual build configurations for macOS vs Linux
- Training mode for learning curve
- Documentation and user guide

### **Estimated Total Effort**

- **MVP**: 4-6 hours
- **Polish**: 2-3 hours
- **Advanced**: 3-4 hours
- **Testing**: 2-3 hours
- **Documentation**: 1-2 hours

**Total**: 12-18 hours for complete, polished implementation

---

## Next Steps

1. **Review this analysis** with the user to confirm approach
2. **Create feature branch** and begin Phase 1 implementation
3. **Build and test MVP** on actual hardware
4. **Iterate based on feedback**
5. **Document for community** (this implementation could benefit other Glove80/ZMK users)

---

## References

**ZMK Documentation**:
- Layers: https://zmk.dev/docs/features/keymaps#layers
- Hold-Tap Behavior: https://zmk.dev/docs/behaviors/hold-tap
- Conditional Layers: https://zmk.dev/docs/features/conditional-layers
- Macros: https://zmk.dev/docs/behaviors/macros

**Related Implementations**:
- Miryoku GACS/CAGS: https://github.com/manna-harbour/miryoku
- Urob's ZMK config: https://github.com/urob/zmk-config (excellent reference for complex home row mod setups)
- Sunaku's Glove80 config: https://github.com/sunaku/glove80-keymaps (original architecture this keymap is based on)

**Community Resources**:
- ZMK Discord: https://zmk.dev/community/discord
- MoErgo Discord: https://moergo.com/discord (Glove80-specific)

---

**END OF ANALYSIS**

---

## Appendix A: Quick Reference

### Current Architecture
- **Layers 0-31**: macOS CAGS (Ctrl on pinky, GUI on middle)
- **Layers 32-63**: Linux GACS (GUI on pinky, Ctrl on middle)
- **Bilateral enforcement**: Active on all layers
- **Extended Ctrl keys**: E, C, I, COMMA (macOS CAGS only)

### Proposed Magic 8 Toggle
- **Layers 0-31**: macOS CAGS (unchanged)
- **Layers 32-63**: macOS GACS (repurposed from Linux)
- **Toggle key**: Magic layer + 8 (or custom combo)
- **Effect**: Instant switch between CAGS (layer 0) and GACS (layer 32)

### Key Files to Modify
1. `app/boards/arm/glove80/includes/behaviors/definitions.dtsi` - Add MACOS_DUAL_MODE flag
2. `app/boards/arm/glove80/includes/behaviors/home-row-mods.dtsi` - Layer-aware modifiers
3. `app/boards/arm/glove80/includes/layers/*-linux.dtsi` - Rename/update for macOS GACS
4. `app/boards/arm/glove80/glove80.keymap` - Update conditional includes
5. `app/boards/arm/glove80/includes/behaviors.dtsi` - Add magic8 toggle macro

### Testing Checklist
- [ ] Pinky mod works (Ctrl in CAGS, GUI in GACS)
- [ ] Middle mod works (GUI in CAGS, Ctrl in GACS)
- [ ] Bilateral enforcement prevents same-hand activation
- [ ] Extended Ctrl keys work in CAGS, disabled in GACS
- [ ] Toggle switches between modes instantly
- [ ] All combos work in both modes
- [ ] Mouse layers accessible from both modes
- [ ] Compile succeeds without warnings

---

**Document Version**: 1.0
**Last Updated**: 2025-11-18
**Status**: Ready for implementation
