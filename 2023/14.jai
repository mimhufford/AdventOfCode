day14 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    tilt_north(map);
    part1 := calculate_total_load(map);
    tilt_west(map);
    tilt_south(map);
    tilt_east(map);

    // do 200 to let it settle (already done 1)
    for 2..200 do_a_round(map);

    // calculate the hash
    hash_to_find := calculate_hash(map);
    cycle := 0;

    // find the cycle
    while true
    {
        cycle += 1;
        do_a_round(map);
        if calculate_hash(map) == hash_to_find break;
    }

    // calculate how many rounds left
    rounds_done := 200 + cycle;
    rounds_left := 1000000000 - rounds_done;
    rounds_left %= cycle;

    // do the last rounds
    for 1..rounds_left do_a_round(map);

    part2 := calculate_total_load(map);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

calculate_hash :: (map: []string) -> u32
{
    load := calculate_total_load(map);
    hash := get_hash(load);
    for map hash = get_hash(hash + get_hash(it));
    return hash;
}

do_a_round :: (map: []string)
{
    tilt_north(map);
    tilt_west(map);
    tilt_south(map);
    tilt_east(map);
}

tilt_north :: (map: []string)
{
    for x: 0..map[0].count-1
    {
        y := 0;

        while y < map.count
        {
            while y < map.count && map[y][x] == #char "#" y += 1;
            start_y := y;
            count := 0;
            while y < map.count && map[y][x] != #char "#"
            {
                if map[y][x] == #char "O"
                {
                    map[y][x] = #char ".";
                    map[start_y+count][x] = #char "O";
                    count += 1;
                }
                y += 1;
            }
        }
    }
}

tilt_south :: (map: []string)
{
    for x: 0..map[0].count-1
    {
        y := map.count-1;

        while y >= 0
        {
            while y >= 0 && map[y][x] == #char "#" y -= 1;
            start_y := y;
            count := 0;
            while y >= 0 && map[y][x] != #char "#"
            {
                if map[y][x] == #char "O"
                {
                    map[y][x] = #char ".";
                    map[start_y-count][x] = #char "O";
                    count += 1;
                }
                y -= 1;
            }
        }
    }
}

tilt_west :: (map: []string)
{
    for y: 0..map.count-1
    {
        x := 0;

        while x < map[0].count
        {
            while x < map[0].count && map[y][x] == #char "#" x += 1;
            start_x := x;
            count := 0;
            while x < map[0].count && map[y][x] != #char "#"
            {
                if map[y][x] == #char "O"
                {
                    map[y][x] = #char ".";
                    map[y][start_x+count] = #char "O";
                    count += 1;
                }
                x += 1;
            }
        }
    }
}

tilt_east :: (map: []string)
{
    for y: 0..map.count-1
    {
        x := map[0].count-1;

        while x >= 0
        {
            while x >= 0 && map[y][x] == #char "#" x -= 1;
            start_x := x;
            count := 0;
            while x >= 0 && map[y][x] != #char "#"
            {
                if map[y][x] == #char "O"
                {
                    map[y][x] = #char ".";
                    map[y][start_x-count] = #char "O";
                    count += 1;
                }
                x -= 1;
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