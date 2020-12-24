day24 :: (input: string) -> string, string
{
    x : u32 = 150;
    y : u32 = 150;
    map1 : [300][300]bool;
    map2 : [300][300]bool;

    while true
    {
        if !input.count || input[0] == #char "\n"
        {
            map1[y][x] = !map1[y][x];
            x = 150;
            y = 150;
            if !input.count break; else advance(*input);
        }
        else
        {
            skip := 1;
            if      input[0] == #char "e"                          { x += 1;                   }
            else if input[0] == #char "w"                          { x -= 1;                   }
            else if input[0] == #char "n" && input[1] == #char "e" { x += 1; y -= 1; skip = 2; }
            else if input[0] == #char "s" && input[1] == #char "w" { x -= 1; y += 1; skip = 2; }
            else if input[0] == #char "s" && input[1] == #char "e" {         y += 1; skip = 2; }
            else if input[0] == #char "n" && input[1] == #char "w" {         y -= 1; skip = 2; }
            advance(*input, skip);
        }
    }

    part1 := 0;
    min_x : u32 = 299;
    max_x : u32 = 0;
    min_y : u32 = 299;
    max_y : u32 = 0;

    for y: 0..cast(u32) 299
    {
        for x: 0..cast(u32) 299
        {
            if map1[y][x]
            {
                part1 += 1;
                if x < min_x min_x = x;
                if y < min_y min_y = y;
                if x > max_x max_x = x;
                if y > max_y max_y = y;
            }
        }
    }

    a := *map1;
    b := *map2;

    for 1..100
    {
        min_x -= 1;
        min_y -= 1;
        max_x += 1;
        max_y += 1;

        for x: min_x..max_x
        {
            for y: min_y..max_y
            {
                black := a.data[y][x];
                neighbours := 0;
                if a.data[y+0][x+1] neighbours += 1;
                if a.data[y+0][x-1] neighbours += 1;
                if a.data[y-1][x+1] neighbours += 1;
                if a.data[y+1][x-1] neighbours += 1;
                if a.data[y+1][x+0] neighbours += 1;
                if a.data[y-1][x+0] neighbours += 1;
                if black
                {
                    if      neighbours == 0 b.data[y][x] = false;
                    else if neighbours >= 3 b.data[y][x] = false;
                    else                    b.data[y][x] = true;
                }
                else
                {
                    if neighbours == 2 b.data[y][x] = true;
                    else               b.data[y][x] = false;
                }
            }
        }

        c := a;
        a = b;
        b = c;
    }

    part2 := 0;
    for y: 0..299 for x: 0..299 if map1[y][x] part2 += 1;

    return tprint("%", part1), tprint("%", part2);
}