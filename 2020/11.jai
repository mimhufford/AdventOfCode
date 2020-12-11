day11 :: (input: string) -> string, string
{
    width, height, a := read_map(*input);
    b := array_copy(a);
    c := array_copy(a);
    d := array_copy(a);

    while true
    {
        tick_immediate(a, b, width, height);
        if memcmp(a.data, b.data, a.count) == 0 break;
        tick_immediate(b, a, width, height);
        if memcmp(a.data, b.data, a.count) == 0 break;
    }

    while true
    {
        tick_visible(c, d, width, height);
        if memcmp(c.data, d.data, c.count) == 0 break;
        tick_visible(d, c, width, height);
        if memcmp(c.data, d.data, c.count) == 0 break;
    }

    part1 := 0; for a if it == #char "#" part1 += 1;
    part2 := 0; for c if it == #char "#" part2 += 1;
    
    return tprint("%", part1), tprint("%", part2);
}

visible_neighbours :: (a: []u8, index: s64, w: s64, h: s64) -> u8
{
    // TODO accelerate this with a lookup
    find_first :: (a: []u8, index: s64, w: s64, h: s64, dx: s64, dy: s64) -> u8
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
    count += find_first(a, index, w, h, +1, +0);
    count += find_first(a, index, w, h, +1, +1);
    count += find_first(a, index, w, h, +1, -1);
    count += find_first(a, index, w, h, -1, +0);
    count += find_first(a, index, w, h, -1, +1);
    count += find_first(a, index, w, h, -1, -1);
    count += find_first(a, index, w, h, +0, -1);
    count += find_first(a, index, w, h, +0, +1);
    return count;
}

immediate_neighbours :: (a: []u8, index: s64, w: s64, h: s64) -> u8
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

tick_visible :: (a: []u8, b: []u8, w: s64, h: s64)
{
    for 0..a.count-1
    {
        if a.data[it] == #char "L" && visible_neighbours(a, it, w, h) == 0 b.data[it] = #char "#";
        else if a.data[it] == #char "#" && visible_neighbours(a, it, w, h) >= 5 b.data[it] = #char "L";
        else b.data[it] = a.data[it];
    }
}

tick_immediate :: (a: []u8, b: []u8, w: s64, h: s64)
{
    for 0..a.count-1
    {
        if a.data[it] == #char "L" && immediate_neighbours(a, it, w, h) == 0 b.data[it] = #char "#";
        else if a.data[it] == #char "#" && immediate_neighbours(a, it, w, h) >= 4 b.data[it] = #char "L";
        else b.data[it] = a.data[it];
    }
}

read_map :: (input: *string) -> s64, s64, []u8
{
    width  := 0;
    height := 1;
    map : [..]u8;

    while input.count
    {
        if input.data[0] == #char "\n"
        {
            width = 0;
            height += 1;
            advance(input, 1);
            continue;
        }

        width += 1;
        array_add(*map, input.data[0]);
        if input.count advance(input, 1);
    }

    return width, height, map;
}