day22 :: (input: string) -> string, string
{
    map, moves, x := parse_input(input);
    password_2d := walk(map, moves, x, wrap_2d);
    password_3d := walk(map, moves, x, wrap_3d);
    return tprint("%", password_2d), tprint("%", password_3d);
}

#scope_file

walk :: (map: []string, moves: []s64, _x: s64, wrap: ([]string, s64, s64, s64, s64) -> (s64, s64, s64, s64)) -> s64
{
    x, y, dx, dy := _x, 0, 1, 0;

    for move, move_index: moves
    {
        if move_index % 2 == 0
        {
            for 1..move
            {
                // hitting the edge
                if x + dx >= map[y].count || x + dx < 0 || map[y][x + dx] == #char " " ||
                   y + dy >= map.count    || y + dy < 0 || map[y + dy].count < x || map[y + dy][x] == #char " "
                {
                    x, y, dx, dy = wrap(map, x, y, dx, dy);
                }
                // successfully moving
                else if map[y + dy][x + dx] == #char "."
                {
                    x += dx;
                    y += dy;
                }
                // hitting a wall
                else
                {
                    break;
                }
            }
        }
        else
        {
            if move == #char "L"
            {
                if dx == 0 { dx =  dy; dy = 0; }
                else       { dy = -dx; dx = 0; }
            }
            else
            {
                if dx == 0 { dx = -dy; dy = 0; }
                else       { dy =  dx; dx = 0; }
            }
        }
    }

    password := 1000*(y+1) + 4*(x+1);
    if      dy ==  1 password += 1;
    else if dx == -1 password += 2;
    else if dy == -1 password += 3;

    return password;
}

wrap_2d :: (map: []string, x: s64, y: s64, dx: s64, dy: s64) -> s64, s64, s64, s64
{
    next_x := x;
    next_y := y;

    if dx == 1
    {
        for 0..map[y].count-1
        {
            if map[y][it] != #char " "
            {
                next_x = it;
                break;
            }
        }

        if map[y][next_x] == #char "#"
        {
            next_x = x;
        }
    }
    else if dx == -1
    {
        next_x = map[y].count - 1;

        if map[y][next_x] == #char "#"
        {
            next_x = x;
        }
    }
    else if dy == 1
    {
        next_y = 0;

        for 0..map.count-1
        {
            if map[it][x] != #char " "
            {
                next_y = it;
                break;
            }
        }

        if map[next_y][x] == #char "#"
        {
            next_y = y;
        }
    }
    else if dy == -1
    {
        next_y = 0;

        for < map.count-1..0
        {
            if map[it].count >= x && map[it][x] != #char " "
            {
                next_y = it;
                break;
            }
        }

        if map[next_y][x] == #char "#"
        {
            next_y = y;
        }
    }

    return next_x, next_y, dx, dy;
}

wrap_3d :: (map: []string, x: s64, y: s64, dx: s64, dy: s64) -> s64, s64, s64, s64
{
    /*  0 1 2
          _ _
    0    |e|f|
    1   _|d|
    2  |b|c|
    3  |a|
    */

    side_x  := x / 50;
    side_y  := y / 50;
    rel_x   := x % 50;
    rel_y   := y % 50;
    next_x  := x;
    next_y  := y;
    next_dx := dx;
    next_dy := dy;

    if dx == 1 && side_x == 2 && side_y == 0 // f to c
    {
        next_x  = 99;
        next_y  = (49 - rel_y) + 100;
        next_dx = -1;
    }
    else if dx == 1 && side_x == 1 && side_y == 1 // d to f
    {
        next_x  = rel_y + 100;
        next_y  = 49;
        next_dx = 0;
        next_dy = -1;
    }
    else if dx == 1 && side_x == 1 && side_y == 2 // c to f
    {
        next_x  = 149;
        next_y  = 49 - rel_y;
        next_dx = -1;
    }
    else if dx == 1 && side_x == 0 && side_y == 3 // a to c
    {
        next_x  = rel_y + 50;
        next_y  = 149;
        next_dx = 0;
        next_dy = -1;
    }
    else if dx == -1 && side_x == 1 && side_y == 0 // e to b
    {
        next_x  = 0;
        next_y  = (49 - rel_y) + 100;
        next_dx = 1;
    }
    else if dx == -1 && side_x == 1 && side_y == 1 // d to b
    {
        next_x  = rel_y;
        next_y  = 100;
        next_dx = 0;
        next_dy = 1;
    }
    else if dx == -1 && side_x == 0 && side_y == 2 // b to e
    {
        next_x  = 50;
        next_y  = 49 - rel_y;
        next_dx = 1;
    }
    else if dx == -1 && side_x == 0 && side_y == 3 // a to c
    {
        next_x  = rel_y + 50;
        next_y  = 0;
        next_dx = 0;
        next_dy = 1;
    }
    else if dy == 1 && side_x == 2 && side_y == 0 // f to d
    {
        next_x  = 99;
        next_y  = rel_x + 50;
        next_dx = -1;
        next_dy = 0;
    }
    else if dy == 1 && side_x == 1 && side_y == 2 // c to a
    {
        next_x  = 49;
        next_y  = rel_x + 150;
        next_dx = -1;
        next_dy = 0;
    }
    else if dy == 1 && side_x == 0 && side_y == 3 // a to f
    {
        next_x  = rel_x + 100;
        next_y  = 0;
    }
    else if dy == -1 && side_x == 2 && side_y == 0 // f to a
    {
        next_x  = rel_x;
        next_y  = 199;
    }
    else if dy == -1 && side_x == 1 && side_y == 0 // e to a
    {
        next_x  = 0;
        next_y  = rel_x + 150;
        next_dx = 1;
        next_dy = 0;
    }
    else if dy == -1 && side_x == 0 && side_y == 2 // b to d
    {
        next_x  = 50;
        next_y  = rel_x + 50;
        next_dx = 1;
        next_dy = 0;
    }

    if map[next_y][next_x] == #char "."
    {
        return next_x, next_y, next_dx, next_dy;
    }

    return x, y, dx, dy;
}

parse_input :: (input: string) -> []string, []s64, s64
{
    parts := split(input, "\n\n");
    map  := split(parts[0], "\n");
    moves : [..]s64;

    while true
    {
        array_add(*moves, read_s64(*parts[1]));
        if !parts[1] break;
        array_add(*moves, parts[1][0]);
        advance(*parts[1]);
    }

    x := 0;

    for 0..map[0].count-1
    {
        if map[0][it] == #char "."
        {
            x = it;
            break;
        }
    }

    return map, moves, x;
}