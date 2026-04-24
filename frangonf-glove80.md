---
tags:
  - glove80
  - zmk
  - keymap
  - qmk.nvim
---

# frangonf Glove80

Canonical note for this repository's custom Glove80 layout.

## What is current

| File | Status | Purpose |
| --- | --- | --- |
| `frangonf-glove80.keymap` | Canonical export | Single-file, qmk.nvim-friendly view of the full 64-layer layout |
| `app/boards/arm/glove80/glove80.keymap` | Firmware entrypoint | Wrapper that includes the modular source files |
| `app/boards/arm/glove80/includes/layers/*.dtsi` | Source of truth | Real layer definitions |
| `app/boards/arm/glove80/includes/behaviors/*.dtsi` | Source of truth | Home-row mods, emoji, world chars, mouse, and system behaviors |
| `app/boards/arm/glove80/includes/combos.dtsi` | Source of truth | Chorded combos that are not visible in the layer matrix |

This file keeps the accurate exported-keymap structure and folds in the still-relevant build and repository context from the earlier project note.

## Quick build reference

```bash
# Build both halves into one UF2
nix-build -A glove80_combined

# Flash by copying result/glove80.uf2 to both boot volumes
# GLV80LHBOOT and GLV80RHBOOT
```

Emergency recovery is preserved through the Magic layer, which still exposes bootloader and reset access.

## Architecture

The live layout is a mirrored **64-layer** system:

| Range | OS | Families |
| --- | --- | --- |
| `0-31` | macOS | 7 base layers, typing, 8 finger layers, 7 utility layers, 5 mouse layers, 4 special layers |
| `32-63` | Linux | Same stack, offset by `+32` |

This is why the repo carries a `uint64_t` layer-state change: stock 32-layer handling is not enough for the dual-OS stack.

## Base layers

The base family keeps the same thumb cluster and safety layout while swapping only the alpha arrangement.

| Layer | Name | Notes |
| --- | --- | --- |
| `0` / `32` | QWERTY | Default starting point |
| `1` / `33` | Enthium | Alternative alpha layout |
| `2` / `34` | Engrammer | Alternative alpha layout |
| `3` / `35` | Engram | Uses custom Engram punctuation helpers and a special `engram_AT` thumb behavior |
| `4` / `36` | Dvorak | Dvorak alpha arrangement |
| `5` / `37` | Colemak | Uses `crumb` on the typing thumb for retro-tap |
| `6` / `38` | ColemakDH | Colemak-DH alpha arrangement |

### Base-layer shape

The exported keymap preserves the real Glove80 binding order:

1. Top function row.
2. Upper alpha row.
3. Home row with mod-taps.
4. Lower alpha row plus inner utility zone.
5. Bottom outer keys plus the main thumb cluster.

## Thumb cluster model

| Behavior | Meaning |
| --- | --- |
| `&thumb LAYER_X KEY` | Hold for layer `X`, tap `KEY` |
| `&space LAYER_X SPACE` | Same idea, tuned for the space thumb |
| `&crumb ...` | Thumb hold-tap with retro-tap enabled |
| `&parang_left` / `&parang_right` | `(` / `)` normally, `<` / `>` when Shift is active |
| `&magic LAYER_Magic[_Linux] 0` | Hold for Magic layer, tap to show RGB status |

## Home-row mods

The home row is not a simple row of letters.

| Pattern | What it means |
| --- | --- |
| `LeftPinky(A, layer)` | Tap `A`, hold as the left pinky mod and enter the transient left-pinky helper layer |
| `RightIndex(J, layer)` | Tap `J`, hold as the right index mod and enter the transient right-index helper layer |
| `LeftMiddyExtendUp/Down`, `MiddyExtendUp/Down` | Extra macOS-only Ctrl-capable exceptions on `E`, `C`, `I`, and `,` when `MACOS_CAGS_EXTEND` is enabled |

### OS difference

The finger mods are intentionally different across OS stacks:

| OS | Pinky | Ring | Middle | Index |
| --- | --- | --- | --- | --- |
| macOS | `Ctrl` | `Alt` | `Gui/Cmd` | `Shift` |
| Linux | `Gui` | `Alt` | `Ctrl` | `Shift` |

That swap is a major reason the repo mirrors the full layer stack instead of trying to reuse one shared base layer family.

## Utility layers

