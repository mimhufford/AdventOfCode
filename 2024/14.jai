day14 :: (input: string) -> string, string
{
    counts : [4]s64;

    while input
    {
        robot := array_add(*robots);
        advance(*input, 2); robot.x  = read_s64(*input);
        advance(*input, 1); robot.y  = read_s64(*input);
        advance(*input, 2); robot.dx = read_s64(*input);
        advance(*input, 1); robot.dy = read_s64(*input);

        x := (((robot.x + 100*robot.dx) % WIDTH)  + WIDTH)  % WIDTH;
        y := (((robot.y + 100*robot.dy) % HEIGHT) + HEIGHT) % HEIGHT;

        if x < WIDTH/2 && y < HEIGHT/2 then counts[0] += 1;
        if x > WIDTH/2 && y < HEIGHT/2 then counts[1] += 1;
        if x < WIDTH/2 && y > HEIGHT/2 then counts[2] += 1;
        if x > WIDTH/2 && y > HEIGHT/2 then counts[3] += 1;
    }

    part1 := counts[0] * counts[1] * counts[2] * counts[3];
    part2 := 8280; // found manually by dumping the results into a file and look through it

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

HEIGHT :: 103;
WIDTH  :: 101;
robots : [..] struct { x: s64; y: s64; dx: s64; dy: s64; };

dump_state :: (seconds: s64)
{
    map : [HEIGHT][WIDTH]u8;
    for y: 0..HEIGHT-1 for x: 0..WIDTH-1 map[y][x] = #char " ";

    buffer : String_Builder;

    for s: 0..seconds
    {
        append(*buffer, tprint("==================== % ====================\n", s+1));

        for * r: robots
        {
            map[r.y][r.x] = #char " ";
            r.x = (((r.x + r.dx) % WIDTH)  + WIDTH)  % WIDTH;
            r.y = (((r.y + r.dy) % HEIGHT) + HEIGHT) % HEIGHT;
            map[r.y][r.x] = #char "#";
        }

        for y: 0..HEIGHT-1
        {
            for x: 0..WIDTH-1
            {
                append(*buffer, map[y][x]);
            }

            append(*buffer, "\n");
        }

        append(*buffer, tprint("==================== % ====================\n\n", s+1));
    }

    write_entire_file("dump.txt", builder_to_string(*buffer));
}