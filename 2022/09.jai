day9 :: (input: string) -> string, string
{
    sx : [10]s64;
    sy : [10]s64;
    neck : Table(s64, s64); // pos -> count
    arse : Table(s64, s64); // pos -> count

    while input
    {
        dir := read_word(*input);
        amt := read_s64(*input);

        for 1..amt
        {
            if      dir == "R" move(+1,  0);
            else if dir == "L" move(-1,  0);
            else if dir == "U" move( 0, -1);
            else if dir == "D" move( 0, +1);
        }
    }

    return tprint("%", neck.count), tprint("%", arse.count);
}

#scope_file

move :: (x: s64, y: s64) #expand
{
    `sx[0] += x;
    `sy[0] += y;

    for 1..9
    {
        dx := `sx[it-1] - `sx[it];
        dy := `sy[it-1] - `sy[it];
        
        if dx*dx + dy*dy > 2
        {
            if dx != 0 `sx[it] += ifx dx < 1 then -1 else 1;
            if dy != 0 `sy[it] += ifx dy < 1 then -1 else 1;
        }
    }

    <<find_or_add(*`neck, `sx[1]*1_000_000+`sy[1]) += 1;
    <<find_or_add(*`arse, `sx[9]*1_000_000+`sy[9]) += 1;
}