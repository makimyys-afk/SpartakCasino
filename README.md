# SpartakCasino

SpartakCasino is a professional and fully-featured casino application designed for **OpenComputers** within Minecraft, boasting a sophisticated graphical user interface (GUI) inspired by **MineOS**. This application provides an immersive gaming experience with three classic casino games, complete with elegant animations and an integrated balance system.

## Features

*   **Three Engaging Games:**
    *   **Slot Machine:** Features a 100-credit bet, a 1000-credit jackpot (x10), and five distinct symbols (7️⃣ 💎 🍒 ⭐ 🔔) with smooth spinning animations.
    *   **Roulette:** Offers a 200-credit bet, 400 credits (x2) for red/black, and 2000 credits (x10) for green, accompanied by realistic wheel animations.
    *   **Dice:** A simple game with a 150-credit bet, yielding 300 credits (x2) if the sum of the dice is greater than 7, featuring dice roll animations.
*   **Professional Design:**
    *   A polished GUI built on the MineOS framework.
    *   Luxurious visual assets including a logo, slot machine, roulette, dice, and background images.
    *   An elegant gold, red, and green color scheme.
    *   Smooth and fluid animations for an enhanced user experience.
    *   An integrated balance system displayed prominently on the screen.
    *   An intuitive and user-friendly interface.

## Tech Stack

The SpartakCasino application is built upon the following technologies:

*   **Lua:** The primary programming language used for the application logic.
*   **MineOS GUI:** A robust library providing the graphical interface framework.
*   **OpenComputers:** A Minecraft mod that enables in-game programmable computers, serving as the platform for this application.

## Installation & Setup

### Requirements:

To run SpartakCasino, ensure your OpenComputers setup meets these requirements:

*   **OpenComputers** (Minecraft 1.7.10)
*   **MineOS** installed on your computer
*   **Tier 2+** components (CPU, GPU, RAM, Screen)
*   **Internet Card** (required for installation via GitHub)

### Installation Methods:

#### Method 1: Via MineOS App Market (Recommended)

1.  Launch MineOS.
2.  Open the **App Market**.
3.  Search for **SpartakCasino**.
4.  Click **Install**.

#### Method 2: Manual Installation

1.  **Download via `wget`:**
    ```lua
    wget -f https://raw.githubusercontent.com/makimyys-afk/SpartakCasino/main/install.lua /tmp/install.lua && /tmp/install.lua
    ```
2.  **Alternatively, clone the repository:**
    ```bash
    cd /MineOS/Applications/
    git clone https://github.com/makimyys-afk/SpartakCasino.git
    ```
3.  Restart MineOS or refresh your application list to see SpartakCasino.

## Usage

1.  Start MineOS.
2.  Locate the **SpartakCasino** icon on your desktop.
3.  Click the icon to launch the application.
4.  Select your desired game from the main menu.
5.  Enjoy the casino experience!

### Controls:

*   **Left Mouse Click:** Used for selecting buttons and interacting with the interface.
*   **ESC Key:** Closes the current game window.
*   Your current balance is displayed at the top of the screen.

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.