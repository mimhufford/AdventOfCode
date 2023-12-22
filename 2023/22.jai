day22 :: (input: string) -> string, string
{
    bricks : [..]Brick;
    zlut : [1500][..]*Brick;
    xy2z : [10][10]s64;

    for split(trim(input), "\n")
    {
        b := array_add(*bricks);
        b.x1 = read_s64(*it); advance(*it);
        b.y1 = read_s64(*it); advance(*it);
        b.z1 = read_s64(*it); advance(*it);
        b.x2 = read_s64(*it); advance(*it);
        b.y2 = read_s64(*it); advance(*it);
        b.z2 = read_s64(*it);
    }

    // order by lowest z first
    quick_sort(bricks, b => b.z1);

    // fall
    for * b: bricks
    {
        z := 0;
        for x: b.x1..b.x2 for y: b.y1..b.y2 z = max(xy2z[x][y], z);
        dz := b.z1 - z - 1;
        b.z1 -= dz;
        b.z2 -= dz;
        for x: b.x1..b.x2 for y: b.y1..b.y2 xy2z[x][y] = b.z2;
        for z: b.z1..b.z2 array_add(*zlut[z], b);
    }

    // populate graph
    for * a: bricks
    {
        for b: zlut[a.z1-1]
        {
            if supported(a, b)
            {
                array_add(*a.below, b);
                array_add(*b.above, a);
            }
        }
    }

    part1, part2 := 0;

    for * bricks
    {
        chaos := count_chaos(it);
        part1 += ifx chaos 0 else 1;
        part2 += chaos;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Brick :: struct
{
    x1, x2, y1, y2, z1, z2 : s64;
    above, below: [..]*Brick;
}

supported :: (a: Brick, b: Brick) -> bool
{
    return a.x1   <= b.x2 && a.x2   >= b.x1 &&
           a.y1   <= b.y2 && a.y2   >= b.y1 &&
           a.z1-1 <= b.z2 && a.z2-1 >= b.z1;
}

count_chaos :: (b: *Brick) -> s64
{
    if can_disintegrate(b) return 0;

    drops : Table(*Brick, u8);
    queue : [..]*Brick;
    index : s64;

    array_add(*queue, b);

    while index < queue.count
    {
        cur := queue[index];
        index += 1;

        if index > 1 && is_still_supported(*drops, cur) continue;

        table_set(*drops, cur, 0);

        for cur.above
        {
            if table_contains(*drops, it) continue;
            array_add(*queue, it);
        }
    }

    return drops.count - 1;
}

is_still_supported :: (drops: *Table(*Brick, u8), b: *Brick) -> bool
{
    for b.below if !table_contains(drops, it) return true;
    return false;
}

can_disintegrate :: (b: Brick) -> bool
{
    if b.above.count == 0 return true;
    for b.above if it.below.count == 1 return false;
    return true;
}