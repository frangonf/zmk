# Glove80 Keymap Layer Reference Analysis

## 1. LAYER DEFINITION SUMMARY (Lines 57-88)

All 32 layers (0-31) are defined using LAYER_* constants:

```c
#define LAYER_QWERTY 0       // Main layout base
#define LAYER_Enthium 1      // Alternative layout
#define LAYER_Engrammer 2    // Alternative layout
#define LAYER_Engram 3       // Alternative layout
#define LAYER_Dvorak 4       // Alternative layout
#define LAYER_Colemak 5      // Alternative layout
#define LAYER_ColemakDH 6    // Alternative layout
#define LAYER_Typing 7       // Keyboard mode (accessibility)
#define LAYER_LeftPinky 8    // Left hand mod layer (pinky)
#define LAYER_LeftRingy 9    // Left hand mod layer (ring)
#define LAYER_LeftMiddy 10   // Left hand mod layer (middle)
#define LAYER_LeftIndex 11   // Left hand mod layer (index)
#define LAYER_RightPinky 12  // Right hand mod layer (pinky)
#define LAYER_RightRingy 13  // Right hand mod layer (ring)
#define LAYER_RightMiddy 14  // Right hand mod layer (middle)
#define LAYER_RightIndex 15  // Right hand mod layer (index)
#define LAYER_Cursor 16      // Navigation layer
#define LAYER_Number 17      // Numpad/Numbers layer
#define LAYER_Function 18    // Function keys layer
#define LAYER_Emoji 19       // Emoji/Unicode layer
#define LAYER_World 20       // International characters
#define LAYER_Symbol 21      // Symbols layer
#define LAYER_System 22      // System controls (lock, power, etc)
#define LAYER_Mouse 23       // Mouse movement layer
#define LAYER_MouseFine 24   // Fine mouse control
#define LAYER_MouseSlow 25   // Slow mouse movement
#define LAYER_MouseFast 26   // Fast mouse movement
#define LAYER_MouseWarp 27   // Mouse warp (jump to positions)
#define LAYER_Gaming 28      // Gaming mode
#define LAYER_Factory 29     // Factory layer (unused typically)
#define LAYER_Lower 30       // Lower case/shift layer (legacy, mapped to 0)
#define LAYER_Magic 31       // Magic key layer (RGB status)
```

---

## 2. LAYER REFERENCE PATTERNS

All layer references in the keymap use **LAYER_* constants** (NOT direct numbers).
This is critical for duplication.

### Pattern Types Used:

#### A. Momentary Layer (Hold to activate)
- Syntax: `&mo LAYER_*`
- Example: `&mo LAYER_Lower` - holds Lower layer
- Example: `&mo LAYER_Typing` - holds Typing layer

#### B. Toggle Layer (Press to toggle on/off)
- Syntax: `&tog LAYER_*`
- Example: `&tog LAYER_Gaming` - toggles Gaming layer
- Example: `&tog LAYER_Emoji` - toggles Emoji layer

#### C. To Layer (Go to layer, deactivate others)
- Syntax: `&to LAYER_*` or `&to 0` (direct number)
- Example: `&to 0` - go to layer 0 (base layer)
- Used in combos: `combo_sticky_base_layer_reset_*` 
- Acts on layers: 0-30 (all except LAYER_Magic)

#### D. Thumb Layer Access (Hold = activate layer, Tap = key)
- Syntax: `&thumb LAYER_* KEY`
- Examples:
  - `&thumb LAYER_Function ESC` - hold = Function layer, tap = ESC
  - `&thumb LAYER_Cursor BACKSPACE` - hold = Cursor layer, tap = BACKSPACE
  - `&thumb LAYER_Number DELETE` - hold = Number layer, tap = DELETE
  - `&thumb LAYER_Emoji BSLH` - hold = Emoji layer, tap = BACKSLASH
  - `&thumb LAYER_Mouse TAB` - hold = Mouse layer, tap = TAB
  - `&thumb LAYER_System ENTER` - hold = System layer, tap = ENTER
  - `&thumb LAYER_World PAGE_UP` - hold = World layer, tap = PAGE UP
  - `&thumb LAYER_Typing INSERT` - hold = Typing layer, tap = INSERT
  - `&thumb_engram_AT LAYER_Emoji 0` - special variant for Engram

#### E. Magic Key (Hold = activate Magic layer, Tap = RGB status)
- Syntax: `&magic LAYER_Magic 0`
- Special: Second parameter (0) is ignored
- Example: `&magic LAYER_Magic 0`

#### F. Space Bar Layer Access
- Syntax: `&space LAYER_* KEY`
- Examples:
  - `&space LAYER_Symbol SPACE` - hold = Symbol layer, tap = SPACE
  - `&space LAYER_Symbol R` - on some layouts, different key

