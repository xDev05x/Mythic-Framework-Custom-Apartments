<div align="center">

![Banner](https://r2.fivemanage.com/b8BG4vav9CjKMUdz6iKnY/mythic_banner_old.png)

# mythic-doors

### *Dynamic door lock and elevator management system*

**Doors • Elevators • Admin Tools**

![Lua](https://img.shields.io/badge/-Lua_5.4-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![FiveM](https://img.shields.io/badge/-FiveM-F40552?style=for-the-badge)
![MongoDB](https://img.shields.io/badge/-MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)

[Features](#-features) • [Config](#-configuration) • [Commands](#-commands)

</div>

---

## 📖 Overview

Handles all door locks and elevators across the server. Doors can be locked, unlocked, lockpicked, and restricted by job, character, or property data. Supports both static Lua configs and dynamic database-driven doors managed through the admin panel.

---

## ✨ Features

<div align="center">
<table>
<tr>
<td width="50%">

### Door Management
- **Dynamic Doors** — Create, edit, and delete doors from the admin panel at runtime
- **Lock Restrictions** — Restrict doors by job, character SID, or property data
- **Lockpicking** — Configurable lockpick support per door
- **Auto Lock** — Doors can automatically re-lock after a set time
- **Special Doors** — Proximity-based interaction for garages, fences, and sliding doors

</td>
<td width="50%">

### Elevators & Tools
- **Elevator System** — Multi-floor elevators with per-floor lock restrictions
- **Door Capture Tool** — Aim at any door in-game to capture its model and coordinates
- **Elevator Zone Capture** — Capture zone centers and teleport positions in-game
- **Database Migration** — One-command migration from static configs to MongoDB
- **Garage Keyfob** — F10 keybind for garage door interaction

</td>
</tr>
</table>
</div>

---

## ⚙️ Configuration

Door and elevator configs live in the `shared/` folder as static Lua files. Once migrated to the database, all management is done through the admin panel.

---

## 🎮 Commands

| Command | Args | Description |
|---------|------|-------------|
| `/migratedoors` | — | Migrate all static door configs to MongoDB. Safe to re-run (clears DB first). Requires admin. |
| `/migrateelevators` | — | Migrate all static elevator configs to MongoDB. Same behavior as above. Requires admin. |
| `/doorhelper` | — | Toggle the door creation helper tool (admin only) |

> After running migration commands, restart `mythic-doors` for changes to take effect.

---

## 📦 Dependencies

| Resource | Why |
|----------|-----|
| `mythic-base` | Core framework |
| `mythic-pwnzor` | Anti-cheat |
| `mythic-admin` | Admin panel UI for door/elevator management |

---

<div align="center">

[![Made for FiveM](https://img.shields.io/badge/Made_for-FiveM-F40552?style=for-the-badge)](https://fivem.net)
[![Mythic Framework](https://img.shields.io/badge/Mythic-Framework-208692?style=for-the-badge)](https://github.com/mythic-framework)

</div>
