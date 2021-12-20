day20 :: (data : string) -> string, string
{
    algorithm := read_algorithm(*data);
    canvas, backer, dim := read_canvas(*data);

    next := backer;
    prev := canvas;

    for 1..2 zoom_and_enhance(it);

    part_1 := 0;
    for y: 0..size-1 for x: 0..size-1 if prev[y][x] part_1 += 1;

    return tprint("%", part_1), tprint("%", "");

    zoom_and_enhance :: (generation: int) #expand
    {
        min := offset-generation-1;
        max := offset+dim+generation;

        for y: min..max
        {
            for x: min..max
            {
                index : int;
                if prev[y-1][x-1] index |= 1 << 8;
                if prev[y-1][x  ] index |= 1 << 7;
                if prev[y-1][x+1] index |= 1 << 6;
                if prev[y  ][x-1] index |= 1 << 5;
                if prev[y  ][x  ] index |= 1 << 4;
                if prev[y  ][x+1] index |= 1 << 3;
                if prev[y+1][x-1] index |= 1 << 2;
                if prev[y+1][x  ] index |= 1 << 1;
                if prev[y+1][x+1] index |= 1 << 0;

                next[y][x] = algorithm[index];
            }
        }

        memset(prev.data, xx(generation % 2 == 0), size*size);
        t := next;
        next = prev;
        prev = t;
    }
}

offset :: 25;
size   :: 150;

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