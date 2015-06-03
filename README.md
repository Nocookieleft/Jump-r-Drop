# Project SP Tower
final project minor programming by Anna Dechering stdnr: 10288384

a basic game based to exercise timing and hand-eye coordination while tackling boredom. 
The player times the jumps of an avatar climbing a 2D tower with missing platforms. Should the player fall from the screen, the game ends. The higher the player might climb, the higher the score. 



Features 
---------
- single player gameplay
- live action with touch interface 
- pervasive highscores



Design
------

![player ground floor](doc/Tpic1.png) "Player moving on ground floor"

The game is played in portrait mode.
The avatar starts out moving at a constant speed from left to right. 
When the avatar reaches the end of the screen, he automatically turns direction-> moving from right to left.


![player jumps](doc/Tpic2.png) "Player jumps to climb platform"

As the player touches the screen, the avatar jumps. This way the player can 'climb' the platforms. His goal is to reach the highest platform possible and not fall from the screen.


![player bounces](doc/Tpic3.png) "Player bounces from block "


The avatar bounces back from both the borders of the screen, as well as the platforms above him (when timed poorly...). 
As the player progresses in the game, the screen will 'move' over the levels vertically.
Soon the ground floor will dissapear, leaving a gap in which the player might fall.


![player falls](doc/Tpic4.png) "Player falls - game ends"

Should the player fall and there is no lower platform the player could land on (in other words: the player falls and disappears from the edge of the screen), the game ends. 




Layout
-------
### Gameplay
- player class: 
 	a sprite that moves within the boundaries of the screen's width
 	at a constant speed 
- tile class: 
	a sprite generating at a constant distance (y) on the screen
	with a variable length 
- jump action:
	event that generates a jump animation when the user touches the screen
- (physicsBody):
	might need simulation of gravity to work on the player sprite

### Game Scenes
- highscores view
- main menu view
- current game view





Potential Problems
--------------------

- position of the screen: 
	the window should move along with the player according to its position (as the player climbs higher and higher)
- the (continuous) generating of the level by generating platform blocks:
	the platform sprite(s) should be placed at a constant distance from other blocks to provide the chance of climbing another platform.
	In other words: if the platform blocks are spaced too far from one another, the player cannot reach another platform and has no chance of ever progressing in the game.
- working with multiple game scenes: 
	moving from main menu to a new game or the highscores view


### Tackling PPs by:
- reading SpriteKit class
- working on a mechanism that renders a tile at a constant distance from another at a 'possible' place on the x-axis of the next 'y-row' ... 
- work on a mechanism that checks which places are deemed possible places to input the tile 
- try something completely different regarding the levels 



Related content
---------------
The game Crossy Road (based on the classic frogger) might help provide insights in the generation of sprites from outside the game frame
The game Doodle Jump seems to have quite similar gameplay. In this game you need to progress vertically over the levels by jumping from platform to platform as well. The difference here is that the avatar automatically jumps when it hits a platform. Doodle Jump also uses the gyroscope in the phone to steer the avatar in the desired direction. The avatar here can move to platforms as well and can move off the left and right edges of the screen to appear on the opposite side again. Doodle Jump is far more advanced game that handles nice graphics and a range of aspects (like enemies/fiends the player should avoid and bonus items the player should try to get) that this game will not include. The scope of this project is limited, as trying to make a first iOS game in more or less two weeks proves challenging enough. 



Schedule
---------

### Week 1

| Ma             | Di        | Wo            |  Do      | Vr    | 
|:--------------:|:---------:|:-------------:|:--------:|:-----:|
|writing proposal|pitch ideas| read sprite kit class| watch tuts | defined player class|


### Week 2

| Ma           | Di         | Wo            |  Do      | Vr    | 
|:------------:|:----------:|:-------------:|:--------:|:-----:|
|implement classes| debug |gameplay functional|implement game logic| debug|

### Week 3

Alpha Release!












