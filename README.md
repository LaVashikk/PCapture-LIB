<div align="center">
<img src="other\logo.png" alt="Logo" width="660" height="350">

<h2 align="center">
    Unleash the Full Potential of Portal 2 Scripting with PCapture-Lib!
</h2>
</div>

![version](https://img.shields.io/badge/Pcapture--Lib-v3.7--Stable-%23FFA500?style=flat-square&logo=github&link=https%3A%2F%2Fgithub.com%2FIaVashik%2FPCapture-LIB)

**PCapture-Lib v3.7 is a groundbreaking VScripts library for Portal 2, empowering modders to create truly innovative and immersive gameplay experiences.**  It offers a most powerful suite of tools and enhancements, simplifying complex scripting challenges and allowing you to focus on bringing your creative vision to life. Whether you're a seasoned modder or just starting out, PCapture-Lib will elevate your mod projects to the next level.

---

<h1 style="border-bottom: none;">Killer Features</h1>
<details>

* **Advanced Ray Tracing with Portal Support:** Seamlessly integrate portal interactions into your raycasts with `TracePlus.PortalBbox` (precise) and `TracePlus.PortalCheap` (fast). This game-changing feature opens up a world of possibilities for portal-based mechanics, previously unattainable with standard VScripts.

* **Optimized Bounding Box TraceCasting:** Perform highly efficient collision detection with `TracePlus.Bbox`, utilizing advanced techniques like segment-based search, entity filtering and caching, and optional binary refinement. This ensures smooth performance even in complex map scenarios.

* **Powerful `CBaseEntity` Wrapper:** The `pcapEntity` class, accessible through `entLib`, provides an extensive set of methods for manipulating entity properties, controlling animations, handling sounds, managing outputs and inputs, and much more. This dramatically simplifies entity scripting and allows for advanced entity control.

* **Asynchronous Event Scheduling:** The `ActionScheduler` module offers a robust event scheduling system with support for delayed actions, intervals, and asynchronous operations using the `yield` keyword. This allows for more flexible and responsive scripting compared to standard VScripts mechanisms.

* **Enhanced Data Structures:** Leverage powerful data structures like `ArrayEx`, `List`, and `AVLTree` from the `IDT` module to manage and manipulate data efficiently. These additions provide significant improvements over standard VScripts arrays and offer more flexibility for complex data handling.

* **Comprehensive Math Module:** Utilize a rich set of mathematical functions and objects, including quaternions (`Quaternion`), matrices (`Matrix`), linear interpolation (`lerp`), and easing functions (`ease`), for complex calculations and animations.

* **File Operations and Utilities:** Streamline file reading and writing with the `File` class and access various utility functions for tasks like logging, player hooks, portal management, and more.

* **Entity Script Animations:** Easily create smooth animations for entity alpha (opacity), color and etc. using functions like `AlphaTransition`, `ColorTransition`, `PositionTransition`... Real-time animation variants are also available for more dynamic control.

* **HUD Elements:** Create custom HUD elements like screen text (`ScreenText`) and instructor hints (`HintInstructor`) to provide feedback and guidance to players.

### And more! You can find the whole list [here](Short_Documentation.md)

</details>

---

# Getting Started

There are two ways to install **PCapture-Lib**: you can download the latest release (recommended) or install directly from the source.

## Installation from Release (Recommended)

1. **Download:** Get the latest release from the [Releases](https://github.com/IaVashik/PCapture-LIB/releases) page.
2. **Copy:** Extract and copy the `PCapture-Lib.nut` file into your Portal 2 VScripts directory:  
   `Portal 2/portal2/scripts/vscripts/` 
   *Note: Although you can place the file in any subdirectory within `vscripts`, placing it directly in `vscripts` helps avoid confusion for beginner developers.*
3. **Initialization:** In your VScripts, include the library using:
   ```lua
   DoIncludeScript("PCapture-Lib", getroottable())
   ```

## Installation from Source

1. **Clone:** Clone the repository into your Portal 2 scripts directory:  
   `Portal 2/portal2/scripts/vscripts/` 
2. **Initialization:** In your VScripts, include the library using:
   ```lua
   IncludeScript("PCapture-Lib/SRC/PCapture-Lib")
   ```

## Documentation

[Short_Documentation.md](Short_Documentation.md) provides a quick overview of available methods for each module. For detailed explanations, including argument descriptions and code examples, refer to the `readme.md` files inside `SRC/*/readme.md`. Each module section in *Short_Documentation* contains anchors linking to its detailed documentation.


# About

PCapture-Lib was originally developed as part of the Project Capture modification, but it has evolved into a standalone library to benefit the entire Portal 2 modding community. By addressing common scripting challenges and providing powerful tools, PCapture-Lib aims to empower modders of all levels to create more ambitious and innovative maps.

## Contributing

Contributions to PCapture-Lib are welcome and encouraged! If you encounter any bugs, have feature requests, or would like to contribute code improvements, please open an issue or submit a pull request on the [GitHub repository](https://github.com/iaVashik/PCapture-LIB/).

## License

This library was created by [laVashik](https://lavashik.lol/). **Credit is required when using this library in your projects**

Licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.