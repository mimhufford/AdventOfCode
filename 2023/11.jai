day11 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    galaxies : [..]Position;
    
    for y: 0..map.count-1
    {
        for x: 0..map[0].count-1
        {
            if map[y][x] == #char "#"
            {
                g := array_add(*galaxies);
                g.x = x;
                g.y = y;
            }
        }
    }

    for < y: map.count-1..0
    {
        for x: 0..map[0].count-1 if map[y][x] != #char "." continue y;
        for * g: galaxies if g.y > y g.y += 1;
    }

    for < x: map[0].count-1..0
    {
        for y: 0..map.count-1 if map[y][x] != #char "." continue x;
        for * g: galaxies if g.x > x g.x += 1;
    }

    part1 := 0;

    for i: 0..galaxies.count-1
    {
        for j: i+1..galaxies.count-1
        {
            part1 += abs(galaxies[i].x - galaxies[j].x) + abs(galaxies[i].y - galaxies[j].y);
        }
    }

    return tprint("%", part1), tprint("%", 0);
}

Position :: struct { x, y : s64; }