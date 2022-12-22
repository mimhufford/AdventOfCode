day22 :: (input: string) -> string, string
{
    map, moves, x := parse_input(input);
    password_2d := walk_2d(map, moves, x);
    password_3d := walk_3d(map, moves, x);
    return tprint("%", password_2d), tprint("%", password_3d);
}

#scope_file


walk_3d :: (map: []string, moves: []s64, _x: s64) -> s64
{
    /*  0 1 2
          _ _
    0    |e|f|
    1   _|d|
    2  |b|c|
    3  |a|
    */

    x, y, dx, dy := _x, 0, 1, 0;
    
    for move, move_index: moves
    {
        if move_index % 2 == 0
        {
            for 1..move
            {
                // horizontal move
                if dx != 0
                {
                    // going right and hitting the edge
                    if dx == 1 && x + dx >= map[y].count
                    {
                        side_x  := x / 50;
                        side_y  := y / 50;
                        rel_x   := x % 50;
                        rel_y   := y % 50;
                        next_x  := x;
                        next_y  := y;
                        next_dx := dx;
                        next_dy := dy;

                        if side_x == 2 && side_y == 0 // f to c
                        {
                            next_x  = 99;
                            next_y  = (49 - rel_y) + 100;
                            next_dx = -1;
                        }
                        else if side_x == 1 && side_y == 1 // d to f
                        {
                            next_x  = rel_y + 100;
                            next_y  = 49;
                            next_dx = 0;
                            next_dy = -1;
                        }
                        else if side_x == 1 && side_y == 2 // c to f
                        {
                            next_x  = 149;
                            next_y  = 49 - rel_y;
                            next_dx = -1;
                        }
                        else if side_x == 0 && side_y == 3 // a to c
                        {
                            next_x  = rel_y + 50;
                            next_y  = 149;
                            next_dx = 0;
                            next_dy = -1;
                        }
                        else
                        {
                            assert(false);
                        }

                        if map[next_y][next_x] == #char "."
                        {
                            x  = next_x;
                            y  = next_y;
                            dx = next_dx;
                            dy = next_dy;
                        }
                        else
                        {
                            assert(map[next_y][next_x] == #char "#");
                            break;
                        }
                    }
                    // going left and hitting the edge
                    else if dx == -1 && (x + dx < 0 || map[y][x + dx] == #char " ")
                    {
                        side_x  := x / 50;
                        side_y  := y / 50;
                        rel_x   := x % 50;
                        rel_y   := y % 50;
                        next_x  := x;
                        next_y  := y;
                        next_dx := dx;
                        next_dy := dy;

                        if side_x == 1 && side_y == 0 // e to b
                        {
                            next_x  = 0;
                            next_y  = (49 - rel_y) + 100;
                            next_dx = 1;
                        }
                        else if side_x == 1 && side_y == 1 // d to b
                        {
                            next_x  = rel_y;
                            next_y  = 100;
                            next_dx = 0;
                            next_dy = 1;
                        }
                        else if side_x == 0 && side_y == 2 // b to e
                        {
                            next_x  = 50;
                            next_y  = 49 - rel_y;
                            next_dx = 1;
                        }
                        else if side_x == 0 && side_y == 3 // a to c
                        {
                            next_x  = rel_y + 50;
                            next_y  = 0;
                            next_dx = 0;
                            next_dy = 1;
                        }
                        else
                        {
                            assert(false);
                        }

                        if map[next_y][next_x] == #char "."
                        {
                            x  = next_x;
                            y  = next_y;
                            dx = next_dx;
                            dy = next_dy;
                        }
                        else
                        {
                            assert(map[next_y][next_x] == #char "#");
                            break;
                        }
                    }
                    // successfully going left or right
                    else if map[y][x + dx] == #char "."
                    {
                        x += dx;
                    }
                    // going left or right and hitting a wall
                    else
                    {
                        assert(map[y][x + dx] == #char "#");
                        break;
                    }
                }
                // vertical move
                else
                {
                    // going down and hitting the edge
                    if dy == 1 && (y + dy >= map.count || map[y + dy].count < x || map[y + dy][x] == #char " ")
                    {
                        side_x  := x / 50;
                        side_y  := y / 50;
                        rel_x   := x % 50;
                        rel_y   := y % 50;
                        next_x  := x;
                        next_y  := y;
                        next_dx := dx;
                        next_dy := dy;

                        if side_x == 2 && side_y == 0 // f to d
                        {
                            next_x  = 99;
                            next_y  = rel_x + 50;
                            next_dx = -1;
                            next_dy = 0;
                        }
                        else if side_x == 1 && side_y == 2 // c to a
                        {
                            next_x  = 49;
                            next_y  = rel_x + 150;
                            next_dx = -1;
                            next_dy = 0;
                        }
                        else if side_x == 0 && side_y == 3 // a to f
                        {
                            next_x  = rel_x + 100;
                            next_y  = 0;
                        }
                        else
                        {
                            assert(false);
                        }

                        if map[next_y][next_x] == #char "."
                        {
                            x  = next_x;
                            y  = next_y;
                            dx = next_dx;
                            dy = next_dy;
                        }
                        else
                        {
                            assert(map[next_y][next_x] == #char "#");
                            break;
                        }
                    }
                    // going up and hitting the edge
                    else if dy == -1 && (y + dy < 0 || map[y + dy][x] == #char " ")
                    {
                        side_x  := x / 50;
                        side_y  := y / 50;
                        rel_x   := x % 50;
                        rel_y   := y % 50;
                        next_x  := x;
                        next_y  := y;
                        next_dx := dx;
                        next_dy := dy;

                        if side_x == 2 && side_y == 0 // f to a
                        {
                            next_x  = rel_x;
                            next_y  = 199;
                        }
                        else if side_x == 1 && side_y == 0 // e to a
                        {
                            next_x  = 0;
                            next_y  = rel_x + 150;
                            next_dx = 1;
                            next_dy = 0;
                        }
                        else if side_x == 0 && side_y == 2 // b to d
                        {
                            next_x  = 50;
                            next_y  = rel_x + 50;
                            next_dx = 1;
                            next_dy = 0;
                        }
                        else
                        {
                            assert(false);
                        }

                        if map[next_y][next_x] == #char "."
                        {
                            x  = next_x;
                            y  = next_y;
                            dx = next_dx;
                            dy = next_dy;
                        }
                        else
                        {
                            assert(map[next_y][next_x] == #char "#");
                            break;
                        }
                    }
                    // successfully going up or down
                    else if map[y + dy][x] == #char "."
                    {
                        y += dy;
                    }
                    // going up or down and hitting a wall
                    else
                    {
                        assert(map[y + dy][x] == #char "#");
                        break;
                    }
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

walk_2d :: (map: []string, moves: []s64, _x: s64) -> s64
{
    x, y, dx, dy := _x, 0, 1, 0;

    for move, move_index: moves
    {
        if move_index % 2 == 0
        {
            for 1..move
            {
                // horizontal move
                if dx != 0
                {
                    // going right and hitting the edge
                    if dx == 1 && x + dx >= map[y].count
                    {
                        next_x := 0;

                        for 0..map[y].count-1
                        {
                            if map[y][it] != #char " "
                            {
                                next_x = it;
                                break;
                            }
                        }

                        if map[y][next_x] == #char "."
                        {
                            x = next_x;
                        }
                        else
                        {
                            assert(map[y][next_x] == #char "#");
                            break;
                        }
                    }
                    // going left and hitting the edge
                    else if dx == -1 && (x + dx < 0 || map[y][x + dx] == #char " ")
                    {
                        next_x := map[y].count - 1;
                        
                        if map[y][next_x] == #char "."
                        {
                            x = next_x;
                        }
                        else
                        {
                            assert(map[y][next_x] == #char "#");
                            break;
                        }
                    }
                    // successfully going left or right
                    else if map[y][x + dx] == #char "."
                    {
                        x += dx;
                    }
                    // going left or right and hitting a wall
                    else
                    {
                        assert(map[y][x + dx] == #char "#");
                        break;
                    }
                }
                // vertical move
                else
                {
                    // going down and hitting the edge
                    if dy == 1 && (y + dy >= map.count || map[y + dy].count < x || map[y + dy][x] == #char " ")
                    {
                        next_y := 0;

                        for 0..map.count-1
                        {
                            if map[it][x] != #char " "
                            {
                                next_y = it;
                                break;
                            }
                        }

                        if map[next_y][x] == #char "."
                        {
                            y = next_y;
                        }
                        else
                        {
                            assert(map[next_y][x] == #char "#");
                            break;
                        }
                    }
                    // going up and hitting the edge
                    else if dy == -1 && (y + dy < 0 || map[y + dy][x] == #char " ")
                    {
                        next_y := 0;

                        for < map.count-1..0
                        {
                            if map[it].count >= x && map[it][x] != #char " "
                            {
                                next_y = it;
                                break;
                            }
                        }

                        if map[next_y][x] == #char "."
                        {
                            y = next_y;
                        }
                        else
                        {
                            assert(map[next_y][x] == #char "#");
                            break;
                        }
                    }
                    // successfully going up or down
                    else if map[y + dy][x] == #char "."
                    {
                        y += dy;
                    }
                    // going up or down and hitting a wall
                    else
                    {
                        assert(map[y + dy][x] == #char "#");
                        break;
                    }
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