day12 :: (input: string) -> string, string
{
    for y: 0..SIZE-1 for x: 0..SIZE-1 map[y][x].plant = input[y * (SIZE+1) + x];
    for y: 0..SIZE-1 for x: 0..SIZE-1 fill_region(x, y);
    for y: 0..SIZE-1 for x: 0..SIZE-1 count_sides(x, y);

    part1, part2 := 0;
    for regions part1, part2 += it.area * it.perimeter, it.area * it.sides;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 140;
next_region_id := 1;
map : [SIZE][SIZE] struct { plant: u8; region: s64; };
regions : [1000] struct { area: s64; perimeter: s64; sides: s64; };
in_bounds :: (x, y) => x >= 0 && x < SIZE && y >= 0 && y < SIZE;

fill_region :: (x: s64, y: s64)
{
    if map[y][x].region != 0 return;

    flood_fill :: (x: s64, y: s64)
    {
        if map[y][x].region > 0 return;
        map[y][x].region = next_region_id;
        regions[next_region_id].area += 1;

        for []s64.[.[-1,0], .[1,0], .[0,-1], .[0,1]]
        {
            nx, ny := x+it[0], y+it[1];
            if in_bounds(nx, ny) && map[y][x].plant == map[ny][nx].plant then flood_fill(nx, ny);
            else regions[next_region_id].perimeter += 1;
        }
    }

    flood_fill(x, y);
    next_region_id += 1;
}

count_sides :: (x: s64, y: s64)
{
    is_different :: (nx: s64, ny: s64) -> bool #expand
    {
        if !in_bounds(nx, ny) return true;
        return map[y][x].region != map[ny][nx].region;
    }

    u_diff  := is_different(x + 0, y - 1);
    l_diff  := is_different(x - 1, y + 0);
    d_diff  := is_different(x + 0, y + 1);
    r_diff  := is_different(x + 1, y + 0);
    ul_diff := is_different(x - 1, y - 1);
    ur_diff := is_different(x + 1, y - 1);
    dl_diff := is_different(x - 1, y + 1);
    dr_diff := is_different(x + 1, y + 1);

    regions[map[y][x].region].sides += xx (l_diff && u_diff);
    regions[map[y][x].region].sides += xx (u_diff && r_diff);
    regions[map[y][x].region].sides += xx (r_diff && d_diff);
    regions[map[y][x].region].sides += xx (d_diff && l_diff);
    regions[map[y][x].region].sides += xx (!l_diff && !u_diff && ul_diff);
    regions[map[y][x].region].sides += xx (!u_diff && !r_diff && ur_diff);
    regions[map[y][x].region].sides += xx (!r_diff && !d_diff && dr_diff);
    regions[map[y][x].region].sides += xx (!d_diff && !l_diff && dl_diff);
}