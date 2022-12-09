day9 :: (input: string) -> string, string
{
    snake : [10][2]s32;
    neck  : Table(s32, void); // values not used
    arse  : Table(s32, void); // using tables as sets

    while input
    {
        dir := read_word(*input);
        amt := read_s32(*input);

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

move :: (x: s32, y: s32) #expand
{
    `snake[0][0] += x;
    `snake[0][1] += y;

    for 1..9
    {
        dx := `snake[it-1][0] - `snake[it][0];
        dy := `snake[it-1][1] - `snake[it][1];
        
        if dx*dx + dy*dy > 2
        {
            if dx != 0 `snake[it][0] += ifx dx < 1 then cast(s32)-1 else 1;
            if dy != 0 `snake[it][1] += ifx dy < 1 then cast(s32)-1 else 1;
        }
    }

    find_or_add(*`neck, `snake[1][0]*100_000 + `snake[1][1]);
    find_or_add(*`arse, `snake[9][0]*100_000 + `snake[9][1]);
}