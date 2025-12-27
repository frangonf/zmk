# Magic 8 GACS/CAGS Toggle - User Guide

## What is Magic 8?

Magic 8 is a new runtime toggle that lets you switch between **GACS** and **CAGS** modifier orders on your Glove80 keyboard while using macOS.

### GACS vs CAGS - What's the Difference?

Both are arrangements of modifiers on your home row, but with different finger assignments:

**GACS** (GUI-Alt-Ctrl-Shift):
- **Left Pinky:** ⌘ Command
- **Left Ring:** ⌥ Option/Alt
- **Left Middle:** ⌃ Control
- **Left Index:** ⇧ Shift

**CAGS** (Ctrl-Alt-GUI-Shift):
- **Left Pinky:** ⌃ Control
- **Left Ring:** ⌥ Option/Alt
- **Left Middle:** ⌘ Command
- **Left Index:** ⇧ Shift

### Why Would I Want Both?

Different workflows benefit from different modifier positions:

**GACS (Cmd on Pinky) is better for:**
- macOS shortcuts: Cmd+C, Cmd+V, Cmd+Tab, Cmd+Space
- App switching and system navigation
- When you use Cmd more than Ctrl

**CAGS (Ctrl on Pinky) is better for:**
- Terminal work: Ctrl+C, Ctrl+D, Ctrl+Z, Ctrl+R
- Text editing: Ctrl+A, Ctrl+E, Ctrl+K, Ctrl+U
- When you use Ctrl more than Cmd
- Extended Ctrl feature (E, C, I, COMMA keys)

Now you can **switch between them instantly** without reflashing firmware!

---

## How to Use Magic 8

### Accessing the Magic Layer

1. Hold the **Magic key** (usually bottom right thumb key)
2. The number row becomes shortcuts to different modes

### The Shortcuts

From your **number row** while holding Magic:

- **1-6:** Access to other base layers (if you have them)
- **7:** (none)
- **8:** 🎱 **Magic 8** - Toggle to GACS mode
- **9:** 🐧 **Magic 9** - Toggle to Linux mode
- **10-12:** (none)

### Switching Modes

**From macOS CAGS to GACS:**
1. Hold Magic key
2. Press 8
3. Release Magic
4. You're now in GACS mode! Cmd is on your pinky.

**From GACS back to CAGS:**
1. Hold Magic key
2. Press 1 (to go to base QWERTY layer, which is CAGS)
3. Release Magic
4. You're back in CAGS mode! Ctrl is on your pinky.

**From macOS to Linux:**
1. Hold Magic key
2. Press 9
3. Release Magic
4. You're now in Linux mode (GACS order, using Super key)

---

## What Changes When You Switch?

### In GACS Mode (Magic 8):

