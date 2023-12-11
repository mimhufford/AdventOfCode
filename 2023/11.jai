day11 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    galaxies : [..]Positions;
    
    for y: 0..map.count-1
    {
        for x: 0..map[0].count-1
        {
            if map[y][x] == #char "#"
            {
                g := array_add(*galaxies);
                g.x1, g.x2, g.y1, g.y2 = x, x, y, y;
            }
        }
    }

    for < y: map.count-1..0
    {
        for x: 0..map[0].count-1 if map[y][x] != #char "." continue y;
        for * g: galaxies if g.y1 > y { g.y1 += 1; g.y2 += 999999; }
    }

    for < x: map[0].count-1..0
    {
        for y: 0..map.count-1 if map[y][x] != #char "." continue x;
        for * g: galaxies if g.x1 > x { g.x1 += 1; g.x2 += 999999; }
    }

    part1, part2 := 0, 0;

    for i: 0..galaxies.count-1
    {
        for j: i+1..galaxies.count-1
        {
            part1 += abs(galaxies[i].x1 - galaxies[j].x1) + abs(galaxies[i].y1 - galaxies[j].y1);
            part2 += abs(galaxies[i].x2 - galaxies[j].x2) + abs(galaxies[i].y2 - galaxies[j].y2);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

Positions :: struct { x1, y1, x2, y2 : s64; }