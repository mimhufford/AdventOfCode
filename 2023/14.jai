day14 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    for y: 0..map.count-1
    {
        for x: 0..map[y].count-1
        {
            if map[y][x] != #char "O" continue;

            for < ny: y-1..0
            {
                if map[ny][x] != #char "." break;
                map[ny  ][x] = #char "O";
                map[ny+1][x] = #char ".";
            }
        }
    }

    part1 := calculate_total_load(map);

    return tprint("%", part1), tprint("%", 0);
}

#scope_file

calculate_total_load :: (map: []string) -> s64
{
    load := 0;

    for y: 0..map.count-1
    {
        for x: 0..map[y].count-1
        {
            if map[y][x] != #char "O" continue;

            load += map.count - y;
        }
    }
    
    return load;
}