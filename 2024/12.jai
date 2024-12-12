day12 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        part1, part2 += flood_fill(input, x, y);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 140;
visited : [SIZE][SIZE]bool;
dirs :: []s64.[.[-1,0], .[1,0], .[0,-1], .[0,1]];
Position :: struct { x: s64; y: s64; side_counted: [4]bool; };

flood_fill :: (map: string, x: s64, y: s64) -> s64, s64
{
    flood_fill :: (map: string, x: s64, y: s64, perimeter: *s64, region: *[..]Position)
    {
        if visited[y][x] return;
        visited[y][x] = true;
        array_add(region, .{x, y, .[]});

        for dirs
        {
            nx, ny := x+it[0], y+it[1];
            if nx < 0 || nx >= SIZE { perimeter.* += 1; continue; }
            if ny < 0 || ny >= SIZE { perimeter.* += 1; continue; }
            ci :=  y*(SIZE+1) +  x;
            ni := ny*(SIZE+1) + nx;
            if map[ci] == map[ni] flood_fill(map, nx, ny, perimeter, region);
            else perimeter.* += 1;
        }
    }

    if visited[y][x] return 0, 0;

    region : [..]Position;
    perimeter := 0;
    flood_fill(map, x, y, *perimeter, *region);
    return region.count * perimeter, region.count * count_sides(map, region);
}

count_sides :: (map: string, region: []Position) -> s64
{
    sides := 0;

    for * r: region
    {
        for dir, dir_id: dirs
        {
            if r.side_counted[dir_id] continue;
            r.side_counted[dir_id] = true;

            nx, ny := r.x + dir[0], r.y + dir[1];
            ci := r.y *(SIZE+1) + r.x;
            ni :=  ny *(SIZE+1) + nx;

            in_bounds := nx >= 0 && nx < SIZE && ny >= 0 && ny < SIZE;
            if in_bounds && map[ci] == map[ni] continue;

            sides += 1;

            mark_all_connected_sides_in_direction :: (d: []s64) #expand
            {
                for i: 1..S64_MAX
                {
                    // Terrible way to look for neighbouring cells
                    // but region size is never big enough to care
                    for * o: region
                    {
                        if o.x != r.x + d[0]*i continue;
                        if o.y != r.y + d[1]*i continue;
                        onx := o.x + dir[0];
                        ony := o.y + dir[1];
                        in_bounds := onx >= 0 && onx < SIZE && ony >= 0 && ony < SIZE;
                        oni := ony *(SIZE+1) + onx;
                        if in_bounds && map[oni] == map[ci] break;
                        o.side_counted[dir_id] = true;
                        continue i;
                    }

                    break;
                }
            }
            
            mark_all_connected_sides_in_direction(.[-dir[1], dir[0]]);
            mark_all_connected_sides_in_direction(.[dir[1], -dir[0]]);
        }
    }

    return sides;
}