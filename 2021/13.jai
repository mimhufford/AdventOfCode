day13 :: (data : string) -> string, string
{
    points : [..]V2;
    folds  : [..]V2;
    height : u64;
    width  : u64;

    while data[0] != #char "\n"
    {
        p := read_point(*data);
        array_add(*points, p);
        if p.x > width    width = p.x;
        if p.y > height  height = p.y;
    }
    advance(*data, 1);
    while data.count array_add(*folds, read_fold(*data));

    part_1 : s64;

    for folds
    {
        do_fold(it);
        if !part_1  part_1 = points.count;
    }

    //print_part_2();

    return tprint("%", part_1), tprint("%", "ECFHLHZF");
}

V2 :: struct { x, y : u64; }

do_fold :: (f: V2) #expand
{
    for * p: `points
    {
        if p.x < f.x || p.y < f.y continue;
        
        np := <<p;
        if f.x  np.x = f.x*2 - np.x;
        if f.y  np.y = f.y*2 - np.y;

        remove p;
        for pp: `points if pp.x == np.x && pp.y == np.y continue p;
        array_add(*`points, np);
    }

    if f.x `width /= 2;
    else  `height /= 2;
}

print_part_2 :: () #expand
{
    for y: 0..`height-1
    {
        for x: 0..`width-1
        {
            for p: `points if p.x == x && p.y == y { print("#"); continue x; }
            print(" ");
        }
        print("\n");
    }
}

read_fold :: (s: *string) -> V2 #expand
{
    result : V2;
    advance(s, 11);
    if s.data[0] == #char "x"
    {
        advance(s, 2);
        while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
        {
            result.x *= 10;
            result.x += s.data[0] - #char "0";
            advance(s, 1);
        }
    }
    else
    {
        advance(s, 2);
        while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
        {
            result.y *= 10;
            result.y += s.data[0] - #char "0";
            advance(s, 1);
        }
    }
    advance(s, 1);
    return result;
}

read_point :: (s: *string) -> V2 #expand
{
    result : V2;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result.x *= 10;
        result.x += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 1);

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result.y *= 10;
        result.y += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 1);

    return result;
}