#### G. Crumb variants (Tap = key, Hold = layer, with retro-tap)
- Syntax: `&crumb LAYER_* KEY` 
- Example: `&crumb LAYER_Typing INSERT`
- Variants: `&crumb_parang_left`, `&crumb_parang_right`

#### H. Stumb variant (Sticky key oneshot)
- Syntax: `&stumb LAYER_* KEY`
- (Not heavily used in current keymap)

#### I. Mod+Tab Chord (Advanced layer switching)
- Syntax: `&mod_tab_chord MODIFIER LAYER_*`
- Examples:
  - `&mod_tab_chord _A_TAB LAYER_Cursor` - Alt+Tab, activates Cursor layer
  - `&mod_tab_chord _G_TAB LAYER_Cursor` - Super+Tab, activates Cursor layer
  - `&mod_tab_chord LCTL LAYER_Cursor` - Ctrl+Tab, activates Cursor layer

#### J. Home Row Mod Layers (Pinky)
- Syntax: `&LeftPinky(KEY, LAYER_*)` or `&RightPinky(KEY, LAYER_*)`
- Examples:
  - `&LeftPinky (A, LAYER_QWERTY)` - A key with special pinky behavior for QWERTY
  - `&RightPinky (SEMI, LAYER_QWERTY)`
- These are macro-based, using layer index as parameter
- Macros: `left_pinky_hold` and `right_pinky_hold` press `&mo LAYER_LeftPinky` and `&mo LAYER_RightPinky`

#### K. Bilateral Pinky Macros
- Examples: `&LeftPinkyRingy`, `&LeftPinkyMiddy`, `&LeftPinkyIndex`
- Example: `&RightPinkyRingy`, `&RightPinkyMiddy`, `&RightPinkyIndex`
- These reference underlying layer mod behaviors

#### L. Toggle Combos (Combo key sequences)
- Syntax: `bindings = <&tog LAYER_*>; layers = <0 LAYER_*>;`
- Examples in lines 1765-1796:
  - `combo_gaming_layer_toggle`: C1R5+C2R6 → toggle LAYER_Gaming
  - `combo_typing_layer_toggle`: RH_C1R5+RH_C2R6 → toggle LAYER_Typing

#### M. Layer-specific Key Positions (LAY_* defines)
- Examples (lines 1013-1053):
  - `#define LAY_LH_C6R5 LAYER_Lower` - Lower layer mapping for left hand
  - `#define LAY_LH_T1 LAYER_Function` - Function layer mapping
  - `#define LAY_RH_T1 LAYER_System` - System layer mapping
  - `#define LAY_LH_C2R6 LAYER_Emoji` - Emoji layer mapping
  - `#define LAY_RH_T4 LAYER_Symbol` - Symbol layer mapping
  - `#define LAY_RH_T5 LAYER_Mouse` - Mouse layer mapping

---

## 3. SPECIAL BEHAVIORS THAT REFERENCE LAYERS

### A. `magic` Behavior (Line 781-788)
```c
magic: magic {
    compatible = "zmk,behavior-hold-tap";
    label = "MAGIC_HOLD_TAP";
    #binding-cells = <2>;
    flavor = "tap-preferred";
    tapping-term-ms = <200>;
    bindings = <&mo>, <&rgb_ug_status_macro>;
};
```
- First parameter: layer number (to be passed to &mo)
- Usage: `&magic LAYER_Magic 0`
- Takes 2 parameters, first is the layer

### B. `thumb` Behavior (Line 3995-4005)
```c
thumb: thumb_layer_access {
    compatible = "zmk,behavior-hold-tap";
    flavor = THUMB_HOLDING_TYPE;
    tapping-term-ms = <THUMB_HOLDING_TIME>;
    quick-tap-ms = <THUMB_REPEAT_DECAY>;
    #binding-cells = <2>;
    bindings = <&mo>, <&kp>;
    #ifdef THUMB_FORGIVENESS
    retro-tap;
    #endif
};
```
- First parameter: layer number
- Second parameter: key to tap
- Usage: `&thumb LAYER_Function ESC`

### C. `stumb` Behavior (Line 4006-4013)
```c
stumb: thumb_layer_access_sticky_key_oneshot {
    compatible = "zmk,behavior-hold-tap";
    #binding-cells = <2>;
    bindings = <&mo>, <&sticky_key_oneshot>;
};
```
- First parameter: layer number
- Second parameter: key (oneshot)
- Similar to thumb but uses oneshot key

