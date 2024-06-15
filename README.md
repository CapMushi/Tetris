Tetris Description: Tetris made in 16-bit assembly

Features:
- **Printing Shapes**: Functions to print different Tetris shapes at the top of the screen.
- **Upcoming Shapes**: Upcoming Shapes are displayed so player can make present decisions accordingly.
- **Scrolling Down**: Functionality to scroll shapes downwards on the screen.
- **Score Management**: Includes a function to increment the score.
- **Start Screen Animation**: Engaging animations and prompts when the game starts.
- **End Screen Animation**: Visual feedback and summary when the game ends.
- **Timer**: Timer of 5 minutes after which game ends

Controls:
ALT+ENTER on Dosbox for FULLSCREEN.
CTRL+F12 ON Dosbox to increase speed.
press any key on start screen.
  - **Left Arrow**: Move the current shape left.
  - **Right Arrow**: Move the current shape right.

Objective:

The objective of the game is to manipulate falling Tetriminos, shapes composed of blocks, to create a horizontal line blocks without gaps. When such a line is created, it clears from the screen, and any blocks above it fall into the cleared space. The player earns points for each line cleared. The game ends when the blocks reach the top of the screen.

Prerequisites:

- **Environment**: Suitable for x86 architecture emulators or real hardware.
- **Assembler**: NASM (Netwide Assembler) or compatible.
- **Emulator**: Suitable x86 emulator or environment (e.g., DOSBox).

### Running the Code

1. **Clone the repository**:
   git clone https://github.com/CapMushi/Tetris.git
   cd Tetris
2. Set up a dos environment such as using Dosbox
3. Mount your drive example: mount c c:\<path>
4. Complile the p.asm file example: nasm p.asm -o p.com
6. Execute the executable file example: p.com
     
