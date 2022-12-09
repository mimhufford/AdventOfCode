day9 :: (input: string) -> string, string
{
    snake : [10][2]s64;
    neck  : Table(s64, s64); // pos -> count
    arse  : Table(s64, s64); // pos -> count

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
    `snake[0][0] += x;
    `snake[0][1] += y;

    for 1..9
    {
        dx := `snake[it-1][0] - `snake[it][0];
        dy := `snake[it-1][1] - `snake[it][1];
        
        if dx*dx + dy*dy > 2
        {
            if dx != 0 `snake[it][0] += ifx dx < 1 then -1 else 1;
            if dy != 0 `snake[it][1] += ifx dy < 1 then -1 else 1;
        }
    }

    <<find_or_add(*`neck, `snake[1][0]*1_000_000 + `snake[1][1]) += 1;
    <<find_or_add(*`arse, `snake[9][0]*1_000_000 + `snake[9][1]) += 1;
}