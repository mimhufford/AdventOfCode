day11 :: (input: string) -> string, string
{
    a := read_map(*input);
    b := array_copy(a);
    c := array_copy(a);
    d := array_copy(a);

    while true
    {
        if tick(a, b, 4, immediate_neighbours) break;
        if tick(b, a, 4, immediate_neighbours) break;
    }

    while true
    {
        if tick(c, d, 5, visible_neighbours) break;
        if tick(d, c, 5, visible_neighbours) break;
    }

    part1 := 0; for a if it == #char "#" part1 += 1;
    part2 := 0; for c if it == #char "#" part2 += 1;
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

w : s64;
h : s64;

visible_neighbours :: (a: []u8, index: s64) -> u8
{
    // TODO accelerate this with a lookup
    find_first :: (a: []u8, index: s64, dx: s64, dy: s64) -> u8
    {
        x := index % w;
        y := index / w;

        x += dx;
        y += dy;

        while x >= 0 && x < w && y >= 0 && y < h
        {
            if a.data[y*w+x] == #char "#" return 1;
            if a.data[y*w+x] == #char "L" return 0;
            x += dx;
            y += dy;
        }

        return 0;
    }

    count: u8;
    count += find_first(a, index, +1, +0);
    count += find_first(a, index, +1, +1);
    count += find_first(a, index, +1, -1);
    count += find_first(a, index, -1, +0);
    count += find_first(a, index, -1, +1);
    count += find_first(a, index, -1, -1);
    count += find_first(a, index, +0, -1);
    count += find_first(a, index, +0, +1);
    return count;
}

immediate_neighbours :: (a: []u8, index: s64) -> u8
{
    count: u8;

    x := index % w;
    y := index / w;

    if x > 0               && a.data[(y+0)*w + x-1] == #char "#" count += 1; // L
    if x < w-1             && a.data[(y+0)*w + x+1] == #char "#" count += 1; // R
    if y > 0               && a.data[(y-1)*w + x+0] == #char "#" count += 1; // U
    if y < h-1             && a.data[(y+1)*w + x+0] == #char "#" count += 1; // D
    if x < w-1 && y > 0    && a.data[(y-1)*w + x+1] == #char "#" count += 1; // RU
    if x > 0   && y > 0    && a.data[(y-1)*w + x-1] == #char "#" count += 1; // LU
    if x < w-1 && y < h-1  && a.data[(y+1)*w + x+1] == #char "#" count += 1; // RD
    if x > 0   && y < h-1  && a.data[(y+1)*w + x-1] == #char "#" count += 1; // LD

    return count;
}

tick :: (a: []u8, b: []u8, limit: u8, neighbours: ([]u8, s64) -> u8) -> bool
{
    for 0..a.count-1
    {
        if a.data[it] == #char "L" && neighbours(a, it) == 0 b.data[it] = #char "#";
        else if a.data[it] == #char "#" && neighbours(a, it) >= limit b.data[it] = #char "L";
        else b.data[it] = a.data[it];
    }

    return memcmp(a.data, b.data, a.count) == 0;
}

read_map :: (input: *string) -> []u8
{
    w = 0;
    h = 1;
    map : [..]u8;

    while input.count
    {
        if input.data[0] == #char "\n"
        {
            w = 0;
            h += 1;
            advance(input, 1);
            continue;
        }

        w += 1;
        array_add(*map, input.data[0]);
        if input.count advance(input, 1);
    }

    return map;
}