# VLSI-Physical-Verification-Sky130A
A hands-on VLSI physical verification project using the SKY130A PDK. Covers CMOS inverter schematic design, layout creation in Magic, Design Rule Checking (DRC), Layout Versus Schematic (LVS), SPICE netlist extraction, and post-layout transient simulation using ngspice. Documents the workflow, results, and key learnings.

## Tools Used

| Tool | Version | Purpose |
|---|---|---|
| Magic VLSI | 8.3 | Layout design and DRC |
| Xschem | 3.4.8RC | Schematic capture and netlist |
| Netgen | 1.5.325 | LVS comparison |
| NGSpice | 37 | Pre and post-layout simulation |
| SKY130A PDK | Latest | Process design kit |

---

## Development Environment

- **Host OS:** Windows 11
- **Virtualization:** Oracle VirtualBox
- **Guest OS:** Ubuntu 24.04.1 LTS

> **Note:** Ubuntu 26.04.1 LTS (latest) was initially attempted but caused tool compatibility issues during EDA tool compilation. Downgraded to Ubuntu 24.04.1 LTS for a stable environment.

### System Resources

| Resource | Value |
|---|---|
| OS | Ubuntu 24.04.5 LTS (Noble) |
| Kernel | 7.0.0-38-generic |
| RAM (total) | 10 GiB |
| RAM (available) | 2.9 GiB |
| Swap | 4.0 GiB |
| CPU cores | 4 |
| Disk size | 59 GiB |
| Disk used | 38 GiB (68%) |
| Disk available | 19 GiB |

## 1. Environment Setup

### 1.1 System Validation

```bash
lsb_release -a
uname -a
free -h
df -h /
nproc
```

📸 *Screenshot: `screenshots/01_system_info.png`*

### 1.2 Package Update

```bash
sudo apt update && sudo apt upgrade -y
```

### 1.3 Git Installation and Repository Setup

```bash
sudo apt install git -y
git --version
```

📸 *Screenshot: `screenshots/02_git_setup.png`*

---

## 2. EDA Tool Installation and Verification

### 2.1 Magic VLSI

#### Installation

```bash
git clone git://opencircuitdesign.com/magic
cd magic
sudo apt install tcl-dev tk-dev -y
```

#### Problem 1 — GCC Compilation Error

```
error: too many arguments to function 'WindAddCommand'
error: too many arguments to function 'WindMove'
error: too many arguments to function 'WindSetWindowAreas'
```

**Cause:** Default C standard in GCC incompatible with older Magic source code.

**Fix:**
```bash
make clean
./configure CFLAGS="-std=gnu17"
make
```

#### Problem 2 — Missing OpenGL Header

```
fatal error: GL/glu.h: No such file or directory
```

**Fix:**
```bash
sudo apt install libgl-dev libglu1-mesa-dev -y
make
sudo make install
```

#### Verify Magic is Working

```bash
which magic          # /usr/local/bin/magic
magic --version
magic -d XR     # launch with SKY130A tech
```

Expected: Magic GUI launched.

📸 *Screenshot: `screenshots/03_magic_version.png`*


---

### 2.2 Xschem

#### Installation

```bash
git clone https://github.com/StefanSchippers/xschem.git xschem_git
./configure
make
sudo make install
```

#### Verify Xschem is Working

```bash
xschem --version
xschem
```

Expected: Xschem schematic editor GUI opens.

📸 *Screenshot: `screenshots/04_xschem_launch.png`*

---

### 2.3 Netgen

#### Installation

```bash
git clone git://opencircuitdesign.com/netgen
cd netgen
./configure && make && sudo make install
```

#### Verify Netgen is Working

```bash
netgen --version
netgen
```

Expected: Netgen Tcl interactive shell opens.

📸 *Screenshot: `screenshots/05_netgen_launch.png`*

---

### 2.4 NGSpice

#### Installation

```bash
sudo apt install ngspice -y
```

#### Verify NGSpice is Working

```bash
ngspice --version
ngspice
```

Expected: NGSpice interactive simulator shell opens.

📸 *Screenshot: `screenshots/06_ngspice_launch.png`*

---

### 2.5 SKY130A PDK

#### Installation

```bash
git clone https://github.com/RTimothyEdwards/open_pdks.git
cd open_pdks
./configure --enable-sky130-pdk
make
sudo make install
```

#### Verify PDK Files

```bash
ls ~/Desktop/Physical_verification/open_pdks/sky130/sky130A/libs.tech/
ls ~/Desktop/Physical_verification/open_pdks/sky130/sky130A/libs.tech/magic/
ls ~/Desktop/Physical_verification/open_pdks/sky130/sky130A/libs.tech/netgen/
ls ~/Desktop/Physical_verification/open_pdks/sky130/sky130A/libs.tech/ngspice/
```

Expected: Technology files for Magic, Netgen, and NGSpice all present.

📸 *Screenshot: `screenshots/07_pdk_verify.png`*

#### Integration Check — Magic with SKY130A

```bash
magic -T ~/Desktop/Physical_verification/open_pdks/sky130/sky130A/libs.tech/magic/sky130A.tech
```