### D. `crumb` Behavior (Line 4014-4022)
```c
crumb: thumb_layer_access_retro_tap {
    compatible = "zmk,behavior-hold-tap";
    #binding-cells = <2>;
    bindings = <&mo>, <&kp>;
    retro-tap; // tap on standalone hold
};
```
- First parameter: layer number
- Second parameter: key to tap
- Includes retro-tap support

### E. `crumb_parang_left` & `crumb_parang_right` (Lines 4023-4040)
- Variants of crumb with parenthesis/angle bracket morphing
- First parameter: layer number

### F. `thumb_engram_AT` & `crumb_engram_AT` (Lines 4041-4050)
- Special variants for Engram layout
- First parameter: layer number

### G. `space` Behavior (Line 4060-4070)
```c
space: thumb_layer_access_spacebar {
    compatible = "zmk,behavior-hold-tap";
    flavor = SPACE_HOLDING_TYPE;
    tapping-term-ms = <SPACE_HOLDING_TIME>;
    #binding-cells = <2>;
    bindings = <&mo>, <&kp>;
};
```
- First parameter: layer number
- Second parameter: key (usually SPACE)
- Usage: `&space LAYER_Symbol SPACE`

### H. `mod_tab_chord` Macro (Lines 4319-4335)
```c
mod_tab_chord: mod_tab_switcher_chord {
    compatible = "zmk,behavior-macro-two-param";
    #binding-cells = <2>;
    bindings
      = <&macro_param_2to1>
      , <&macro_press &mo MACRO_PLACEHOLDER>  // Second param is layer
      , <&macro_param_1to1>
      , <&macro_press &mod_tab MACRO_PLACEHOLDER>  // First param is mod
      , <&macro_pause_for_release>
      , <&macro_param_1to1>
      , <&macro_release &mod_tab MACRO_PLACEHOLDER>
      , <&macro_param_2to1>
      , <&macro_release &mo MACRO_PLACEHOLDER>
      ;
};
```
- First parameter: modifier (LCTL, _A_TAB, _G_TAB, etc)
- Second parameter: layer number (passed to &mo)
- Usage: `&mod_tab_chord LCTL LAYER_Cursor`

### I. `left_pinky_hold` & `right_pinky_hold` Macros (Lines 2429-2447, 2525-2543)
```c
left_pinky_hold: homey_left_pinky_hold {
    compatible = "zmk,behavior-macro-one-param";
    bindings
      = <&macro_param_1to1>
      , <&macro_press &kp MACRO_PLACEHOLDER>
      #ifdef LAYER_LeftPinky
      , <&macro_press &mo LAYER_LeftPinky>  // Direct LAYER_* reference
      #endif
      ...
};
```
- Direct reference to `LAYER_LeftPinky` (not parameterized)
- Conditionally compiled with `#ifdef LAYER_LeftPinky`

### J. `right_pinky_hold` Macro
```c
right_pinky_hold: homey_right_pinky_hold {
    compatible = "zmk,behavior-macro-one-param";
    bindings
      = <&macro_param_1to1>
      , <&macro_press &kp MACRO_PLACEHOLDER>
      #ifdef LAYER_RightPinky
      , <&macro_press &mo LAYER_RightPinky>  // Direct LAYER_* reference
      #endif
      ...
};
```
- Direct reference to `LAYER_RightPinky`

### K. `left_pinky_tap` & `right_pinky_tap` Macros
```c
left_pinky_tap: homey_left_pinky_tap {
    // Does NOT reference layers
    // Only releases modifiers on tap
};
```
- Does NOT reference layers directly

### L. `LeftPinky(key, layer_index)` & `RightPinky(key, layer_index)` Macros (Lines 2464-2478)
```c
#define LeftPinky(key, layer_index) LeftPinky_unroll(layer_index) (key)
#define LeftPinky_layer0(key) left_pinky_layer0_variant LEFT_PINKY_MOD key
#define LeftPinky_layer1(key) left_pinky LEFT_PINKY_MOD key
#define LeftPinky_layer2(key) left_pinky LEFT_PINKY_MOD key
#define LeftPinky_layer3(key) left_pinky LEFT_PINKY_MOD key
#define LeftPinky_layer4(key) left_pinky LEFT_PINKY_MOD key
#define LeftPinky_layer5(key) left_pinky LEFT_PINKY_MOD key
#define LeftPinky_layer6(key) left_pinky LEFT_PINKY_MOD key
```
- **Important**: Second parameter is LAYER INDEX (0-6), NOT layer number!
- These are used to select different behavior macros based on which base layout is active
- Usage: `&LeftPinky (A, LAYER_QWERTY)` where LAYER_QWERTY=0
- Usage: `&LeftPinky (C, LAYER_Enthium)` where LAYER_Enthium=1
- The macros choose different pinky behaviors based on layout (0=bilateral, 1-6=standard)