| Layer | Name | Purpose |
| --- | --- | --- |
| `7` / `39` | Typing | Recover literal key positions from mod-tap-heavy base layers |
| `8-15` / `40-47` | Finger layers | Transient support layers for home-row-mod resolution |
| `16` / `48` | Cursor | Editing, selection, find/replace, nav cluster |
| `17` / `49` | Number | Number pad plus symbol helpers |
| `18` / `50` | Function | F-keys, media, brightness, launcher-style shortcuts |
| `19` / `51` | Emoji | Emoji palette behaviors |
| `20` / `52` | World | International characters and symbol groups |
| `21` / `53` | Symbol | Punctuation-heavy symbol layer |
| `22` / `54` | System | Lock, sleep, power, RGB, SysRq/print controls |
| `23-27` / `55-59` | Mouse family | Pointer, scroll, and speed variants |

## Special layers

| Layer | Name | Why it matters |
| --- | --- | --- |
| `28` / `60` | Gaming | Fixed non-mod-tap layout for games |
| `29` / `61` | Factory | Known-safe fallback layout |
| `30` / `62` | Lower | Portal layer into number/function/system/emoji/cursor/mouse/world |
| `31` / `63` | Magic | Bluetooth, RGB, bootloader, reset, and base-layer switching |

The Magic and Factory layers are the recovery path. If the live firmware changes, these are the layers that should remain conservative and easy to access.

## Code structure

```text
app/boards/arm/glove80/
├── glove80.keymap
└── includes/
    ├── helpers.dtsi
    ├── behaviors.dtsi
    ├── combos.dtsi
    ├── behaviors/
    │   ├── definitions.dtsi
    │   ├── home-row-mods.dtsi
    │   ├── world-characters.dtsi
    │   ├── emoji.dtsi
    │   └── post-macros.dtsi
    └── layers/
        ├── base-layers.dtsi
        ├── base-layers-linux.dtsi
        ├── typing-layer.dtsi
        ├── typing-layer-linux.dtsi
        ├── finger-layers*.dtsi
        ├── function-layers*.dtsi
        ├── mouse-layers*.dtsi
        └── special-layers*.dtsi
```

## Combo layer that is easy to forget

Combos are not visible in the layer matrix, but they are part of the real config:

| Combo | Result |
| --- | --- |
| `T2 + T3` | Sticky Globe |
| `T1 + T2` | Sticky `RAlt` |
| `T2 + T5` | Alt-Tab style switcher |
| `T5 + T6` | Win-Tab / Ctrl-Shift style helpers |
| `T3 + T6` | Ctrl-Tab / Meh helper |
| `T1 + T4` | Sticky Shift |
| `T4 + T5` | Caps Word |
| `T1 + T5` | Caps Lock |
| `LH C1R5 + C2R6` | Toggle Gaming |
| `RH C1R5 + C2R6` | Toggle Typing |
| `T1 + T2 + T3` | Reset to base layer `0` |

See `app/boards/arm/glove80/includes/combos.dtsi` for the exact layer scoping.

## Gotchas

1. The exported `.keymap` is flattened only for readability. The live firmware still depends on the modular `includes/` tree.
2. Emoji and world behaviors come from a fragile shared `macros {}` block spread across `world-characters.dtsi`, `emoji.dtsi`, and `post-macros.dtsi`.
3. Mouse behavior is not just `mmv` and `msc` bindings; the acceleration logic lives in `post-macros.dtsi`.
4. The finger helper layers are not meant to be typed on directly. They are transient states used during hold-tap resolution.
5. Linux layers are not clones in the shortcut sense: `_LINUX_*` aliases change copy/paste/find/replace semantics, and the home-row mod mapping changes too.
6. `MACOS_CAGS_EXTEND` changes the feel of the macOS base layers by making `E`, `C`, `I`, and `,` extra Ctrl-capable positions.
7. Magic and Factory are safety-critical, not just convenience layers.

## qmk.nvim usage

For this export, the important parts are the `.keymap` extension and ZMK parsing mode:

```lua
require('qmk').setup({
  name = 'glove80',
  variant = 'zmk',
  auto_format_pattern = { 'frangonf-glove80.keymap' },
})
```

To get the visual comment preview, you still need to provide a Glove80 `layout = { ... }` table in your Neovim config. The plugin can format the file without that table, but it cannot draw the board preview without one.