Inside Magic console:
```tcl
tech name     # should print: sky130A
```

📸 *Screenshot: `screenshots/08_magic_sky130.png`*

---

## 3. Lab 1 — CMOS Inverter Physical Verification

### Inverter Specifications

| Parameter | NFET (M1) | PFET (M2) |
|---|---|---|
| Model | sky130_fd_pr__nfet_01v8 | sky130_fd_pr__pfet_01v8 |
| Width (W) | 4.5 µm | 3 µm |
| Length (L) | 0.18 µm | 0.18 µm |
| Fingers (nf) | 3 | 3 |
| Body | VSS | VDD |

---

### 3.1 Schematic — Xschem

The CMOS inverter schematic was created in Xschem using the SKY130A NFET and PFET devices. A custom symbol was also created for the inverter subcircuit so it could be instantiated in the testbench.

```bash
cd Lab1_inverter/xschem
xschem inverter_1.sch
```

📸 *Screenshot: `screenshots/09a_schematic.png`*
#### Symbol Creation

After creating the inverter schematic, a symbol was created for the `inverter_1` subcircuit and its pins were configured for VDD, input, output, and VSS.

📸 *Screenshot: `screenshots/09b_symbol.png`*

The schematic was netlisted in Xschem, and the generated SPICE netlist was saved.

**Netlist generated:**

```spice
.subckt inverter_1 vdd in out vss
XM1 out in vss vss sky130_fd_pr__nfet_01v8 L=0.18 W=4.5 nf=3
XM2 out in vdd vdd sky130_fd_pr__pfet_01v8 L=0.18 W=3 nf=3
.ends
```


### 3.2 Schematic Testbench — Pre-Layout Simulation

Before drawing the layout, the schematic was simulated to confirm correct inverter behavior using NGSpice.

#### Testbench Circuit — `xschem/inverter_1_tb.sch`

The testbench was drawn in Xschem with:
- `V1 = 1.8V` DC supply
- `V2` = PULSE input
- `inverter_1` subcircuit instantiated


**Observation:** Output is correct logic complement of input ✅

📸 *Screenshot: `screenshots/10_tb_schematic.png`*
📸 *Screenshot: `screenshots/11_prelayout_simulation.png`*

---

### 3.3 Layout — Magic VLSI

```bash
cd Lab1_inverter/mag
magic -T /us
```

#### Import the SPICE Netlist

Import the SPICE netlist generated from the Xschem schematic to create the physical layout in Magic.

Inside the Magic console, import the schematic SPICE netlist:

```tcl
readspice ../xschem/inverter_1.spice

```

Layout details:
- NFET placed with VSS rail at bottom
- PFET placed with VDD rail at top
- 3-finger layout for both devices
- Metal2 jumper used

📸 *Screenshot: `screenshots/12_layout.png`*

---

### 3.3 DRC — Design Rule Check

Inside Magic console:

```tcl
drc check
drc count
drc why
```

**Result:**
```
DRC errors: 0 ✅
```

📸 *Screenshot: `screenshots/13_drc_clean.png`*

---

### 3.4 Extraction from Magic

Inside Magic console:

```tcl
extract all
ext2spice lvs
ext2spice
```

---

### 3.5 LVS — Layout vs Schematic

```bash
cd Lab1_inverter/netgen
netgen -batch lvs \
  "../mag/inverter_1.spice inverter_1" \
  "../xschem/inverter_1.spice inverter_1" \
  /usr/share/pdk/sky130A/libs.tech/netgen/sky130A_setup.tcl \
  /tmp/inverter_1_lvs.log
cat /tmp/inverter_1_lvs.log
```

**Final result:**

```
sky130_fd_pr__nfet_01v8 (3->1)  |  sky130_fd_pr__nfet_01v8 (1)  ✅
sky130_fd_pr__pfet_01v8 (3->1)  |  sky130_fd_pr__pfet_01v8 (1)  ✅
Number of devices: 2             |  Number of devices: 2          ✅
Number of nets:    4             |  Number of nets:    4          ✅

Final result: Circuits match uniquely. ✅
```

📸 *Screenshot: `screenshots/14_lvs_match.png`*

---

### 3.6 LVS Debugging — Problems and Fixes

#### Problem 1 — Floating NFET source nodes (XM1/S1, XM1/S2)

**Error:**
```
Net: XM1/S1  →  (no matching net)
Net: XM1/S2  →  (no matching net)
Nets: 8 (layout) vs 4 (schematic)
```

**Root cause:**
A 3-finger NFET has 4 diffusion strips alternating Drain-Source-Drain-Source. The 2 inner source strips (S1, S2) were not connected to VSS, so Magic extracted them as separate floating nets instead of merging the 3 transistors into one.

**Fix:**
Added Metal1 contacts on both inner source strips of NFET and connected them to the VSS rail.

**Result:** NFET 3 separate devices → 1 merged device ✅

---

#### Problem 2 — Floating PFET source nodes (XM2/S1, XM2/S2)

**Same issue** — PFET inner source strips not connected to VDD.

