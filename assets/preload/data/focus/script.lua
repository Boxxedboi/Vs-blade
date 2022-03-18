-- Dialogue shit
local playDialogue = false;
local playedVideo = false;
function onStartCountdown()
	if not playedVideo and isStoryMode and not seenCutscene then -- Block the first countdown and play video cutscene
		startVideo('H');
		playDialogue = true;
		playedVideo = true;
		return Function_Stop;
	elseif playDialogue then -- Block the second countdown and start a timer of 0.8 seconds to play the dialogue
		playedVideo = true;
		playDialogue = false;
		playMusic('Spooky', 0, true);
		soundFadeIn(nil, 2);
		setProperty('inCutscene', true);

		setProperty('camGame.zoom', 0.65);
		runTimer('startZoom', 0.75);
		runTimer('startDialogue', 2.75);

		makeLuaSprite('blackTransition', nil, -500, -400);
		makeGraphic('blackTransition', screenWidth * 2, screenHeight * 2, '000000')
		addLuaSprite('blackTransition', true);
		return Function_Stop;
	end
	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', 'Kevin MacLeod - Darkest Child');
	elseif tag == 'startZoom' then
		doTweenZoom('camGameZoomTwn', 'camGame', getProperty('defaultCamZoom'), 2, 'quadInOut');
		doTweenAlpha('blackTransitionTwn', 'blackTransition', 0, 2, 'sineOut');
	elseif tag == 'endSongAgain' then
		endSong();
	elseif tag == 'startBlackTrans' then
		doTweenAlpha('blackTransitionEndTwn', 'blackTransition', 0.8, 6, 'sineOut');
	elseif tag == 'endSongBlackTrans' then
		doTweenAlpha('blackTransitionTwn', 'blackTransition', 0, 1, 'linear');
	end
end

function onTweenCompleted(tag)
	if tag == 'blackTransitionTwn' then
		removeLuaSprite('blackTransition');
	end
end


local xx = 520;
local yy = 450;
local xx2 = 820;
local yy2 = 650;
local ofs = 35;
local followchars = true;
local del = 0;
local del2 = 0;


function onUpdate()
	if del > 0 then
		del = del - 1
	end
	if del2 > 0 then
		del2 = del2 - 1
	end
    if followchars == true then
        if mustHitSection == false then
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else

            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
	    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
    else
        triggerEvent('Camera Follow Pos','','')
    end
    
end