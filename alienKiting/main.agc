
// Project: psychicQuest 
// Created: 2024-03-12

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "Kiting the Alien" )
SetWindowSize( 1280, 800, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1280, 800 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 120, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

LoadImage(1, "ship.png")
LoadImage(2, "coin.png")
LoadImage(3, "alien.png")
LoadImage(4, "coin2.png")

LoadSound(100, "collect.wav")
LoadSound(101, "win.wav")
LoadSound(102, "loss.wav")
LoadSound(103, "levelUp.wav")
LoadSound(104, "home.wav")
LoadSound(105, "main.wav")

ame = 1
ameX = 640
ameY = 400

coin = 2
coinX = 800
coinY = 450

alien = 3
alienX = 200
alienY = 400

coin2 = 4

score = 0
highscore = 0

time = 60
times = time

game = 1

screenWidth = GetDeviceWidth()
screenHeight = GetDeviceHeight()

Gosub Make_stars

CreateSprite(ame, 1)
CreateSprite(coin, 2)
CreateSprite(alien, 3)
CreateSprite(coin2, 4)

SetSpritePosition(coin2, 30, 730)
SetSpritePosition(ame, ameX, ameY)
SetSpritePosition(coin, coinX, coinY)
SetSpritePosition(alien, alienX, alienY)

CreateText(99, "")
setTextSize(99, 55)
SetTextPosition(99, 440, 440)

CreateText(98, "")
setTextSize(98, 50)
SetTextPosition(98, 530, 730)

CreateText(97, "")
SetTextSize(97, 40)
SetTextPosition(97, 10, 20)

CreateText(96, "")
SetTextSize(96, 150)
SetTextPosition(96, 170, 80)

CreateText(95, "")
SetTextSize(95, 40)
SetTextPosition(95, 730, 10)

CreateText(94, "")
SetTextSize(94, 60)
SetTextColor(94, 255, 255, 0, 900)
SetTextPosition(94, 85, 725)

CreateText(93, "")
SetTextSize(93, 80)
SetTextPosition(93, 600, 710)

if game = 1
	PlaySound(104)
endif

do
		select game
		case 1
		SetSpriteVisible(1, 0)
		SetSpriteVisible(2, 0)
		SetSpriteVisible(3, 0)
		SetSpriteVisible(4, 0)
		SetTextVisible(99, 1)
		SetTextVisible(98, 1)
		SetTextVisible(97, 0)
		SetTextVisible(96, 1)
		SetTextVisible(95, 0)
		SetTextVisible(94, 0)
		SetTextVisible(93, 0)
		
		
		SetTextString(96, "KITING THE ALIEN")
		SetTextString(99, "Press 'space' to start")
		SetTextString(98, "Highscore: " + str(highscore))
		
		if GetRawKeyPressed(32) = 1
			StopSound(104)
			PlaySound(105)
			ameX = 640
			ameY = 400
	
			alienX = 200
			alienY = 400
	
			score = 0
			ResetTimer()
			game = 2
		endif
		endcase
		
		case 2
		if score > highscore
			highscore = score
		endif
		SetSpriteVisible(1, 1)
		SetSpriteVisible(2, 1)
		SetSpriteVisible(3, 1)
		SetSpriteVisible(4, 1)
		SetTextVisible(99, 0)
		SetTextVisible(98, 0)
		SetTextVisible(97, 1)
		SetTextVisible(96, 0)
		SetTextVisible(94, 1)
		SetTextVisible(93, 1)
		
		SetTextString(94, str(score))
		
		gosub death
		gosub Move_stars
		gosub coincollect
		gosub moveplayer
		gosub win
		gosub enemy
		gosub gametimer
		gosub corner
		gosub quit
		endcase 
		
		endselect
    Sync()
loop

moveplayer:
if score < 5
	if GetRawKeyState(87)
	ameY = ameY - 5
	endif
	if GetRawKeyState(83)
	ameY = ameY + 5
	endif
	if GetRawKeyState(65)
	ameX = ameX - 5
	endif
	if GetRawKeyState(68)
	ameX = ameX + 5
	endif
else
SetTextString(97, "Press 'SHIFT' + w/a/s/d to move faster")
if GetRawKeyState(16)
	if GetRawKeyState(87)
	ameY = ameY - 10
	endif
	if GetRawKeyState(83)
	ameY = ameY + 10
	endif
	if GetRawKeyState(65)
	ameX = ameX - 10
	endif
	if GetRawKeyState(68)
	ameX = ameX + 10
	endif
else
	if GetRawKeyState(87)
	ameY = ameY - 5
	endif
	if GetRawKeyState(83)
	ameY = ameY + 5
	endif
	if GetRawKeyState(65)
	ameX = ameX - 5
	endif
	if GetRawKeyState(68)
	ameX = ameX + 5
	endif
endif
endif

SetSpritePosition(ame, ameX, ameY)
return

enemy:
if times - timel < 41
	SetTextString(95, "Be careful, the alien move faster now!")
	SetTextVisible(95, 1)
	if alienX < ameX
	alienX = alienX + 4
	endif
	if alienX > ameX
	alienX = alienX - 4
	endif
	if alienY < ameY
	alienY = alienY + 4
	endif
	if alienY > ameY
	alienY = alienY - 4
	endif
else
	if alienX < ameX
	alienX = alienX + 2
	endif
	if alienX > ameX
	alienX = alienX - 2
	endif
	if alienY < ameY
	alienY = alienY + 2
	endif
	if alienY > ameY
	alienY = alienY - 2
	endif
endif
SetSpritePosition(alien, alienX, alienY)
return

quit:
if GetRawKeyPressed(27) = 1
	game = 1
	PlaySound(104)
	StopSound(105)
endif
return

coincollect:
if GetSpriteCollision(ame, coin) = 1
	score = score + 1
	if score = 5
		PlaySound(103)
	else
		PlaySound(100)
	endif
	coinX = random(100, 1200)
	coinY = random(100, 700)
	SetSpritePosition(coin, coinX, coinY)
endif
return

gametimer:
timel as integer
timel = timer()
SetTextString(93,str(times - timel) + "s")
return

death:
if GetSpriteCollision(ame, alien) = 1
	game = 1
	PlaySound(102)
	PlaySound(104)
	StopSound(105)
endif
return

win:
if times - timel = 0
	game = 1
	PlaySound(101)
	PlaySound(104)
	StopSound(105)
endif
return

corner:
	spriteX = GetSpriteX(ame)
    spriteY = GetSpriteY(ame)
    spriteWidth = GetSpriteWidth(ame)
    spriteHeight = GetSpriteHeight(ame)
    
    // Prevent crossing the left border
    if spriteX < 0
        SetSpriteX(ame, 0)
    endif
    
    // Prevent crossing the right border
    if spriteX + spriteWidth > screenWidth
        SetSpriteX(ame, screenWidth - spriteWidth)
    endif
    
    // Prevent crossing the top border
    if spriteY < 0
        SetSpriteY(ame, 0)
        
    endif
    
    // Prevent crossing the bottom border
    if spriteY + spriteHeight > screenHeight
        SetSpriteY(ame, screenHeight - spriteHeight)
    endif
return



























Make_stars:
CreateImageColor(5, 255,255,255,255)
for i=1 to 100
	CreateSprite(i+5,5)
	SetSpriteSize(i+5,2,2)
	SetSpritePosition(i+5, random(1, 1280), random(1, 800))
next i
return

Move_stars:
for i=1 to 100
	StarX = GetSpriteX(5+i)-1
	if StarX<0
		StarX=1280
	endif
	SetSpritePosition(i+5, StarX, GetSpriteY(i+5))
next i
return
