day15 :: (input: string) -> string, string
{
    map1 : [SIZE][SIZE]u8;
    map2 : [SIZE][SIZE*2]u8;
    x1, y1, x2, y2 := 0;

    for my: 0..SIZE-1
    {
        for mx: 0..SIZE-1
        {
            if input[0] == #char "@"
            {
                x1, y1 = mx, my;
                x2, y2 = mx*2, my;
                map1[my][mx] = #char ".";
                map2[my][mx*2+0] = #char ".";
                map2[my][mx*2+1] = #char ".";
            }
            else
            {
                map1[my][mx] = input[0];
                
                if input[0] ==
                {
                    case #char "."; map2[my][mx*2] = #char "."; map2[my][mx*2+1] = #char ".";
                    case #char "#"; map2[my][mx*2] = #char "#"; map2[my][mx*2+1] = #char "#";
                    case #char "O"; map2[my][mx*2] = #char "["; map2[my][mx*2+1] = #char "]";
                }
            }

            advance(*input);
        }

        advance(*input);
    }

    while input
    {
        if input[0] ==
        {
            case #char "<";
                move1(*map1, *x1, *y1, -1, +0);
                move2(*map2, *x2, *y2, -1, +0);
            case #char ">";
                move1(*map1, *x1, *y1, +1, +0);
                move2(*map2, *x2, *y2, +1, +0);
            case #char "^";
                move1(*map1, *x1, *y1, +0, -1);
                move2(*map2, *x2, *y2, +0, -1);
            case #char "v";
                move1(*map1, *x1, *y1, +0, +1);
                move2(*map2, *x2, *y2, +0, +1);
        }

        advance(*input);
    }

    part1, part2 := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-1   if map1[y][x] == #char "O" part1 += 100*y + x;
    for y: 0..SIZE-1 for x: 0..SIZE*2-1 if map2[y][x] == #char "[" part2 += 100*y + x;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 50;

move1 :: (map: *[SIZE][SIZE]u8, rx: *s64, ry: *s64, dx: s64, dy: s64)
{
    push :: (map: *[SIZE][SIZE]u8, x: s64, y: s64, dx: s64, dy: s64) -> bool
    {
        if map.*[y][x] == #char "." return true;
        if map.*[y][x] == #char "#" return false;

        // it's a box, so recurse to see if it can be pushed
        if !push(map, x+dx, y+dy, dx, dy) return false;
        map.*[y+dy][x+dx] = map.*[y][x];
        map.*[y][x] = #char ".";
        return true;
    }

    if push(map, rx.* + dx, ry.* + dy, dx, dy) rx.*, ry.* += dx, dy;
}

move2 :: (map: *[SIZE][SIZE*2]u8, rx: *s64, ry: *s64, dx: s64, dy: s64)
{
    Position :: struct { x: s64; y: s64; };

    can_push :: (to_push: *[..]Position, map: *[SIZE][SIZE*2]u8, x: s64, y: s64, dx: s64, dy: s64) -> bool
    {
        if map.*[y][x] == #char "." return true;
        if map.*[y][x] == #char "#" return false;

        // it's a box, so recurse to see if it can be pushed
        if dy == 0 // it's a left or right push
        {
            if !can_push(to_push, map, x+dx, y, dx, dy) return false;
            array_add(to_push, .{x, y});
            return true;
        }
        else // it's an up down push, we need to branch down two paths
        {
            other_x := x + ifx map.*[y][x] == #char "[" then 1 else -1;
            if !can_push(to_push, map,       x, y+dy, dx, dy) return false;
            if !can_push(to_push, map, other_x, y+dy, dx, dy) return false;
            found := false;
            for to_push.* if it.x == x && it.y == y { found = true; break; }
            if !found array_add(to_push, .{x, y});
            found = false;
            for to_push.* if it.x == other_x && it.y == y { found = true; break; }
            if !found array_add(to_push, .{other_x, y});
            return true;
        }
    }

    to_push : [..]Position;
    if can_push(*to_push, map, rx.* + dx, ry.* + dy, dx, dy)
    {
        for to_push
        {
            map.*[it.y+dy][it.x+dx] = map.*[it.y][it.x];
            map.*[it.y][it.x] = #char ".";
        }
        rx.*, ry.* += dx, dy;
    }
}