# Overview
This is a procedural dungeon generator for Godot Engine that creates Binding of Isaac-style rooms and layouts. The system generates random dungeon levels with interconnected rooms, including special room types (start, boss, treasure, etc.) and ensures all rooms are accessible.

# Features
Procedural generation of dungeon layouts

Multiple room types (normal, start, boss, treasure)

Configurable generation parameters (room count, size, has neighbours, etc.)

Customizable room templates

Customizable enemies templates

# Installation
Download or clone this repository

Copy the dungeon_generator folder to your Godot project

# Usage
Basic setup:
drag res://scenes/prefabs/room_generator/room_generator.tscn into the main scene 

# Customization

### Adjusting Room Generation
edit parameters in res://scenes/prefabs/room_generator/room_generator.tscn 

### Adding New Rooms
Add room scenes to res://scenes/prefabs/rooms/...
(Note that if it is room with normal enemies it must have TileMapLayer named "Enemies", if it is boss room it must have TileMapLayer named "Enemies" and "Entrence")
and load them and append them to array in res://scripts/room_generation/room_list.gd script
in function pick_interior(type, level) in the same script, you can edit what room is returned based of room's type and level

# Examples
![dugeon_generator](https://github.com/user-attachments/assets/2d00246e-8053-43bd-adfc-ce9eacf8beae)

# Dependencies
Godot 4.0 or later

# License
MIT License

# Contributing
Contributions are welcome! Please open an issue or pull request for any bugs or feature requests.

# Support
If you have questions or need help, please open an issue on GitHub.
