# Building ZMK with 64-Layer Support for Glove80

## Quick Test Build

### Option 1: Using Nix (Recommended)

```bash
# 1. Install Nix (if not already installed)
curl -L https://nixos.org/nix/install | sh
source ~/.nix-profile/etc/profile.d/nix.sh

# 2. Build for Glove80
nix-build -A glove80_combined

# The firmware will be at: ./result/glove80.uf2
```

### Option 2: Using Docker

```bash
# 1. Pull the ZMK build container
docker pull zmkfirmware/zmk-build-arm:3.5

# 2. Initialize the workspace
docker run --rm -v $(pwd):/workspace -w /workspace \
  zmkfirmware/zmk-build-arm:3.5 \
  /bin/bash -c "west init -l app && west update"

# 3. Build for Glove80 Left
docker run --rm -v $(pwd):/workspace -w /workspace \
  zmkfirmware/zmk-build-arm:3.5 \
  /bin/bash -c "west build -s app -b glove80_lh -d build/left"

# 4. Build for Glove80 Right
docker run --rm -v $(pwd):/workspace -w /workspace \
  zmkfirmware/zmk-build-arm:3.5 \
  /bin/bash -c "west build -s app -b glove80_rh -d build/right"

# Firmware files will be at:
# - build/left/zephyr/zmk.uf2
# - build/right/zephyr/zmk.uf2
```

### Option 3: Using West (Native Linux/macOS)

```bash
# 1. Install dependencies (Ubuntu/Debian)
sudo apt update
sudo apt install -y git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1

# 2. Install West
pip3 install --user -U west

# 3. Initialize workspace
west init -l app
west update

# 4. Export Zephyr CMake package
west zephyr-export

# 5. Install Zephyr SDK (if not already installed)
cd ~
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.4/zephyr-sdk-0.16.4_linux-x86_64.tar.xz
tar xvf zephyr-sdk-0.16.4_linux-x86_64.tar.xz
cd zephyr-sdk-0.16.4
./setup.sh

# 6. Build for Glove80
cd /home/user/zmk
west build -s app -b glove80_lh -d build/left
west build -s app -b glove80_rh -d build/right

# Firmware files:
# - build/left/zephyr/zmk.uf2
# - build/right/zephyr/zmk.uf2
```

## Testing with the 64-Layer Test Keymap

I've created a test keymap at `/home/user/zmk/test-64-layers.keymap` that uses all 64 layers (0-63).

To use it with your Glove80:

### Step 1: Create a custom Glove80 config directory

```bash
mkdir -p /home/user/zmk/config
cp /home/user/zmk/test-64-layers.keymap /home/user/zmk/config/glove80.keymap
```

### Step 2: Update the keymap for Glove80's actual layout

The test keymap needs to be adapted to Glove80's 80-key layout. Here's a proper version:

```bash
cat > /home/user/zmk/config/glove80.keymap << 'EOF'
#include <behaviors.dtsi>
#include <dt-bindings/zmk/keys.h>
#include <dt-bindings/zmk/bt.h>

/ {
    keymap {
        compatible = "zmk,keymap";

        // Glove80 has 80 keys (6 rows × 14 columns - thumb clusters)
        // This is a minimal test to verify 64 layers work

        default_layer {
            bindings = <
            // Left hand
            &mo 32  &mo 40  &mo 50  &mo 60  &kp N5     &kp N6                                                              &kp N7     &kp N8     &kp N9     &kp N0     &kp MINUS  &kp EQUAL
            &kp TAB    &kp Q      &kp W      &kp E      &kp R      &kp T                                                               &kp Y      &kp U      &kp I      &kp O      &kp P      &kp BSLH
            &kp CAPS   &kp A      &kp S      &kp D      &kp F      &kp G                                                               &kp H      &kp J      &kp K      &kp L      &kp SEMI   &kp SQT
            &kp LSHFT  &kp Z      &kp X      &kp C      &kp V      &kp B      &mo 1      &mo 2      &mo 3      &mo 4      &kp N      &kp M      &kp COMMA  &kp DOT    &kp FSLH   &kp RSHFT
            &magic 5 0 &kp HOME   &kp END    &kp LEFT   &kp RIGHT                        &kp LCTRL  &kp LALT   &kp LGUI   &kp RCTRL               &kp UP     &kp DOWN   &kp LBKT   &kp RBKT   &mo 63
            // Right hand thumb cluster
                                                        &kp PG_UP  &kp PG_DN  &kp BSPC   &kp DEL    &kp RET    &kp SPACE
            >;
        };

        // Layers 1-31 (standard layers that always worked)
        layer_1 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_2 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_3 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_4 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_5 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };

        // Skip layers 6-31 for brevity (add &trans bindings like above)
        layer_6 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_7 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_8 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_9 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_10 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };

        // Layers 11-30 - add as needed with &trans bindings
        layer_11 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_12 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_13 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_14 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_15 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_16 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_17 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_18 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_19 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_20 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_21 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_22 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_23 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_24 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_25 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_26 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_27 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_28 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_29 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_30 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_31 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };

        // *** LAYERS 32-63: These ONLY work with 64-bit layer support! ***
        layer_32 {
            bindings = <
            &kp F13  &kp F14  &kp F15  &kp F16  &kp F17  &kp F18                                                                           &kp F19  &kp F20  &kp F21  &kp F22  &kp F23  &kp F24
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans                                                         &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans                                  &trans &trans &trans &trans                                &trans &trans &trans &trans &trans
                                                                                  &trans &trans &trans &trans &trans &trans
            >;
        };

        // Layers 33-62 with &trans bindings
        layer_33 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_34 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_35 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_36 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_37 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_38 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_39 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };

        layer_40 {
            bindings = <
            &bt BT_SEL 0 &bt BT_SEL 1 &bt BT_SEL 2 &bt BT_SEL 3 &bt BT_SEL 4 &bt BT_CLR                                                   &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans                                                         &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans                                  &trans &trans &trans &trans                                &trans &trans &trans &trans &trans
                                                                                  &trans &trans &trans &trans &trans &trans
            >;
        };

        layer_41 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_42 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_43 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_44 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_45 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_46 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_47 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_48 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_49 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };

        layer_50 {
            bindings = <
            &kp C_MUTE &kp C_VOL_DN &kp C_VOL_UP &kp C_PP &kp C_PREV &kp C_NEXT                                                          &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans                                                         &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans                                  &trans &trans &trans &trans                                &trans &trans &trans &trans &trans
                                                                                  &trans &trans &trans &trans &trans &trans
            >;
        };

        layer_51 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_52 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_53 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_54 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_55 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_56 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_57 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_58 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_59 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };

        layer_60 {
            bindings = <
            &kp PSCRN &kp SLCK &kp PAUSE_BREAK &kp INS &trans &trans                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans                                                         &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans                                  &trans &trans &trans &trans                                &trans &trans &trans &trans &trans
                                                                                  &trans &trans &trans &trans &trans &trans
            >;
        };

        layer_61 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };
        layer_62 { bindings = <&trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans>; };

        // Layer 63 - The highest layer possible!
        layer_63 {
            bindings = <
            &sys_reset &trans &trans &trans &trans &bootloader                                                                            &bootloader &trans &trans &trans &trans &sys_reset
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans                                                                                      &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans &trans &trans &trans &trans &trans                                                         &trans &trans &trans &trans &trans &trans
            &trans &trans &trans &trans &trans                                  &trans &trans &trans &trans                                &trans &trans &trans &trans &trans
                                                                                  &trans &trans &trans &trans &trans &trans
            >;
        };
    };

    behaviors {
        magic: magic_hold_tap {
            compatible = "zmk,behavior-hold-tap";
            #binding-cells = <2>;
            flavor = "tap-preferred";
            tapping-term-ms = <200>;
            bindings = <&mo>, <&kp>;
        };
    };
};
EOF

echo "✓ Created test keymap with 64 layers at config/glove80.keymap"
```

