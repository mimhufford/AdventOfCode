day14 :: (input: string) -> string, string
{
    counts : [4]s64;

    while input
    {
        robot := array_add(*robots);
        advance(*input, 2); robot.x  = read_s64(*input);
        advance(*input, 1); robot.y  = read_s64(*input);
        advance(*input, 2); robot.dx = (read_s64(*input) + WIDTH)  % WIDTH;
        advance(*input, 1); robot.dy = (read_s64(*input) + HEIGHT) % HEIGHT;

        x := (robot.x + 100*robot.dx) % WIDTH;
        y := (robot.y + 100*robot.dy) % HEIGHT;

        if x < WIDTH/2 && y < HEIGHT/2 then counts[0] += 1;
        if x > WIDTH/2 && y < HEIGHT/2 then counts[1] += 1;
        if x < WIDTH/2 && y > HEIGHT/2 then counts[2] += 1;
        if x > WIDTH/2 && y > HEIGHT/2 then counts[3] += 1;
    }

    part1 := counts[0] * counts[1] * counts[2] * counts[3];

    // originally found manually using dump_images and looking at them, but now
    // have switched to a programmatic approach which should work for any input
    part2 := find_clumped_image();

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

HEIGHT :: 103;
WIDTH  :: 101;
robots : [..] struct { x: s64; y: s64; dx: s64; dy: s64; };

find_clumped_image :: () -> s64
{
    xi, yi := 0;

    for 1..10000
    {
        x, y, x_spread, y_spread := 0;

        for * r: robots
        {
            r.x = (r.x + r.dx) % WIDTH;
            r.y = (r.y + r.dy) % HEIGHT;
            x, y += r.x, r.y;
        }
        
        x, y /= robots.count;

        for * r: robots
        {
            x_spread += (r.x-x)*(r.x-x);
            y_spread += (r.y-y)*(r.y-y);
        }

        if x_spread < 250_000 xi = it;
        if y_spread < 250_000 yi = it;

        if xi > 0 && yi > 0
        {
            while true
            {
                if xi < yi  xi += WIDTH;
                if yi < xi  yi += HEIGHT;
                if xi == yi return xi;
            }
        }
    }

    return -1;
}

dump_images :: (seconds: s64)
{
    #import "stb_image_write";

    map : [HEIGHT][WIDTH]u8;

    for s: 1..seconds
    {
        for * r: robots
        {
            map[r.y][r.x] = 0;
            r.x = (r.x + r.dx) % WIDTH;
            r.y = (r.y + r.dy) % HEIGHT;
            map[r.y][r.x] = 255;
        }

        stbi_write_png(tprint("images/%.png\0", s).data, WIDTH, HEIGHT, 1, map.data, WIDTH);
    }
}