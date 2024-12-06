day6 :: (input: string) -> string, string
{
    map := split(input, "\n");
    map.count -= 1;

    array_reserve(*walls, 1024);

    for line, y: map for cell, x: line
    {
        if cell == #char "^" start_x, start_y = x, y;
        if cell == #char "#" add_wall(x, y);
    }

    part1, part2 := walk(map), 0;

    for y: 0..map.count-1 for x: 0..map[0].count-1
    {
        if y == start_y && x == start_x continue;
        if map[y][x] == #char "#"       continue;
        if map[y][x] == #char "."       continue;

        add_wall(x, y);
        if has_cycle(map) part2 += 1;
        remove_last_wall(x, y);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Position :: struct { x, y : s64; }
walls : [..]Position;
x_walls : [130][..]*Position; // fast lookup
y_walls : [130][..]*Position; // fast lookup
start_x, start_y : s64;
dirs :: []s64.[ .[0, -1], .[1, 0], .[0, 1], .[-1, 0] ];

add_wall :: (x: s64, y: s64)
{
    array_add(*walls, .{x, y});
    array_add(*x_walls[x], *walls[walls.count-1]);
    array_add(*y_walls[y], *walls[walls.count-1]);
}

remove_last_wall :: (x: s64, y: s64)
{
    walls.count -= 1;
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
                map[y][x] = #char "X";
                visited += 1;
            }
        }
    }

    return visited;
}

has_cycle :: (map: []string) -> bool
{
    x, y, dir := start_x, start_y, 0;
    history : [130][130][4]bool;

    while true
    {
        if dir == {
            case 0; // up
                wall : *Position;
                for x_walls[x] if it.y < y && (!wall || wall.y < it.y) wall = it;
                if !wall return false;
                y = wall.y + 1;
            case 1; // right
                wall : *Position;
                for y_walls[y] if it.x > x && (!wall || wall.x > it.x) wall = it;
                if !wall return false;
                x = wall.x - 1;
            case 2; // down
                wall : *Position;
                for x_walls[x] if it.y > y && (!wall || wall.y > it.y) wall = it;
                if !wall return false;
                y = wall.y - 1;
            case 3; // left
                wall : *Position;
                for y_walls[y] if it.x < x && (!wall || wall.x < it.x) wall = it;
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