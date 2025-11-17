# Implementation Plan: Conditional Layers + Caps Word
**Status:** Ready to implement  
**Estimated Time:** 3-4 hours total  
**Risk Level:** Low (native ZMK features, no breaking changes)

---

## Overview

This plan implements the final 5% needed to achieve 100% excellence:
1. **Caps Word Enhancement** (5 minutes) - Quick win
2. **Conditional Layers** (3-4 hours) - Game changer

Both are native ZMK features with no external dependencies.

---

## Phase 1: Caps Word Enhancement
**Time:** 5 minutes  
**Difficulty:** Trivial

### Step 1: Add Configuration

**File:** `app/boards/arm/glove80/glove80.keymap`  
**Location:** Root level (after keymap definition)

**Code to Add:**
```dts
// Caps Word configuration - allow typing CONST_NAMES
&caps_word {
  continue-list = <
    UNDERSCORE      // Continue on underscore (for CONST_NAMES)
    MINUS           // Continue on minus (for kebab-case)
    BACKSPACE       // Allow corrections without deactivating
    DELETE          // Allow corrections without deactivating
    N1 N2 N3 N4 N5 N6 N7 N8 N9 N0  // Allow numbers in names
  >;
};
```

**Where to Place:**
- After the main keymap closing brace
- Before the final `};` that closes the root

### Step 2: Test
1. Activate caps word (via combo or key binding)
2. Type: `SOME_CONSTANT_NAME_123`
3. Verify underscore and numbers don't deactivate caps word
4. Type backspace to correct - should stay active

**Expected Behavior:**
- Before: `SOME` then underscore deactivates → `_constant_name_123`
- After: `SOME_CONSTANT_NAME_123` - stays active throughout

---

## Phase 2: Conditional Layers
**Time:** 3-4 hours  
**Difficulty:** Moderate

### Overview
Create 4 intelligent layer combinations that activate automatically when base layers are combined.

### Step 1: Define Layer Numbers

**File:** `app/boards/arm/glove80/includes/helpers.dtsi`  
**Action:** Reserve layer numbers for new hybrid layers

**Current Layers (macOS):**
- 0-6: Base layouts
- 7: Typing
- 8-15: Finger layers
- 16-22: Function layers (Cursor, Number, Function, Emoji, World, Symbol, System)
- 23-27: Mouse layers
- 28-31: Special (Gaming, Factory, Lower, Magic)

**Current Layers (Linux):**
- 32-38: Base layouts
- 39: Typing
- 40-47: Finger layers
- 48-54: Function layers
- 55-59: Mouse layers
- 60-63: Special

**Available Slots:** None! All 64 layers used.

**Solution:** Repurpose unused special layers
- LAYER_Factory (29, 61) - rarely used, can remove
- LAYER_Lower (30, 62) - placeholder, can remove
- This frees up 4 slots for macOS and 2 for Linux

**Add to helpers.dtsi (after line 68):**
```dts
/* Conditional/Hybrid Layers - macOS */
#define LAYER_MousePrecision 29     // Mouse + Cursor
#define LAYER_Calculator 30         // Number + Symbol
#define LAYER_DevTools 28           // Function + Symbol (reuse Gaming slot)

/* Conditional/Hybrid Layers - Linux */
#define LAYER_Calculator_Linux 62   // Number + Symbol
```

### Step 2: Create Conditional Layer Configuration

**File:** `app/boards/arm/glove80/glove80.keymap`  
**Location:** Root level (before keymap definition)

**Code to Add:**
```dts
/ {
  conditional_layers {
    compatible = "zmk,conditional-layers";
    
    // MACOS CONDITIONAL LAYERS
    
    // Mouse + Cursor → Precision navigation
    // Use case: Pixel-perfect positioning with cursor keys
    precision_nav {
      if-layers = <LAYER_Mouse LAYER_Cursor>;
      then-layer = <LAYER_MousePrecision>;
    };
    
    // Number + Symbol → Calculator mode
    // Use case: Quick math operations
    calculator {
      if-layers = <LAYER_Number LAYER_Symbol>;
      then-layer = <LAYER_Calculator>;
    };
    
    // Function + Symbol → Dev tools
    // Use case: IDE shortcuts, debugging
    dev_tools {
      if-layers = <LAYER_Function LAYER_Symbol>;
      then-layer = <LAYER_DevTools>;
    };
    
    // LINUX CONDITIONAL LAYERS
    
    // Number + Symbol → Calculator mode (Linux)
    calculator_linux {
      if-layers = <LAYER_Number_Linux LAYER_Symbol_Linux>;
      then-layer = <LAYER_Calculator_Linux>;
    };
  };
};
```

