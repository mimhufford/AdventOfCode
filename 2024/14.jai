day14 :: (input: string) -> string, string
{
    counts : [4]s64;

    while input
    {
        advance(*input, 2); sx := read_s64(*input);
        advance(*input, 1); sy := read_s64(*input);
        advance(*input, 2); dx := read_s64(*input);
        advance(*input, 1); dy := read_s64(*input);

        HEIGHT :: 103;
        WIDTH  :: 101;

        x := (((sx + 100*dx) % WIDTH)  + WIDTH)  % WIDTH;
        y := (((sy + 100*dy) % HEIGHT) + HEIGHT) % HEIGHT;

        if x < WIDTH/2 && y < HEIGHT/2 then counts[0] += 1;
        if x > WIDTH/2 && y < HEIGHT/2 then counts[1] += 1;
        if x < WIDTH/2 && y > HEIGHT/2 then counts[2] += 1;
        if x > WIDTH/2 && y > HEIGHT/2 then counts[3] += 1;
    }

    part1, part2 := counts[0] * counts[1] * counts[2] * counts[3], 0;

    return tprint("%", part1), tprint("%", part2);
}