day9 :: (input: string) -> string, string
{
    hx, hy, tx, ty : s64;
    visited : Table(s64, s64); // pos -> count

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

    return tprint("%", visited.count), tprint("%", "");
}

#scope_file

move :: (x: s64, y: s64) #expand
{
    `hx += x;
    `hy += y;

    dx := `hx - `tx;
    dy := `hy - `ty;
    
    if dx*dx + dy*dy > 2
    {
        if dx != 0 `tx += ifx dx < 1 then -1 else 1;
        if dy != 0 `ty += ifx dy < 1 then -1 else 1;
    }

    <<find_or_add(*`visited, `tx*1_000_000+`ty) += 1;
}