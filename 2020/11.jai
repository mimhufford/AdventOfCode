day11 :: (input: string) -> string, string
{
    width, height, a, b := read_map(*input);

    while true
    {
        tick(*a, *b, width, height);
        if memcmp(a.data, b.data, a.count) == 0 break;
        tick(*b, *a, width, height);
        if memcmp(a.data, b.data, a.count) == 0 break;
    }

    count := 0;
    for a if it == #char "#" count += 1;
    
    return tprint("%", count), "";
}

print :: (a: *[..]u8, w: s64, h: s64)
{
    for y: 0..h-1
    {
        for x: 0..w-1
        {
            if a.data[y*w+x] == #char "L" print("L");
            else if a.data[y*w+x] == #char "#" print("#");
            else print(".");
        }
        print("\n");
    }
    print("\n");
}

occupied_neighbours :: (a: *[..]u8, index: s64, w: s64, h: s64) -> u8
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

tick :: (a: *[..]u8, b: *[..]u8, w: s64, h: s64)
{
    for 0..a.count-1
    {
        if a.data[it] == #char "L" && occupied_neighbours(a, it, w, h) == 0 b.data[it] = #char "#";
        else if a.data[it] == #char "#" && occupied_neighbours(a, it, w, h) >= 4 b.data[it] = #char "L";
        else b.data[it] = a.data[it];
    }
}

read_map :: (input: *string) -> s64, s64, [..]u8, [..]u8
{
    width  := 0;
    height := 1;
    a : [..]u8;
    b : [..]u8;

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
        array_add(*a, input.data[0]);
        array_add(*b, input.data[0]);
        if input.count advance(input, 1);
    }

    return width, height, a, b;
}