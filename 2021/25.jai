day25 :: (data : string) -> string, string
{
    grid, next : [..]string;
    for split(data, "\n") array_add(*grid, it);
    grid.count -= 1;
    width := grid[0].count;
    height := grid.count;

    moves := 0;

    while true
    {
        any_moved := false;

        next.count = 0; for grid array_add(*next, tprint(it));

        for y: 0..height-1 for x: 0..width-1
        {
            if grid[y][x] == #char ">" && grid[y][(x+1)%width] == #char "."
            {
                any_moved = true;
                next[y][x]           = #char ".";
                next[y][(x+1)%width] = #char ">";
            }
        }

        grid.count = 0; for next array_add(*grid, tprint(it));

        for y: 0..height-1 for x: 0..width-1
        {
            if next[y][x] == #char "v" && next[(y+1)%height][x] == #char "."
            {
                any_moved = true;
                grid[y][x]            = #char ".";
                grid[(y+1)%height][x] = #char "v";
            }
        }

        moves += 1;
        if !any_moved break;
    }

    return tprint("%", moves), tprint("%", "Beep Beep");
}