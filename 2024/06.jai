day6 :: (input: string) -> string, string
{
    map := split(input, "\n");
    map.count -= 1;

    for line, y: map for cell, x: line
    {
        if cell == #char "^" start_x, start_y = x, y;
        if cell == #char "#" add_wall(x, y);
    }

    part1, part2 := walk(map), 0;

    for loop_starts
    {
        add_wall(it.wx, it.wy);
        if has_cycle(map, it.sx, it.sy, it.sd) part2 += 1;
        remove_last_wall(it.wx, it.wy);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Position :: struct { x, y : u8; }
x_walls : [130][..]Position;
y_walls : [130][..]Position;
start_x, start_y : s64;
dirs :: []s64.[ .[0, -1], .[1, 0], .[0, 1], .[-1, 0] ];
loop_starts : [..]struct { sx, sy, sd, wx, wy: s64; };

add_wall :: (x: s64, y: s64)
{
    array_add(*x_walls[x], .{cast(u8)x, cast(u8)y});
    array_add(*y_walls[y], .{cast(u8)x, cast(u8)y});
}

remove_last_wall :: (x: s64, y: s64)
{
    x_walls[x].count -= 1;
    y_walls[y].count -= 1;
}

walk :: (map: []string) -> s64
{
    x, y, dir, visited := start_x, start_y, 0, 1;

    while true
    {
        dx, dy := dirs[dir][0], dirs[dir][1];

        if x+dx < 0             break;
        if y+dy < 0             break;
        if x+dx >= map[0].count break;
        if y+dy >= map.count    break;

        if map[y+dy][x+dx] == #char "#"
        {
            dir = (dir+1) % 4;
        }
        else
        {
            x, y += dx, dy;

            if map[y][x] == #char "."
            {
                array_add(*loop_starts, .{ x-dx, y-dy, dir, x, y });
                map[y][x] = #char "X";
                visited += 1;
            }
        }
    }

    return visited;
}

has_cycle :: (map: []string, sx: s64, sy: s64, sd: s64) -> bool
{
    x, y, dir := sx, sy, sd;
    history : [130][130][4]bool;

    while true
    {
        if dir == {
            case 0; // up
                wall : *Position;
                for * x_walls[x] if it.y < y && (!wall || wall.y < it.y) wall = it;
                if !wall return false;
                y = wall.y + 1;
            case 1; // right
                wall : *Position;
                for * y_walls[y] if it.x > x && (!wall || wall.x > it.x) wall = it;
                if !wall return false;
                x = wall.x - 1;
            case 2; // down
                wall : *Position;
                for * x_walls[x] if it.y > y && (!wall || wall.y > it.y) wall = it;
                if !wall return false;
                y = wall.y - 1;
            case 3; // left
                wall : *Position;
                for * y_walls[y] if it.x < x && (!wall || wall.x < it.x) wall = it;
                if !wall return false;
                x = wall.x + 1;
        }

        if history[y][x][dir] return true;
        history[y][x][dir] = true;
        dir = (dir + 1) % 4;
    }

    assert(false);
    return false;
}