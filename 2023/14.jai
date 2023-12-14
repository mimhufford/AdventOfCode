day14 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    tilt_north(map);
    part1 := calculate_total_load(map);
    tilt_west(map);
    tilt_south(map);
    tilt_east(map);

    // do 500 to let it settle (already done 1)
    for 2..500
    {
        tilt_north(map);
        tilt_west(map);
        tilt_south(map);
        tilt_east(map);
    }

    // calculate the hash
    load := calculate_total_load(map);
    hash_to_find := get_hash(load);
    for map hash_to_find = get_hash(hash_to_find + get_hash(it));
    cycle := 0;

    // find the cycle
    while true
    {
        tilt_north(map);
        tilt_west(map);
        tilt_south(map);
        tilt_east(map);
        cycle += 1;
        load := calculate_total_load(map);
        hash := get_hash(load);
        for map hash = get_hash(hash + get_hash(it));
        if hash == hash_to_find break;
    }

    // calculate how many cycles left
    rounds_done := 500 + cycle;
    rounds_left := 1000000000 - rounds_done;
    rounds_left %= cycle;

    // do the last cycles
    for 1..rounds_left
    {
        tilt_north(map);
        tilt_west(map);
        tilt_south(map);
        tilt_east(map);
    }

    part2 := calculate_total_load(map);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

tilt_north :: (map: []string)
{
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
}

tilt_south :: (map: []string)
{
    for < y: map.count-1..0
    {
        for x: 0..map[y].count-1
        {
            if map[y][x] != #char "O" continue;

            for ny: y+1..map.count-1
            {
                if map[ny][x] != #char "." break;
                map[ny  ][x] = #char "O";
                map[ny-1][x] = #char ".";
            }
        }
    }
}

tilt_west :: (map: []string)
{
    for x: 0..map[0].count-1
    {
        for y: 0..map.count-1
        {
            if map[y][x] != #char "O" continue;

            for < nx: x-1..0
            {
                if map[y][nx] != #char "." break;
                map[y][nx] = #char "O";
                map[y][nx+1] = #char ".";
            }
        }
    }
}

tilt_east :: (map: []string)
{
    for < x: map[0].count-1..0
    {
        for y: 0..map.count-1
        {
            if map[y][x] != #char "O" continue;

            for nx: x+1..map[0].count-1
            {
                if map[y][nx] != #char "." break;
                map[y][nx] = #char "O";
                map[y][nx-1] = #char ".";
            }
        }
    }
}

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