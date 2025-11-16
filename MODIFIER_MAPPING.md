# Home Row Modifier Mapping - macOS vs Linux

## Overview

The keyboard now has OS-specific modifier mappings for macOS (layers 0-31) and Linux (layers 32-63).

## macOS Mode (Layers 0-31)

**Home Row Mods Configuration (QWERTY labels):**
- Left hand:  **A**=Ctrl, **S**=Alt, **D**=Cmd,  **F**=Shift
- Right hand: **J**=Shift, **K**=Cmd, **L**=Alt, **;**=Ctrl

**Typical macOS shortcuts work as expected:**
- `Cmd+C` = Copy (Middle finger + C)
- `Cmd+V` = Paste (Middle finger + V)
- `Cmd+S` = Save (Middle finger + S)
- `Ctrl+A` = Move to line start (Pinky + A)

## Linux Mode (Layers 32-63)

**Home Row Mods Configuration (QWERTY labels):**
- Left hand:  **A**=Super, **S**=Alt, **D**=Ctrl, **F**=Shift
- Right hand: **J**=Shift, **K**=Ctrl, **L**=Alt, **;**=Super

**Typical Linux shortcuts work correctly:**
- `Ctrl+C` = Copy (Middle finger + C)
- `Ctrl+V` = Paste (Middle finger + V)
- `Ctrl+S` = Save (Middle finger + S)
- `Super+D` = Show desktop (Pinky + D)

## What Changed?

The key swap between macOS and Linux modes:

| Key (QWERTY) | Finger | macOS | Linux |
|--------------|--------|-------|-------|
| A / ;        | Pinky  | Ctrl  | Super/Win |
| S / L        | Ring   | Alt   | Alt ✓ |
| D / K        | Middle | Cmd   | Ctrl |
| F / J        | Index  | Shift | Shift ✓ |

**Effect:**
- Your muscle memory for shortcuts remains the same!
- Middle finger (D/K) + C = Copy on both OSes
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
