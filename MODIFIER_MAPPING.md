# Home Row Modifier Mapping - macOS vs Linux

## Overview

The keyboard now has OS-specific modifier mappings for macOS (layers 0-31) and Linux (layers 32-63).

## macOS Mode (Layers 0-31)

**Home Row Mods Configuration:**
- **Pinky fingers** (A/; keys): `Ctrl` (LCTL)
- **Ring fingers** (S/L keys): `Alt/Option` (LALT)
- **Middle fingers** (D/K keys): `Cmd/⌘` (LGUI)
- **Index fingers** (F/J keys): `Shift` (LSFT)

**Typical macOS shortcuts work as expected:**
- `Cmd+C` = Copy (Middle finger + C)
- `Cmd+V` = Paste (Middle finger + V)
- `Cmd+S` = Save (Middle finger + S)
- `Ctrl+A` = Move to line start (Pinky + A)

## Linux Mode (Layers 32-63)

**Home Row Mods Configuration:**
- **Pinky fingers** (A/; keys): `Super/Win` (LGUI)
- **Ring fingers** (S/L keys): `Alt` (LALT)
- **Middle fingers** (D/K keys): `Ctrl` (LCTL)
- **Index fingers** (F/J keys): `Shift` (LSFT)

**Typical Linux shortcuts work correctly:**
- `Ctrl+C` = Copy (Middle finger + C)
- `Ctrl+V` = Paste (Middle finger + V)
- `Ctrl+S` = Save (Middle finger + S)
- `Super+D` = Show desktop (Pinky + D)

## What Changed?

The key swap between macOS and Linux modes:

| Finger | macOS | Linux |
|--------|-------|-------|
| Pinky  | Ctrl  | Super/Win |
| Ring   | Alt   | Alt ✓ |
| Middle | Cmd   | Ctrl |
| Index  | Shift | Shift ✓ |

**Effect:** 
- Your muscle memory for shortcuts remains the same!
- Middle finger + C = Copy on both OSes
- The keyboard automatically sends the correct modifier (Cmd on macOS, Ctrl on Linux)

## How to Switch Modes

**Magic + F5** toggles between macOS and Linux mode:
- From macOS mode → switches to Linux QWERTY (layer 32)
- From Linux mode → switches back to macOS QWERTY (layer 0)

## Technical Details

**macOS layers (0-31):**
```c
LeftPinky_layer0(A) = left_pinky LCTL A    // Ctrl+A
LeftMiddy_layer0(S) = left_middy LGUI S    // Cmd+S
```

**Linux layers (32-63):**
```c
LeftPinky_layer32(A) = left_pinky LGUI A   // Super+A
LeftMiddy_layer32(S) = left_middy LCTL S   // Ctrl+S
```

The swap ensures that common shortcuts (copy, paste, save, etc.) use the same finger positions on both operating systems, even though the physical keys send different modifiers.
