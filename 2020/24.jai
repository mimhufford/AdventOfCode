day24 :: (input: string) -> string, string
{
    x : u32 = 1000;
    y : u32 = 1000;
    black : Table(u32, bool); init(*black);
    black2 : Table(u32, bool);

    while true
    {
        if !input.count || input[0] == #char "\n"
        {
            key := (x << 16) | y;
            if !table_remove(*black, key) table_add(*black, key, true);
            x = 1000;
            y = 1000;
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

    part1 := black.count;

    a := *black;
    b := *black2;

    min_x : u32 = 99999999;
    max_x : u32 = 0;
    min_y : u32 = 99999999;
    max_y : u32 = 0;

    for a
    {
        x := it_index >> 16;
        y := it_index & 0xFFFF;
        if x < min_x min_x = x;
        if y < min_y min_y = y;
        if x > max_x max_x = x;
        if y > max_y max_y = y;
    }

    for 1..100
    {
        table_reset(b);
        min_x -= 1;
        min_y -= 1;
        max_x += 1;
        max_y += 1;

        for x: min_x..max_x
        {
            for y: min_y..max_y
            {
                key := (x << 16) | y;
                black := table_find_pointer(<<a, key) != null;
                neighbours := 0;
                if table_find_pointer(<<a, ((x+1) << 16) | (y+0)) != null neighbours += 1;
                if table_find_pointer(<<a, ((x-1) << 16) | (y+0)) != null neighbours += 1;
                if table_find_pointer(<<a, ((x+1) << 16) | (y-1)) != null neighbours += 1;
                if table_find_pointer(<<a, ((x-1) << 16) | (y+1)) != null neighbours += 1;
                if table_find_pointer(<<a, ((x+0) << 16) | (y+1)) != null neighbours += 1;
                if table_find_pointer(<<a, ((x+0) << 16) | (y-1)) != null neighbours += 1;
                if  black && neighbours == 1 table_add(b, key, true);
                if  black && neighbours == 2 table_add(b, key, true);
                if !black && neighbours == 2 table_add(b, key, true);
            }
        }

        c := a;
        a = b;
        b = c;
    }

    return tprint("%", part1), tprint("%", a.count);
}