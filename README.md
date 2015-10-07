Project: Chess

Link: [Project: Chess](http://www.theodinproject.com/ruby-programming/ruby-final-project)

Description: A Command Line Interface of [Chess](https://en.wikipedia.org/wiki/Chess). Regular and Special moves are included within the game's logic. Save and Load functionality also included. Users can can at anytime during a game and resume playing later. 

Author(s): Thomas Pan

Instructions: Run game with `$ruby example/example_game.rb`. 

###Gameplay

```
Game menu has four options: (l)oad a game, (s)tart a new game, (d)elete a game, or (q)uit. 

Enter first the first letter of the option to proceed. 

#### Load/Delete ####

Load or Delete a saved game by entering the file name. Ex. game_01.yaml


#### Save ####

Save a game by entering the file name without file format. Ex. game_01


#### Start ####

A player will be randomly selected to go first. 

To make a move, first select a piece by entering the coordinates. i.e. `a2`
After, select the coordinate where you want to move the piece. i.e. `a4`

Game will prompt user to try again if move is invalid. 
Game will notify if a player is in check, and the game will end when a player is check mated. 

    A   B   C   D   E   F   G   H
8 [RB][kB][BB][QB][KB][BB][kB][RB]
7 [PB][PB][PB][PB][PB][PB][PB][PB]
6 [  ][  ][  ][  ][  ][  ][  ][  ]
5 [  ][  ][  ][  ][  ][  ][  ][  ]
4 [  ][  ][  ][  ][  ][  ][  ][  ]
3 [  ][  ][  ][  ][  ][  ][  ][  ]
2 [PW][PW][PW][PW][PW][PW][PW][PW]
1 [RW][kW][BW][QW][KW][BW][kW][RW]

White Player's Move:
d2
d4

    A   B   C   D   E   F   G   H
8 [RB][kB][BB][QB][KB][BB][kB][RB]
7 [PB][PB][PB][PB][PB][PB][PB][PB]
6 [  ][  ][  ][  ][  ][  ][  ][  ]
5 [  ][  ][  ][  ][  ][  ][  ][  ]
4 [  ][  ][  ][PW][  ][  ][  ][  ]
3 [  ][  ][  ][  ][  ][  ][  ][  ]
2 [PW][PW][PW][  ][PW][PW][PW][PW]
1 [RW][kW][BW][QW][KW][BW][kW][RW]

Black Player's Move:
f7
f5

```
