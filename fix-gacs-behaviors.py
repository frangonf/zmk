#!/usr/bin/env python3
"""
Fix GACS layer home row mod definitions (layers 25-38)
This adds missing behavior definitions for macOS GACS layers
"""

import re

HRM_FILE = "app/boards/arm/glove80/includes/behaviors/home-row-mods.dtsi"

# Finger definitions: (name, modifier_variable, behavior_prefix)
FINGERS = [
    ("RightPinky", "LINUX_PINKY_MOD", "right_pinky"),
    ("LeftRingy", "LINUX_RINGY_MOD", "left_ringy"),
    ("RightRingy", "LINUX_RINGY_MOD", "right_ringy"),
    ("LeftMiddy", "LINUX_MIDDY_MOD", "left_middy"),
    ("RightMiddy", "LINUX_MIDDY_MOD", "right_middy"),
    ("LeftIndex", "LINUX_INDEX_MOD", "left_index"),
    ("RightIndex", "LINUX_INDEX_MOD", "right_index"),
]

def add_gacs_definitions(content, finger, mod_var, behavior):
    """Add GACS layer definitions (25-38) for a finger"""

    # Check if already exists
    if f"macOS GACS layer definitions for {finger} (layers 25-38)" in content:
        print(f"  ✓ {finger} GACS definitions already exist")
        return content

    # Find the insertion point (before Linux layer definitions)
    pattern = f"  // Linux layer definitions for {finger}"
    if pattern not in content:
        print(f"  ⚠ Could not find insertion point for {finger}")
        return content

    # Create GACS definitions
    gacs_defs = f"""  // macOS GACS layer definitions for {finger} (layers 25-38)
  // These use GACS order: GUI on pinky, Ctrl on middle (same as Linux modifiers)
  #define {finger}_layer25(key) {behavior}_linux_variant {mod_var} key
  #define {finger}_layer26(key) {behavior} {mod_var} key
  #define {finger}_layer27(key) {behavior} {mod_var} key
  #define {finger}_layer28(key) {behavior} {mod_var} key
  #define {finger}_layer29(key) {behavior} {mod_var} key
  #define {finger}_layer30(key) {behavior} {mod_var} key
  #define {finger}_layer31(key) {behavior} {mod_var} key
  #define {finger}_layer32(key) {behavior} {mod_var} key
  #define {finger}_layer33(key) {behavior} {mod_var} key
  #define {finger}_layer34(key) {behavior} {mod_var} key
  #define {finger}_layer35(key) {behavior} {mod_var} key
  #define {finger}_layer36(key) {behavior} {mod_var} key
  #define {finger}_layer37(key) {behavior} {mod_var} key
  #define {finger}_layer38(key) {behavior} {mod_var} key

"""

    # Insert before the Linux layer definitions
    content = content.replace(pattern, gacs_defs + pattern)
    print(f"  ✓ Added GACS definitions for {finger}")
    return content


def remove_duplicate_linux_definitions(content, finger):
    """Remove old Linux layer32-38 definitions that overlap with GACS"""

    # Find all layer32-39 definitions for this finger in Linux section
    # Pattern: lines after "Linux layer definitions for {finger}"
    linux_section_start = f"  // Linux layer definitions for {finger}"

    if linux_section_start not in content:
        return content

    # Find the section
    lines = content.split('\n')
    in_linux_section = False
    new_lines = []
    removed_count = 0

    for i, line in enumerate(lines):
        if linux_section_start in line:
            in_linux_section = True
            new_lines.append(line)
            continue

        if in_linux_section:
            # Check if this is a duplicate layer32-38 definition
            if re.match(rf'  #define {finger}_layer(3[2-8])\(key\)', line):
                # Skip this line (it's a duplicate)
                removed_count += 1
                continue
            # Check if we've left the finger section (reached layer39 or next finger)
            elif re.match(rf'  #define {finger}_layer39\(key\)', line):
                # We found layer39, which marks end of overlap
                in_linux_section = False
                new_lines.append(line)
                continue
            elif '// Linux layer definitions for' in line or '// macOS' in line:
                # We've reached another finger section
                in_linux_section = False
                new_lines.append(line)
                continue

        new_lines.append(line)

    if removed_count > 0:
        print(f"  ✓ Removed {removed_count} duplicate layer32-38 definitions for {finger}")

    return '\n'.join(new_lines)


def main():
    print("=== Fixing GACS layer home row mod definitions ===")
    print(f"File: {HRM_FILE}")

    # Read file
    with open(HRM_FILE, 'r') as f:
        content = f.read()

    # Add GACS definitions for each finger
    for finger, mod_var, behavior in FINGERS:
        print(f"Processing {finger}...")
        content = add_gacs_definitions(content, finger, mod_var, behavior)

    # Remove duplicates
    print("\nRemoving duplicate Linux layer32-38 definitions...")
    for finger, _, _ in FINGERS:
        content = remove_duplicate_linux_definitions(content, finger)

    # Also handle LeftPinky (already added manually)
    print("Processing LeftPinky...")
    content = remove_duplicate_linux_definitions(content, "LeftPinky")

    # Write back
    with open(HRM_FILE, 'w') as f:
        f.write(content)

    print("\n=== GACS behavior definitions fixed! ===")
    print("\nSummary:")
    print("- Added macOS GACS layer definitions (25-38) for all fingers")
    print("- Removed duplicate Linux layer32-38 definitions")
    print("- GACS layers now use LGUI on pinky, LCTL on middle (correct!)")
    print("- Bilateral enforcement preserved")


if __name__ == "__main__":
    main()
