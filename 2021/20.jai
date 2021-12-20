day20 :: (data : string) -> string, string
{
    algorithm := read_algorithm(*data);
    canvas, backer, dim := read_canvas(*data);

    next := backer;
    prev := canvas;

    for 1..2 zoom_and_enhance(it);
    part_1 := 0; for y: 0..size-1 for x: 0..size-1 if prev[y][x] part_1 += 1;

    for 3..50 zoom_and_enhance(it);
    part_2 := 0; for y: 0..size-1 for x: 0..size-1 if prev[y][x] part_2 += 1;

    return tprint("%", part_1), tprint("%", part_2);

    zoom_and_enhance :: (generation: int) #expand
    {
        min := offset-generation-1;
        max := offset+dim+generation;

        for y: min..max
        {
            for x: min..max
            {
                index : int;
                index |= ( cast(int) prev[y-1][x-1] ) << 8;
                index |= ( cast(int) prev[y-1][x  ] ) << 7;
                index |= ( cast(int) prev[y-1][x+1] ) << 6;
                index |= ( cast(int) prev[y  ][x-1] ) << 5;
                index |= ( cast(int) prev[y  ][x  ] ) << 4;
                index |= ( cast(int) prev[y  ][x+1] ) << 3;
                index |= ( cast(int) prev[y+1][x-1] ) << 2;
                index |= ( cast(int) prev[y+1][x  ] ) << 1;
                index |= ( cast(int) prev[y+1][x+1] ) << 0;

                next[y][x] = algorithm[index];
            }
        }

        memset(prev.data, xx(generation % 2 == 0), size*size);
        next, prev = swap(next, prev);
    }
}

offset :: 52;
size   :: 204;

read_algorithm :: (s: *string) -> [512]bool
{
    algorithm : [512]bool;
    for 0..511 algorithm[it] = s.data[it] == #char "#";
    advance(s, 514);
    return algorithm;
}

read_canvas :: (s: *string) -> [size][size]bool, [size][size]bool, int
{
    canvas : [size][size]bool;
    y, x := 0;
    while s.count
    {
        canvas[y+offset][x+offset] = s.data[0] == #char "#";
        x += 1;
        advance(s, 1);

        if s.data[0] == #char "\n"
        {
            y += 1;
            x = 0;
            advance(s, 1);
        }
    }

    backer : [size][size]bool;
    memset(backer.data, 1, size*size);
    return canvas, backer, y;
}