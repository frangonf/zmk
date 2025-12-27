# Magic 8 Implementation: Layer Organization

## Final 64-Layer Layout

```
Layers 0-13:   macOS CAGS specific (14 layers)
  0:  QWERTY
  1:  Typing
  2:  LeftPinky
  3:  LeftRingy
  4:  LeftMiddy
  5:  LeftIndex
  6:  RightPinky
  7:  RightRingy
  8:  RightMiddy
  9:  RightIndex
  10: Cursor
  11: Number
  12: Function
  13: Symbol

Layers 14-24:  macOS SHARED (CAGS and GACS both use these) (11 layers)
  14: Emoji
  15: World
  16: System
  17: Mouse
  18: MouseFine
  19: MouseSlow
  20: MouseFast
  21: MouseWarp
  22: Factory
  23: Lower
  24: Magic

Layers 25-38:  macOS GACS specific (14 layers)
  25: QWERTY_GACS
  26: Typing_GACS
  27: LeftPinky_GACS
  28: LeftRingy_GACS
  29: LeftMiddy_GACS
  30: LeftIndex_GACS
  31: RightPinky_GACS
  32: RightRingy_GACS
  33: RightMiddy_GACS
  34: RightIndex_GACS
  35: Cursor_GACS
  36: Number_GACS
  37: Function_GACS
  38: Symbol_GACS

Layers 39-63:  Linux GACS (25 layers)
  39: QWERTY_Linux
  40: Typing_Linux
  41: LeftPinky_Linux
  42: LeftRingy_Linux
  43: LeftMiddy_Linux
  44: LeftIndex_Linux
  45: RightPinky_Linux
  46: RightRingy_Linux
  47: RightMiddy_Linux
  48: RightIndex_Linux
  49: Cursor_Linux
  50: Number_Linux
  51: Function_Linux
  52: Emoji_Linux
  53: World_Linux
  54: Symbol_Linux
  55: System_Linux
  56: Mouse_Linux
  57: MouseFine_Linux
  58: MouseSlow_Linux
  59: MouseFast_Linux
  60: MouseWarp_Linux
  61: Factory_Linux
  62: Lower_Linux
  63: Magic_Linux
```

## Removed Layers

**From macOS (CAGS and GACS):**
- Enthium (was layer 1)
- Engrammer (was layer 2)
- Engram (was layer 3)
- Dvorak (was layer 4)
- Colemak (was layer 5)
- ColemakDH (was layer 6)
- Gaming (was layer 28)

**From Linux:**
- Enthium_Linux (was layer 33)
- Engrammer_Linux (was layer 34)
- Engram_Linux (was layer 35)
- Dvorak_Linux (was layer 36)
- Colemak_Linux (was layer 37)
- ColemakDH_Linux (was layer 38)
- Gaming_Linux (was layer 60)

## Magic Key Behaviors

**Magic 8 (CAGS ↔ GACS toggle):**
- From QWERTY (layer 0) → `&to 25` (QWERTY_GACS)
- From QWERTY_GACS (layer 25) → `&to 0` (QWERTY)

**Magic 9 (macOS ↔ Linux toggle):**
- From macOS QWERTY (layer 0) → `&to 39` (QWERTY_Linux) **[UPDATED from &to 32]**
- From Linux QWERTY (layer 39) → `&to 0` (macOS QWERTY)

## Shared Layers Explanation

Layers 14-24 are SHARED between macOS CAGS and GACS because:
- They don't contain home row mod references (Emoji, World, Mouse movements)
- Or they only contain macOS shortcuts that are the same regardless of CAGS/GACS (_COPY, _PASTE use Cmd in both modes)

When you're in CAGS mode (layers 0-13) and access Emoji (layer 14), you use layer 14.
When you're in GACS mode (layers 25-38) and access Emoji, you ALSO use layer 14 (same layer).

This is why they can be shared!