**Extra challenge:**
S1 routing upward to VDD was blocked by D2 (drain connected to `out`). Routing Metal1 directly caused a short between `out` and `vdd`.

**Fix:**
Used Metal1 → Via1 → Metal2 → Via1 → Metal1 jumper to route over D2 without shorting.

**Result:** PFET 3 devices → 1 merged device ✅

---

#### Problem 3 — `out` net disappeared (nets: 3 vs 4)

**Error:**
```
Layout pins: vdd, in, vss   ← only 3 nets
(no pin, node is vdd)       ← out merged into vdd accidentally
```

**Root cause:**
During PFET drain reconnection, the outer drain strips (which should go to `out`) were accidentally wired to VDD, collapsing the `out` net entirely.

**Fix:**
Removed drain-to-VDD connection. Reconnected outer drain strips to `out` net. Re-placed `out` port label in Magic.

---

#### LVS Progression Summary

| Attempt | NFET | PFET | Nets L/S | Devices L/S | Status |
|---|---|---|---|---|---|
| Initial | 3→2 | 3→2 | 8 vs 4 | 4 vs 2 | ❌ |
| Fix NFET S1,S2 | 3→1 | 3→2 | 5 vs 4 | 3 vs 2 | ❌ |
| Fix PFET S2 only | 3→1 | 3→2 | 5 vs 4 | 3 vs 2 | ❌ |
| Drain shorted to VDD | 3→1 | 3→1 | 3 vs 4 | 2 vs 2 | ❌ |
| Fix drain + S1 via jumper | 3→1 | 3→1 | 4 vs 4 | 2 vs 2 | ✅ |

---


### 3.7 Post-Layout Simulation — NGSpice

After LVS sign-off, the Magic-extracted SPICE netlist (which includes parasitic capacitances from the actual layout) is simulated using the testbench below.

```spice
.lib "/home/ananya/Desktop/Physical_verification/open_pdks/sky130/sky130A/libs.tech/ngspice/sky130.lib.spice" tt

.include "inverter_1.spice"

VDD vdd 0 DC 1.8
VIN in 0 PULSE(0 1.8 0 100p 100p 5n 10n)

XINV vdd in out 0 inverter_1
CLOAD out 0 10f

.control
tran 10p 40n
plot V(in) V(out)
.endc
.end
```
#### Run

```bash

ngspice inv_tb.spice
```
|

**No. of Data Rows: 4053**

**Observation:**
- `in` HIGH → `out` LOW ✅
- `in` LOW → `out` HIGH ✅
s

#### Pre-Layout vs Post-Layout Comparison

| Parameter | Schematic Sim | Post-Layout Sim |
|---|---|---|
| Logic function | Correct inverter ✅ | Correct inverter ✅ |
| VDD | 1.8V | 1.8V |
| Input swing | 0 → 1.8V | 0 → 1.8V |
| Output swing | 1.8V → 0V | 1.8V → 0V |
| Parasitics | None (ideal) | Included (RC extracted) |

📸 *Screenshot: `screenshots/15_pre_vs_post_layout_simulation.png`*

---

## 4. Key Learnings

1. **Multi-finger FET connections:** Every diffusion strip must be explicitly wired. Magic extracts each floating strip as a separate net, breaking LVS.

2. **Metal2 jumper routing:** When Metal1 routing is blocked, Metal1→Via1→Metal2→Via1→Metal1 is the standard solution to cross over conflicting nets.

3. **LVS is diagnostic:** Net fanout counts in the LVS report precisely identify which connection is wrong, making debugging systematic.

4. **OS compatibility:** Ubuntu 26.04.1 caused build failures. Ubuntu 24.04.1 LTS provided a stable environment for all EDA tools.

---

## 5. Repository Structure

```
Physical-Verification-Sky130A/
├── README.md
├── Lab1_inverter/
│   ├── mag/
│   │   ├── inverter_1.mag
│   │   └── inverter_1.spice
│   ├── xschem/
│   │   ├── inverter_1.sch
│   │   └── inverter_1.spice
│   ├── netgen/
│   │   ├── run_lvs.sh
│   │   └── inverter_1_lvs.log
│   └── ngspice/
│       └── inv_tb.spice
└── screenshots/
    ├── 01_system_info.png
    ├── 02_git_setup.png
    ├── 03_magic_launch.png
    ├── 04_xschem_launch.png
    ├── 05_netgen_launch.png
    ├── 06_ngspice_launch.png
    ├── 07_pdk_verify.png
    ├── 08_magic_sky130.png
    ├── 09_schematic.png
    ├── 10_layout.png
    ├── 11_drc_clean.png
    ├── 12_lvs_match.png
    └── 13_simulation_waveform.png
```

---

## 6. References

- [SKY130A PDK Documentation](https://skywater-pdk.readthedocs.io/)
- [Magic VLSI User Guide](http://opencircuitdesign.com/magic/)
- [Netgen LVS Documentation](http://opencircuitdesign.com/netgen/)
- [Reference Repository — yathAg](https://github.com/yathAg/Physical_Verification_SKY130A)
- [VSD Physical Verification Workshop](https://www.vlsisystemdesign.com/)
