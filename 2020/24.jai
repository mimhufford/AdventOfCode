day24 :: (input: string) -> string, string
{
    x : u32 = 1000;
    y : u32 = 1000;
    map : Table(u32, bool);

    while true
    {
        if !input.count || input[0] == #char "\n"
        {
            key := (x << 16) | y;
            val, found := table_find(map, key);
            if found val = !val; else val = true;
            table_set(*map, key, val);
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

    part1 := 0;
    for map if it part1 += 1;

    return tprint("%", part1), "";
}