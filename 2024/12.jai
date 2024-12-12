day12 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        map[y][x].plant = input[y * (SIZE+1) + x];
        map[y][x].y = y;
        map[y][x].x = x;
    }

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        part1, part2 += flood_fill(x, y);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 140;
next_region_id := 1;
map : [SIZE][SIZE]Position;
Position :: struct { x: s64; y: s64; plant: u8; region: s64; side_counted: [4]bool; };
dirs :: []s64.[.[-1,0], .[1,0], .[0,-1], .[0,1]];

flood_fill :: (x: s64, y: s64) -> s64, s64
{
    flood_fill :: (x: s64, y: s64, area: *s64, perimeter: *s64, region: *[..]*Position)
    {
        if map[y][x].region > 0 return;
        map[y][x].region = next_region_id;
        area.* += 1;
        array_add(region, *map[y][x]);

        for dirs
        {
            nx, ny := x+it[0], y+it[1];
            if nx < 0 || nx >= SIZE { perimeter.* += 1; continue; }
            if ny < 0 || ny >= SIZE { perimeter.* += 1; continue; }
            if map[y][x].plant == map[ny][nx].plant flood_fill(nx, ny, area, perimeter, region);
            else perimeter.* += 1;
        }
    }

    if map[y][x].region > 0 return 0, 0;

    region : [..]*Position;
    area, perimeter := 0;
    flood_fill(x, y, *area, *perimeter, *region);
    next_region_id += 1;
    return area * perimeter, area * count_sides(region);
}

count_sides :: (region: []*Position) -> s64
{
    sides := 0;

    for r: region
    {
        for dir, dir_id: dirs
        {
            if r.side_counted[dir_id] continue;
            r.side_counted[dir_id] = true;

            nx, ny := r.x + dir[0], r.y + dir[1];
            ci := r.y *(SIZE+1) + r.x;
            ni :=  ny *(SIZE+1) + nx;

            in_bounds := nx >= 0 && nx < SIZE && ny >= 0 && ny < SIZE;
            if in_bounds && map[r.y][r.x].region == map[ny][nx].region continue;

            sides += 1;

            mark_all_connected_sides_in_direction :: (d: []s64) #expand
            {
                for i: 1..S64_MAX
                {
                    nx := r.x + d[0] * i;
                    ny := r.y + d[1] * i;
                    if !(nx >= 0 && nx < SIZE && ny >= 0 && ny < SIZE) break;
                    if map[ny][nx].region != map[r.y][r.x].region break;
                    onx := nx + dir[0];
                    ony := ny + dir[1];
                    in_bounds := onx >= 0 && onx < SIZE && ony >= 0 && ony < SIZE;
                    if in_bounds && map[ony][onx].region == map[r.y][r.x].region break;
                    map[ny][nx].side_counted[dir_id] = true;
                }
            }
            
            mark_all_connected_sides_in_direction(.[-dir[1], dir[0]]);
            mark_all_connected_sides_in_direction(.[dir[1], -dir[0]]);
        }
    }

    return sides;
}