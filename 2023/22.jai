day22 :: (input: string) -> string, string
{
    bricks : [..]Brick;

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

    part1, part2 := 0;

    quick_sort(bricks, b => b.z1);

    // TODO: this whole alogirthm is slow

    // fall
    while true
    {
        changed := false;

        for * b, i: bricks
        {
            if b.z1 == 1 continue;
            for j: 0..i-1 if supported(b, bricks[j]) continue b;
            b.z1 -= 1;
            b.z2 -= 1;
            changed = true;
        }

        if !changed break;
    }

    // populate graph
    for i: 0..bricks.count-1
    {
        a := *bricks[i];
        for j: 0..i-1
        {
            b := *bricks[j];
            if supported(a, b)
            {
                array_add(*a.below, b);
                array_add(*b.above, a);
            }
        }
    }
        
    for bricks if can_disintegrate(it) part1 += 1;

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

can_disintegrate :: (b: Brick) -> bool
{
    if b.above.count == 0 return true;
    for b.above if it.below.count == 1 return false;
    return true;
}