day21 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    w, h := map[0].count, map.count;

    s1, s2 : Table(u32, u8);
    q1, q2 : Table(u32, u8);
    table_set(*q1, Point.{65, 65}.hash, 0);

    terms : [..]s64;
    part1 := 0;

    for 0..S64_MAX
    {
        seen_curr  := ifx it % 2 == 0 then *s1 else *s2;
        seen_prev  := ifx it % 2 == 1 then *s1 else *s2;
        queue_curr := ifx it % 2 == 0 then *q1 else *q2;
        queue_next := ifx it % 2 == 1 then *q1 else *q2;

        for _, curr: queue_curr
        {
            table_set(seen_curr, curr, 0);

            for dir: [2]s16.[.[-1, 0], .[1, 0], .[0, -1], .[0, 1]]
            {
                p := Point.{hash = curr};
                p.x += dir[0];
                p.y += dir[1];
                if map[((p.y%h)+h)%h][((p.x%w)+w)%w] == #char "#" continue;
                if table_contains(seen_prev, p.hash) continue;
                table_set(queue_next, p.hash, 0);
            }
        }

        table_reset(queue_curr);

        if it == 64 part1 = seen_curr.count;
        if it % 131 == 65
        {
            array_add(*terms, seen_curr.count);
            if terms.count == 3 break;
        }
    }

    n := 26501365 / w;
    b0 := terms[0];
    b1 := terms[1]-terms[0];
    b2 := terms[2]-terms[1];
    part2 := b0 + b1*n + (n*(n-1)/2)*(b2-b1);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Point :: struct
{
    x, y: s16;
    #place x;
    hash: u32;
}