**Where to Place:**
- Before the keymap block
- After the caps_word configuration

### Step 3: Create Hybrid Layer Definitions

Create new file: `app/boards/arm/glove80/includes/layers/conditional-layers.dtsi`

**Content:**
```dts
// Conditional/Hybrid Layers - Activated automatically by layer combinations

layer_MousePrecision {
  // Mouse + Cursor = Precision navigation mode
  // Purpose: Pixel-perfect positioning with cursor keys + fine mouse control
  bindings = <
    // Row 1-4: Same as Mouse layer (fine control)
    // Right side: Arrow keys for pixel adjustment
    &trans &trans &trans &trans &trans                                                                        &kp UP    &trans &trans &trans &trans
    &trans &trans &trans &trans &trans &trans                                                        &trans &kp LEFT &kp DOWN &kp RIGHT &trans &trans
    &trans &trans &trans &trans &trans &trans                                                        &trans   &trans   &trans   &trans &trans &trans
    &trans &trans &trans &trans &trans &trans                                                        &trans   &trans   &trans   &trans &trans &trans
    &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans   &trans   &trans   &trans &trans &trans
    &trans &trans &trans &trans &trans        &trans &trans &trans &trans &trans &trans          &trans   &trans   &trans &trans &trans
  >;
};

layer_Calculator {
  // Number + Symbol = Calculator mode
  // Purpose: Quick math operations without layer switching
  bindings = <
    // Row 1: Clear, operators
    &kp ESC  &trans &trans &trans &trans                                                                        &kp PLUS  &kp MINUS &kp STAR &kp FSLH &kp EQUAL
    &trans &trans &trans &trans &trans &trans                                                        &trans &kp N7 &kp N8 &kp N9 &kp LPAR &kp RPAR
    &trans &trans &trans &trans &trans &trans                                                        &trans &kp N4 &kp N5 &kp N6 &kp DOT  &kp PRCNT
    &trans &trans &trans &trans &trans &trans                                                        &trans &kp N1 &kp N2 &kp N3 &kp COMMA &kp RET
    &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &kp N0 &kp N0 &kp DOT &trans &trans
    &trans &trans &trans &trans &trans        &trans &trans &trans &trans &trans &trans          &trans &trans &trans &trans &trans
  >;
};

layer_DevTools {
  // Function + Symbol = Developer tools
  // Purpose: IDE shortcuts, debugging, refactoring
  bindings = <
    // Common IDE shortcuts
    &kp F5    &kp F6    &kp F7    &kp F8    &trans                                                                        &kp LG(LS(F)) &kp LG(LS(R)) &trans &trans &trans  // F5-F8, Find, Replace
    &kp F9    &kp F10   &kp F11   &kp F12   &trans &trans                                                        &trans &kp LG(B)    &kp LG(D)    &trans &trans &trans  // Breakpoint, Debug
    &trans &trans &trans &trans &trans &trans                                                        &trans &kp LG(LBKT) &kp LG(RBKT) &trans &trans &trans  // Navigate back/forward
    &trans &trans &trans &trans &trans &trans                                                        &trans &kp LG(LS(A)) &trans &trans &trans &trans  // Find action
    &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans
    &trans &trans &trans &trans &trans        &trans &trans &trans &trans &trans &trans          &trans &trans &trans &trans &trans
  >;
};

// LINUX VARIANTS

layer_Calculator_Linux {
  // Same as Calculator but for Linux layers
  bindings = <
    &kp ESC  &trans &trans &trans &trans                                                                        &kp PLUS  &kp MINUS &kp STAR &kp FSLH &kp EQUAL
    &trans &trans &trans &trans &trans &trans                                                        &trans &kp N7 &kp N8 &kp N9 &kp LPAR &kp RPAR
    &trans &trans &trans &trans &trans &trans                                                        &trans &kp N4 &kp N5 &kp N6 &kp DOT  &kp PRCNT
    &trans &trans &trans &trans &trans &trans                                                        &trans &kp N1 &kp N2 &kp N3 &kp COMMA &kp RET
    &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &kp N0 &kp N0 &kp DOT &trans &trans
    &trans &trans &trans &trans &trans        &trans &trans &trans &trans &trans &trans          &trans &trans &trans &trans &trans
  >;
};
```

### Step 4: Include New Layers File

**File:** `app/boards/arm/glove80/glove80.keymap`  
**Location:** After special-layers includes