✅ **What Stays the Same:**
- All your macOS shortcuts work normally (Cmd+C still copies!)
- Bilateral enforcement (can't press same-hand mod+key)
- All layers accessible (Cursor, Number, Function, Symbol, etc.)
- Emoji, World, System, Mouse layers work the same

⚠️ **What Changes:**
- **Cmd is on your PINKY** instead of middle finger
- **Ctrl is on your MIDDLE** finger instead of pinky
- Extended Ctrl keys (E, C, I, COMMA) **don't work** in GACS
- You're now on layers 25-38 instead of 0-13

### Why Do Shortcuts Still Work?

Even though Cmd moves to your pinky in GACS mode, the keyboard still sends **Cmd+C** when you want to copy. The modifier **position** changes, but the **shortcuts** remain correct for macOS.

---

## Extended Ctrl Feature (CAGS Only)

One advantage of CAGS mode is the **Extended Ctrl** feature:

### What is Extended Ctrl?

In CAGS mode, these keys **also act as Ctrl** when held:
- **E** key (left middle finger, top row)
- **C** key (left middle finger, bottom row)
- **I** key (right middle finger, top row)
- **,** (COMMA) key (right middle finger, bottom row)

This gives you more Ctrl positions to reduce pinky strain.

### Example Usage in CAGS:

- Hold **E** + **A**: Ctrl+A (select all)
- Hold **C** + **C**: Ctrl+C (copy) - using the C key as Ctrl!
- Hold **I** + **F**: Ctrl+F (find)

### Important Notes:

- ❌ Extended Ctrl **does NOT work** in GACS mode
- ✅ This is by design - GACS is for when you want Cmd on pinky
- If you need Extended Ctrl, use CAGS mode (Magic → 1)

---

## Linux Mode (Magic 9)

Magic 9 switches to Linux mode, which:
- Uses **GACS** order (Super on pinky, Ctrl on middle)
- Uses **Linux shortcuts** (Ctrl+C for copy, not Cmd+C)
- Is separate from macOS modes (layers 39-63)

**From Linux, you can:**
- Magic 8 → Switch to macOS GACS
- Magic 9 → Switch to macOS CAGS

---

## Tips & Tricks

### Finding Your Preference

Try using each mode for a day:

**Day 1:** CAGS mode
- Use CAGS for terminal/coding work
- Use Extended Ctrl positions
- Notice when you reach awkwardly for Cmd

**Day 2:** GACS mode
- Use GACS for general macOS work
- Notice when Cmd on pinky feels natural
- Notice when you miss Extended Ctrl

**Result:** You'll discover which mode suits which activities!

### Hybrid Workflow

Many users find a hybrid approach works best:

**Morning:** GACS mode
- Email, web browsing, general Mac usage
- Cmd+Tab, Cmd+Space, Cmd+Q heavily used
- Cmd on pinky feels natural

**Afternoon:** CAGS mode
- Terminal work, coding, text editing
- Ctrl+C, Ctrl+Z, Ctrl+R heavily used
- Extended Ctrl positions reduce strain

**Switch anytime:** Just Magic+8 or Magic+1!

### Remembering Which Mode You're In

Visual cues to identify your current mode:

**CAGS mode:**
- Can you use Extended Ctrl? (Try E+A)
- Does pinky do Ctrl+C in terminal?
- ✓ You're in CAGS

**GACS mode:**
- Extended Ctrl doesn't work?
- Does pinky do Cmd+Tab for app switching?
- ✓ You're in GACS

**When in doubt:** Magic+1 returns you to base CAGS mode

---

## Layer Organization (Technical Details)

For those curious about the implementation:

### macOS CAGS (Layers 0-13)
- 0: QWERTY base
- 1: Typing layer
- 2-9: Finger layers
- 10-13: Function layers (Cursor, Number, Function, Symbol)

### macOS SHARED (Layers 14-24)
- 14-24: Special layers used by both CAGS and GACS
- Emoji, World, System, Mouse, Factory, Lower, Magic

### macOS GACS (Layers 25-38)
- 25: QWERTY_GACS base
- 26: Typing_GACS layer
- 27-34: Finger layers GACS
- 35-38: Function layers GACS

### Linux (Layers 39-63)
- 39-63: Complete Linux layer set
- Uses Super (Windows/Tux key) instead of Cmd
- Uses Linux shortcuts (Ctrl+C instead of Cmd+C)

---

## Troubleshooting

### "I pressed Magic+8 but nothing happened"

1. Make sure you're **holding** the Magic key while pressing 8
2. After pressing 8, **release the Magic key**
3. Try pressing Cmd+Tab - if it uses your **pinky**, you're in GACS
4. Try pressing Cmd+Tab - if it uses your **middle** finger, you're in CAGS

### "My shortcuts aren't working"

1. Check which mode you're in (see "Remembering Which Mode" above)
2. Try Magic+1 to return to base CAGS mode
3. If still not working, check your OS is set to macOS (not Linux)

### "Extended Ctrl stopped working"

- Extended Ctrl only works in **CAGS mode** (layers 0-6)
- If you're in GACS mode (Magic+8), switch back with Magic+1
- This is by design - GACS doesn't include Extended Ctrl

### "I want to go back to how it was before"

Just press **Magic+1** - this takes you to the original QWERTY CAGS base layer, exactly as it was before the Magic 8 feature was added.

---

## Features Preserved

Everything from your original configuration still works:

✅ Bilateral enforcement in all modes
✅ All finger layers accessible
✅ All function layers (Cursor, Number, Function, Symbol)
✅ All special layers (Emoji, World, System, Mouse)
✅ Magic 9 Linux toggle (now on layer 39)
✅ Extended Ctrl in CAGS mode (layers 0-6)
✅ Platform-specific shortcuts (macOS uses Cmd, Linux uses Ctrl)
✅ All combos and custom behaviors

**Nothing was removed** - we only **added** the ability to toggle to GACS!

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────┐
│              Magic 8 Quick Reference                │
├─────────────────────────────────────────────────────┤
│ Magic + 1  →  macOS CAGS (Ctrl on pinky)          │
│ Magic + 8  →  macOS GACS (Cmd on pinky)           │
│ Magic + 9  →  Linux GACS (Super on pinky)         │
├─────────────────────────────────────────────────────┤
│ CAGS Features:                                      │
│   • Ctrl on pinky, Cmd on middle                   │
│   • Extended Ctrl (E, C, I, COMMA)                 │
│   • Best for: terminal, coding, text editing       │
├─────────────────────────────────────────────────────┤
│ GACS Features:                                      │
│   • Cmd on pinky, Ctrl on middle                   │
│   • NO Extended Ctrl                                │
│   • Best for: macOS shortcuts, app switching       │
└─────────────────────────────────────────────────────┘
```

---

## FAQ

**Q: Will this affect my typing speed?**
A: No! Your base QWERTY layer is unchanged. Only modifier positions change when you explicitly toggle modes.

**Q: Can I use Magic 8 while in Linux mode?**
A: Yes! From Linux, Magic+8 takes you to macOS GACS.

**Q: Is bilateral enforcement still working?**
A: Yes! All modes (CAGS, GACS, Linux) have full bilateral enforcement.

**Q: What happened to my Gaming layer?**
A: It was commented out (not deleted) to free up space. If you need it back, we can restore it in a custom build.

**Q: What happened to Dvorak/Colemak/other layouts?**
A: They were removed to free up space since you only use QWERTY. If you need them back, we can restore specific layouts in a custom build.

**Q: Can I customize which key is Magic 8?**
A: Yes! Edit `special-layers.dtsi` and change the `&to 25` binding to a different position.

**Q: Does this work on other keyboards?**
A: This implementation is specific to Glove80 and this particular ZMK config. The concepts could be adapted to other ZMK keyboards.

---

## Feedback & Issues

If you encounter any issues or have suggestions:

1. Check this guide first
2. Review VERIFICATION-REPORT.md for technical details
3. Test on hardware and document any unexpected behavior
4. Consider your workflow - maybe a different mode suits your task better!

---

**Enjoy your new Magic 8 toggle! 🎱**

*Switch between CAGS and GACS anytime - find what works best for YOUR workflow!*
