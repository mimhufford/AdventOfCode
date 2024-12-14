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
    part2 := 8280; // found manually by dumping the maps into images and looking at them

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

HEIGHT :: 103;
WIDTH  :: 101;
robots : [..] struct { x: s64; y: s64; dx: s64; dy: s64; };

dump_images :: (seconds: s64)
{
    #import "stb_image_write";

    map : [HEIGHT][WIDTH]u8;

    for s: 1..seconds
    {
        for * r: robots
        {
            map[r.y][r.x] = 0;
            r.x = (((r.x + r.dx) % WIDTH)  + WIDTH)  % WIDTH;
            r.y = (((r.y + r.dy) % HEIGHT) + HEIGHT) % HEIGHT;
            map[r.y][r.x] = 255;
        }

        stbi_write_png(tprint("images/%.png\0", s).data, WIDTH, HEIGHT, 1, map.data, WIDTH);
    }
}