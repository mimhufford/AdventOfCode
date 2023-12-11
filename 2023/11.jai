day11 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    galaxies : [..]s64;
    
    for y: 0..map.count-1
    {
        for x: 0..map[0].count-1
        {
            if map[y][x] == #char "#" array_add(*galaxies, y << 32 | x);
        }
    }

    for < y: map.count-1..0
    {
        for x: 0..map[0].count-1
        {
            if map[y][x] != #char "." continue y;
        }

        for * g: galaxies
        {
            gx := g.* & 0xFFFF;
            gy := g.* >> 32;
            if gy > y g.* = (gy+1) << 32 | gx;
        }
    }

    for < x: map[0].count-1..0
    {
        for y: 0..map.count-1
        {
            if map[y][x] != #char "." continue x;
        }

        for * g: galaxies
        {
            gx := g.* & 0xFFFF;
            gy := g.* >> 32;
            if gx > x g.* = gy << 32 | (gx+1);
        }
    }

    part1 := 0;

    for i: 0..galaxies.count-1
    {
        for j: i+1..galaxies.count-1
        {
            ax := galaxies[i] & 0xFFFF;
            ay := galaxies[i] >> 32;
            bx := galaxies[j] & 0xFFFF;
            by := galaxies[j] >> 32;
            part1 += abs(ax - bx) + abs(ay - by);
        }
    }

    return tprint("%", part1), tprint("%", 0);
}