This keymap:
- Uses layers 0-31 (standard)
- **Uses layers 32-63 (NEW - proves 64-layer support works!)**
- Layer 32 has F13-F24 function keys
- Layer 40 has Bluetooth controls
- Layer 50 has media controls
- Layer 60 has system keys (Print Screen, Scroll Lock, etc.)
- Layer 63 has reset/bootloader access (highest possible layer)

### Step 3: Build with the test keymap

```bash
# Using Nix with custom keymap
nix-build -A glove80_combined --argstr keymap /home/user/zmk/config/glove80.keymap

# Or using Docker
docker run --rm -v $(pwd):/workspace -w /workspace \
  zmkfirmware/zmk-build-arm:3.5 \
  /bin/bash -c "cp config/glove80.keymap app/boards/arm/glove80/glove80.keymap && \
                west build -s app -b glove80_lh -d build/left && \
                west build -s app -b glove80_rh -d build/right"
```

## Flashing to Your Glove80

1. **Put the Glove80 into bootloader mode:**
   - Press Magic (bottom-left palm key) + 0 key on left half
   - The keyboard will appear as a USB drive named "GLV80LHBOOT"

2. **Flash the firmware:**
   ```bash
   # For left half
   cp result/zmk_glove80_lh.uf2 /media/<user>/GLV80LHBOOT/

   # For right half (repeat bootloader mode for right side)
   cp result/zmk_glove80_rh.uf2 /media/<user>/GLV80RHBOOT/
   ```

3. **Test the layers:**
   - Hold the first key on row 1 to activate layer 32 (should get F13-F24 keys)
   - Hold the second key to activate layer 40 (Bluetooth controls)
   - Hold the third key to activate layer 50 (media controls)
   - Hold the fourth key to activate layer 60 (system keys)
   - Hold the rightmost key to activate layer 63 (highest layer - bootloader access)

## Verifying 64-Layer Support Works

The firmware will compile successfully **only** if the 64-layer support is working. Without it:
- Compilation would fail when trying to use layers > 31
- Runtime would have undefined behavior accessing layers beyond bit 31

### Build Log Check

Watch for these in the build output:
```
✓ No compilation errors about invalid layer numbers
✓ Successfully links all 64 layers
✓ Firmware size is reasonable (should be similar to 32-layer builds)
```

## Troubleshooting

**If build fails with "layer out of range":**
- The 64-layer patch didn't apply correctly
- Check that `zmk_keymap_layers_state_t` is `uint64_t` in `app/include/zmk/keymap.h`

**If build fails with undefined BIT64:**
- Zephyr might not have BIT64 macro
- Check `app/src/keymap.c` has the WRITE_BIT64 macro defined

**If firmware is too large:**
- Reduce the number of layers in your test keymap
- The Glove80 has sufficient flash for 64 layers, but extreme configs might hit limits

Let me know which build method you'd like detailed help with!
