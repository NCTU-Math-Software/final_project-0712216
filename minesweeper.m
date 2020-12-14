function minesweeper()
%game map setup
game = figure('Name','minesweeper','NumberTitle','off');
axis on
axis ij        %y-axis increase from up to down
axis square
axis([0 9 0 9])
for ii = 0:9
    xline(ii)
    yline(ii)
end
B = 0;x = 10;y = 10;
while (B ~= 1) || (x < 0) || (x > 9) || (y < 0) || (y > 9)
[x,y,B]=ginput(1);
end
x=ceil(x);
y=ceil(y);
%game setup
bomb_map = generate_game(x,y);
    %9*9*2 matrix, (~,~,1)for state, 0 is concealed, 1 is reveal, 2 is flag
    %(~,~,2)for content.0~8 is #bombs around ,9 is bomb
%see the answer
%show_answer(bomb_map)
% first click game play
bomb_map = reveal_block(bomb_map,x,y);
%figure(game) %delete-able
show_game(bomb_map)
%game play
while 1
[x,y,B]=ginput(1);
x=ceil(x);
y=ceil(y);
if (x > 0) && (x < 10) && (y > 0) && (y < 10)
if B == 3    %right click
    if bomb_map(y,x,1) == 0
        bomb_map(y,x,1) = 2;
    elseif bomb_map(y,x,1) == 2
        bomb_map(y,x,1) = 0;
    else
        continue
    end
end

if B == 1    %left click
    if bomb_map(y,x,1) == 0 && bomb_map(y,x,2) ~= 9
        bomb_map = reveal_block(bomb_map,x,y);
    elseif  bomb_map(y,x,1) == 0 && bomb_map(y,x,2) == 9
        bomb_map = show_bomb(bomb_map);
        show_game(bomb_map)
        disp('game over')
        break
    else
        continue
    end
end
show_game(bomb_map)
end
if win_judge(bomb_map)
    disp('you win')
    break
end
end
end
function bomb_map = generate_game(x,y)   %generate a new game, set up mines and numbers
bomb_map = zeros(9,9,2); 
ii = 1;
while ii < 11
    bombx = randi([1,9]);
    bomby = randi([1,9]);
    if ((bombx == y) && (bomby == x)) || (bomb_map(bombx,bomby,2) == 9)
        continue
    end
    bomb_map(bombx,bomby,2) = 9;
    ii = ii + 1;
end
for ii = 1:9
    for jj = 1:9
        if bomb_map(ii,jj,2) ~= 9 
            count = 0;
            if get_bomb_value(bomb_map,ii-1,jj-1) == 9
                count = count + 1;
            end
            if get_bomb_value(bomb_map,ii-1,jj) == 9
                count = count + 1;
            end
            if get_bomb_value(bomb_map,ii-1,jj+1) == 9
                count = count + 1;
            end
            if get_bomb_value(bomb_map,ii,jj-1) == 9
                count = count + 1;
            end
            if get_bomb_value(bomb_map,ii,jj+1) == 9
                count = count + 1;
            end
            if get_bomb_value(bomb_map,ii+1,jj-1) == 9
                count = count + 1;
            end
            if get_bomb_value(bomb_map,ii+1,jj) == 9
                count = count + 1;
            end
            if get_bomb_value(bomb_map,ii+1,jj+1) == 9
                count = count + 1;
            end
            bomb_map(ii,jj,2) = count;
        end
    end
end
end
function value = get_bomb_value(bomb_map,ii,jj)
try
    value = bomb_map(ii,jj,2);
catch
    value = 0;
end
end  %get the value in place
function show_answer(bomb_map)
figure('Name','answer','NumberTitle','off');
axis on
axis ij 
axis square
axis([0 9 0 9])
for ii = 0:9
    xline(ii)
    yline(ii)
end
for ii = 1:9
    for jj = 1:9
        if bomb_map(ii,jj,2) == 0
            text(jj-0.6,ii-0.5,'.')
        elseif bomb_map(ii,jj,2) == 9
            text(jj-0.6,ii-0.5,'O')
        else
            text(jj-0.6,ii-0.5,num2str(bomb_map(ii,jj,2)))
        end
    end
end
end  %for checking program
function bomb_map = reveal_block(bomb_map,x,y)
if x~=0 && x~= 10 && y~= 0 && y~= 10 && bomb_map(y,x,1) == 0
    bomb_map(y,x,1) = 1;
    if bomb_map(y,x,2) == 0
        bomb_map = reveal_block(bomb_map,x-1,y-1);
        bomb_map = reveal_block(bomb_map,x-1,y);
        bomb_map = reveal_block(bomb_map,x-1,y+1);
        bomb_map = reveal_block(bomb_map,x,y-1);
        bomb_map = reveal_block(bomb_map,x,y+1);
        bomb_map = reveal_block(bomb_map,x+1,y-1);
        bomb_map = reveal_block(bomb_map,x+1,y);
        bomb_map = reveal_block(bomb_map,x+1,y+1);
    end
end
end  %after every move, do one time revealing the block
function show_game(bomb_map)
txt = texlabel('psi');
for ii = 1:9
    for jj = 1:9
        if bomb_map(ii,jj,1) == 2
            text(jj-0.6,ii-0.5,txt)
        end
        if bomb_map(ii,jj,1) == 1
            if bomb_map(ii,jj,2) == 0
                text(jj-0.6,ii-0.5,'.')
            end
            if (bomb_map(ii,jj,2) > 0) && (bomb_map(ii,jj,2) < 9)
                text(jj-0.6,ii-0.5,num2str(bomb_map(ii,jj,2)))
            end
        end
    end
end
end  %after reavel, show player.
function bomb_map = show_bomb(bomb_map)
for ii = 1:9
    for jj = 1:9
        if bomb_map(ii,jj,2) == 9
            bomb_map(ii,jj,1) = 1;
        end
    end
end
end
function win = win_judge(bomb_map)
correct = 0;
unfind = 0;
for ii = 1:9
    for jj = 1:9
        if bomb_map(ii,jj,2) == 9 && bomb_map(ii,jj,1) == 2
            correct = correct + 1;
        end
        if bomb_map(ii,jj,1) == 0
            unfind = unfind + 1;
        end
    end
end
if correct == 10 && unfind == 0
    win = 1;
else
    win = 0;
end
end