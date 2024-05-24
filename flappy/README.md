# Flappy (Fifty) Bird

## Known issues

### Frame rate


#### Description
The game works perfectly at 60FPS but will be unplayable at higher frame rates (i.e.: 240FPS). I haven't found the way to solve it yet, since `dt` seems to be used correctly in `Bird`'s `update` method.

#### Workaround
Set your monitor refresh rate to 60Hz. Since the game has `vsync` turned on, it will be capped at 60FPS.
