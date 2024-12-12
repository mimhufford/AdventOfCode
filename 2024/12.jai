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
in_bounds :: (x, y) => x >= 0 && x < SIZE && y >= 0 && y < SIZE;

flood_fill :: (x: s64, y: s64) -> s64, s64
{
    flood_fill :: (x: s64, y: s64, perimeter: *s64, region: *[..]*Position)
    {
        if map[y][x].region > 0 return;
        map[y][x].region = next_region_id;
        array_add(region, *map[y][x]);

        for dirs
        {
            nx, ny := x+it[0], y+it[1];
            if !in_bounds(nx, ny) { perimeter.* += 1; continue; }
            if map[y][x].plant == map[ny][nx].plant flood_fill(nx, ny, perimeter, region);
            else perimeter.* += 1;
        }
    }

    if map[y][x].region > 0 return 0, 0;

    region : [..]*Position;
    perimeter := 0;
    flood_fill(x, y, *perimeter, *region);
    next_region_id += 1;
    return region.count * perimeter, region.count * count_sides(region);
}

count_sides :: (region: []*Position) -> s64
{
    sides := 0;

    for r: region
    {
        is_different :: (x: s64, y: s64) -> bool #expand
        {
            if !in_bounds(x, y) return true;
            return map[y][x].region != r.region;
        }

        u_diff  := is_different(r.x + 0, r.y - 1);
        l_diff  := is_different(r.x - 1, r.y + 0);
        d_diff  := is_different(r.x + 0, r.y + 1);
        r_diff  := is_different(r.x + 1, r.y + 0);
        ul_diff := is_different(r.x - 1, r.y - 1);
        ur_diff := is_different(r.x + 1, r.y - 1);
        dl_diff := is_different(r.x - 1, r.y + 1);
        dr_diff := is_different(r.x + 1, r.y + 1);

        sides += xx (l_diff && u_diff);
        sides += xx (u_diff && r_diff);
        sides += xx (r_diff && d_diff);
        sides += xx (d_diff && l_diff);
        sides += xx (!l_diff && !u_diff && ul_diff);
        sides += xx (!u_diff && !r_diff && ur_diff);
        sides += xx (!r_diff && !d_diff && dr_diff);
        sides += xx (!d_diff && !l_diff && dl_diff);
    }

    return sides;
}