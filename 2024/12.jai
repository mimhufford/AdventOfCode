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
Position :: struct { x:s64; y:s64; };

flood_fill :: (map: string, x: s64, y: s64) -> s64, s64
{
    flood_fill :: (map: string, x: s64, y: s64, area: *s64, perimeter: *s64, region: *[..]Position)
    {
        if visited[y][x] return;
        visited[y][x] = true;
        area.* += 1;
        array_add(region, .{x, y});

        for []s64.[.[-1,0], .[1,0], .[0,-1], .[0,1]]
        {
            nx, ny := x+it[0], y+it[1];
            if nx < 0 || nx >= SIZE { perimeter.* += 1; continue; }
            if ny < 0 || ny >= SIZE { perimeter.* += 1; continue; }
            ci :=  y*(SIZE+1) +  x;
            ni := ny*(SIZE+1) + nx;
            if map[ci] == map[ni] flood_fill(map, nx, ny, area, perimeter, region);
            else perimeter.* += 1;
        }
    }

    if visited[y][x] return 0, 0;

    region : [..]Position;
    area, perimeter := 0, 0;
    flood_fill(map, x, y, *area, *perimeter, *region);
    return area * perimeter, area * count_sides(region);
}

count_sides :: (region: []Position) -> s64
{
    return 1;
}