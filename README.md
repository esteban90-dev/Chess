# Chess

## Overview

This is the final project of [The Odin Project's](https://www.theodinproject.com) [Ruby course](https://www.theodinproject.com/courses/ruby-programming).  It is a basic chess game played between two players in the command prompt.  The project requirements can be found here: https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project

## Class Design

To facilitate the design of the various classes in the project I sketched up UML sequece diagrams that can be found in `./reference` to explore the messaging between objects.  

- Board: The purpose of the Board is to keep track of pieces on an 8x8 grid, move the pieces around, and maintain a history of moves.  The Board also calculates check, checkmate, stalemate, and whether or not a piece is eligible for a promotion. To avoid concerning the Board too much with the logic of the individual pieces, the Board simply sends itself to the pieces, and they determine where on the Board they can move.  
- Piece: Piece is the class that all the individual pieces (i.e. Pawn, Rook, Bishop, etc.) inherit from.  Each piece is responsible for taking a Board object and determining where it can legally move.
- Game: The Game class has a Board full of Pieces, and has the purpose of running the game loop, managing the turns of the players, and announcing the end of a game.  Additionally, the Game implements saving and loading.

Sandi Metz's [Practical Object Oriented Design](https://www.poodr.com/) was a big help in understanding object oriented design best practices.  

## Testing

In general, a loose TDD approach was followed.  Most classes have test coverage for their public interfaces, especially the Board and Pieces, the classes that contain the most complex logic.  Unit tests were written for object interfaces that did not greatly depend on interaction with other objects, and those tests can be found in the specs that bear the name of the object. For interfaces that did have complex interactions between multiple objects, i.e. moving a Piece on the Board, those 'integration' tests were written in their own 'board-piece' spec. Every type of move is covered by tests. There are tests for checkmate and stalemate too, but more examples of these could be added in the future. The game loop itself was tested manually. By the end of the project, all tests were passing.  Tests can be found in the /spec folder. 

## How to Play

- You can play live on Repl.it: https://repl.it/@esteban90/Chess#main.rb
- Alternatively, you can clone this repo to your machine: `git clone https://github.com/esteban90-dev/Chess.git`  Run the game by entering `./ruby main.rb`
