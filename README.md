# 🎮 [Duhk Game]
[![4.6]()
[![Windows]()
A short metroidvania-platformer where you guide a lost duck to escape an airport.
---
## 🎮 How to Play
Download the .zip file and run the .exe
### **Installation / Execution**
* **Web Build:** [https://mangothefroot.itch.io/duhk-the-game]
* **Desktop Execution:** Download the latest release from the **Releases** tab,
extract the ZIP file, and run `[DuhkGame].exe`.
### **Controls**
* `W, A, S, D` / `Arrow Keys`: Move character
* `Spacebar`: Jump / Double Jump
* `Left Shift, Right Shift`: Dash
---
## 🎮 Production Team & System Ownership
### **🎮 [Oscar] — Player Lead**
* **System Ownership:** Core Mechanics, Physics Architecture, & Input Locomotion.
* **Key Deliverables:**
* `player.gd`: Handles 4-way movement vectors, velocity damping, and screen
clamping, and other advanced movement options
* Player scene configuration, input mapping registers, and character
collision meshes.
### **🎮 [Abby] — World Lead**
* **System Ownership:** AI Entities, Hazard Boundaries, & Level Layout.
* **Key Deliverables:**
* `world.tscn`: Desgined and built the whole level map
* `tiles.png`: Created tile textures for the level
* Environment static bodies, kill-zones, and boundary layouts.
### **🎮 [Drake] — Systems Lead**
* **System Ownership:** UI Canvas Systems, State Preservation, & Interface Flows.
* **Key Deliverables:**
* `coins.gd`: Created a system to make and collect coins
* `textures`: created textures for tiles and coins
---
## Known Issues
Documenting the known bugs so players don't get scared.
* **Bug 1:** If the rat enemy lands untop of the player, it will not be able to be removed and will continuously damage the player
* **Bug 2:** Rat enemy damage hitbox can clip through pipe walls to damage player
* **Git Conflict Resolution:** We went into the GitHub repo and manualy changed the conflict issue
---
## 🎮 Third-Party Asset Attributions
We would like to recognize the following creators for their open-source
contributions:
No third-party assets were used (to my knowledge)
