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

    can_disintegrate : Table(*Brick, u8);

    // TODO: this whole alogirthm is slow

    // for each brick that has 2 or more supports, add those supports
    for b, i: bricks
    {
        below : [..]*Brick;
        for j: 0..i-1 if supported(b, bricks[j]) array_add(*below, *bricks[j]);
        if below.count >= 2 for below table_set(*can_disintegrate, it, 0);
    }

    // for each brick that has 1 or fewer supports, remove those supports, they cannot be disintegrated
    for b, i: bricks
    {
        below : [..]*Brick;
        for j: 0..i-1 if supported(b, bricks[j]) array_add(*below, *bricks[j]);
        if below.count <= 1 for below table_remove(*can_disintegrate, it);
    }

    // add each brick that is sitting on top and not supporting anything
    for b, i: bricks
    {
        for j: i+1..bricks.count-1 if supports(b, bricks[j]) continue b;
        table_set(*can_disintegrate, *b, 0);
    }

    part1 = can_disintegrate.count;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Brick :: struct
{
    x1, x2, y1, y2, z1, z2 : s64;
}

supported :: (a: Brick, b: Brick) -> bool
{
    return a.x1   <= b.x2 && a.x2   >= b.x1 &&
           a.y1   <= b.y2 && a.y2   >= b.y1 &&
           a.z1-1 <= b.z2 && a.z2-1 >= b.z1;
}

supports :: (a: Brick, b: Brick) -> bool
{
    return a.x1   <= b.x2 && a.x2   >= b.x1 &&
           a.y1   <= b.y2 && a.y2   >= b.y1 &&
           a.z1+1 <= b.z2 && a.z2+1 >= b.z1;
}