**Add:**
```dts
        /* Conditional/Hybrid Layers */
        #include "includes/layers/conditional-layers.dtsi"
        
        /* Linux Layers (32-63) */
```

### Step 5: Test Each Conditional Layer

**Test 1: MousePrecision**
1. Hold Mouse layer key
2. Hold Cursor layer key
3. Verify MousePrecision layer activates (arrow keys appear)
4. Use arrow keys + mouse together for precise positioning
5. Release either key - layer deactivates

**Test 2: Calculator**
1. Hold Number layer key
2. Hold Symbol layer key
3. Verify Calculator layer activates
4. Type: `123 + 456 =` - should work seamlessly
5. Release keys - back to normal

**Test 3: DevTools**
1. Hold Function layer key
2. Hold Symbol layer key
3. Verify DevTools layer activates
4. Test IDE shortcuts (F5, Cmd+Shift+F, etc.)
5. Release keys - back to normal

**Test 4: Calculator_Linux**
1. Switch to Linux layer set
2. Hold Number_Linux layer key
3. Hold Symbol_Linux layer key
4. Verify Calculator_Linux layer activates
5. Same as Test 2

---

## Phase 3: Documentation Updates

### Update spec.md

**Mark as Implemented:**
- Priority 1: Input Processors ✅
- Priority 2: Conditional Layers ✅ (after implementing)
- Priority 3: require-prior-idle-ms ✅
- Priority 9: Caps Word Enhancement ✅ (after implementing)

### Create CHANGELOG Entry

**File:** `CHANGELOG.md` or commit message

**Entry:**
```
## [Unreleased]

### Added
- Caps word enhancement with continue-list support for underscores, numbers, and corrections
- Conditional layers for intelligent context-aware layer activation:
  - MousePrecision: Mouse + Cursor layers → precision navigation
  - Calculator: Number + Symbol layers → quick math mode
  - DevTools: Function + Symbol layers → IDE shortcuts
  - Calculator_Linux: Linux number + symbol → calculator mode

### Implementation Details
- Native ZMK features, no external dependencies
- Layer combinations activate automatically
- Improves composability and KISS principles
- Total lines of code: ~150 (conditional config + 4 new layers)
```

---

## Rollback Plan

If issues arise, rollback is simple (native features, no breaking changes):

**Rollback Caps Word:**
```bash
# Remove &caps_word configuration block from glove80.keymap
git checkout HEAD -- app/boards/arm/glove80/glove80.keymap
```

**Rollback Conditional Layers:**
```bash
# Remove conditional_layers block from glove80.keymap
# Remove conditional-layers.dtsi file
rm app/boards/arm/glove80/includes/layers/conditional-layers.dtsi
# Remove include line from glove80.keymap
```

No firmware rebuild required - changes are devicetree only.

---

## Success Criteria

### Caps Word
- ✅ Can type `SOME_CONSTANT_NAME` without deactivation
- ✅ Can type `CONST_123` with numbers
- ✅ Backspace/Delete work without deactivating
- ✅ Normal space/return still deactivate

### Conditional Layers
- ✅ MousePrecision activates when Mouse + Cursor held
- ✅ Calculator activates when Number + Symbol held
- ✅ DevTools activates when Function + Symbol held
- ✅ Calculator_Linux activates for Linux layer set
- ✅ Layers deactivate cleanly when base layers released
- ✅ No conflicts with existing layer activation
- ✅ Muscle memory: discover layer combos organically

---

## Timeline

**Immediate (5 min):**
- ✅ Caps Word enhancement

**Session 1 (2 hours):**
- Define layer numbers (30 min)
- Create conditional_layers config (30 min)
- Create conditional-layers.dtsi (1 hour)

**Session 2 (1-2 hours):**
- Testing and refinement (1 hour)
- Documentation updates (30 min)
- Commit and push (30 min)

**Total: 3-4 hours**

---

## Notes

**Why These Layer Combinations?**
1. **Mouse + Cursor** - Common workflow: position mouse, fine-tune with arrow keys
2. **Number + Symbol** - Math operations naturally combine numbers and operators
3. **Function + Symbol** - IDE shortcuts often use Fn + Symbol combos
4. **Linux variants** - Maintain feature parity across OS layer sets

**Future Expansion Ideas:**
- Cursor + World → Text manipulation macros
- Emoji + Symbol → Emoji modifiers (skin tone, gender)
- Gaming + Mouse → Gaming precision mode

---

**Ready to implement? Proceed to Phase 1 (Caps Word) first for quick win, then Phase 2 (Conditional Layers).**
