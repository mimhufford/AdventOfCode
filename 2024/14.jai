day14 :: (input: string) -> string, string
{
    counts : [4]s64;

    while input
    {
        advance(*input, 2); sx := read_s64(*input);
        advance(*input, 1); sy := read_s64(*input);
        advance(*input, 2); dx := read_s64(*input);
        advance(*input, 1); dy := read_s64(*input);

        x := (sx + 100*dx) % WIDTH;
        y := (sy + 100*dy) % HEIGHT;

        if x < WIDTH/2     && y < HEIGHT/2     then counts[0] += 1;
        if x > WIDTH/2 + 1 && y < HEIGHT/2     then counts[1] += 1;
        if x < WIDTH/2     && y > HEIGHT/2 + 1 then counts[2] += 1;
        if x > WIDTH/2 + 1 && y > HEIGHT/2 + 1 then counts[3] += 1;
    }

    part1, part2 := counts[0] * counts[1] * counts[2] * counts[3];

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

HEIGHT :: 103;
WIDTH  :: 101;

// 42888960 too low