### M. `RightPinky(key, layer_index)` Macros (Lines 2560-2574)
```c
#define RightPinky_layer0(key) right_pinky_layer0_variant RIGHT_PINKY_MOD key
#define RightPinky_layer1(key) right_pinky RIGHT_PINKY_MOD key
// ... layers 2-6 similar
```
- Same pattern as LeftPinky: second parameter is layer INDEX (0-6)

---

## 4. KEYMAP LAYER STRUCTURE (Lines 11477+)

Keymap organized as named layers:
- `layer_QWERTY` (0) - references LAYER_QWERTY constants
- `layer_Enthium` (1) - references LAYER_Enthium constants
- `layer_Engrammer` (2)
- `layer_Engram` (3)
- `layer_Dvorak` (4)
- `layer_Colemak` (5)
- `layer_ColemakDH` (6)
- `layer_Typing` (7)
- `layer_LeftPinky` (8)
- `layer_RightPinky` (12)
- ... etc through layer 31

Each layer uses LAYER_* constants in key bindings.

---

## 5. CROSS-LAYER REFERENCES IN KEYMAPS

### Layer 0 (QWERTY) typical pattern (Line 11486-11488):
```c
&mo LAYER_Lower                      // Left side: momentary Lower
&magic LAYER_Magic 0                 // Left side: Magic key
&kp EQUAL  &LeftPinky (A, LAYER_QWERTY)  &LeftRingy (S, LAYER_QWERTY)  ...
&thumb LAYER_Function ESC            // Thumb: Function layer
&thumb LAYER_Cursor BACKSPACE        // Thumb: Cursor layer
&thumb LAYER_Number DELETE           // Thumb: Number layer
&thumb LAYER_Typing INSERT           // Thumb: Typing layer
&thumb LAYER_Mouse TAB               // Thumb: Mouse layer
&thumb LAYER_Emoji BSLH              // Thumb: Emoji layer
&thumb LAYER_World PAGE_UP           // Thumb: World layer
&space LAYER_Symbol SPACE            // Spacebar: Symbol layer
```

### Common Access Pattern:
All base layers (0-6) reference these support layers:
- LAYER_Lower (momentary, left side)
- LAYER_Magic (magic key, both sides)
- LAYER_Function (thumb, left)
- LAYER_System (thumb, left)
- LAYER_Cursor (thumb, left)
- LAYER_Number (thumb, left)
- LAYER_Typing (momentary, also thumb variant)
- LAYER_Emoji (thumb, left)
- LAYER_World (thumb, right)
- LAYER_Mouse (thumb, right)
- LAYER_Symbol (spacebar)

---

## 6. SUMMARY FOR LINUX MODE DUPLICATION (Layers 0-31 → 32-63)

### Critical Points:

1. **All references use LAYER_* constants** - no direct numbers (except `&to 0`)
   
2. **Create new constants**:
   ```c
   #define LAYER_QWERTY_LINUX 32
   #define LAYER_Enthium_LINUX 33
   // ... through ...
   #define LAYER_Magic_LINUX 63
   ```

3. **Update these macros/behaviors**:
   - `thumb` - first parameter is layer
   - `stumb` - first parameter is layer
   - `crumb` - first parameter is layer
   - `magic` - first parameter is layer
   - `space` - first parameter is layer
   - `mod_tab_chord` - second parameter is layer
   - `LeftPinky(key, layer_index)` - Used with layer indices 0-6
   - `RightPinky(key, layer_index)` - Used with layer indices 0-6

4. **Special handling for LeftPinky/RightPinky**:
   - `left_pinky_hold` & `right_pinky_hold` use DIRECT `LAYER_LeftPinky` and `LAYER_RightPinky` references
   - These need NEW macros or conditional logic for Linux mode
   - OR: Conditional compilation with `#ifdef LINUX_MODE`

5. **Do NOT change**:
   - `left_pinky_tap` and `right_pinky_tap` - they don't reference layers
   - Standard keycaps like `&kp`
   - Emoji and World character macros

6. **Update keymap structure**:
   - Add `layer_QWERTY_LINUX`, `layer_Enthium_LINUX`, etc.
   - Copy all bindings from original layers 0-6
   - Replace all LAYER_* references with LAYER_*_LINUX versions
   - For layers 7-31, similar approach with _LINUX suffix

7. **Special case: Combos**:
   - `combo_gaming_layer_toggle`: references `LAYER_Gaming`
   - `combo_typing_layer_toggle`: references `LAYER_Typing`
   - Layer lists in combos: `layers = <0 1 2 3 4 5 6>;` stay the same (for layer group 0-31)
   - These may need conditional compilation for Linux vs. non-Linux modes

