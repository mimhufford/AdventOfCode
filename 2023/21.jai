day21 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    w, h := map[0].count, map.count;

    q : Table(s64, u8);
    table_set(*q, 65*w + 65, 0);

    t1, t2, t3 := 0;
    part1 := 0;

    for 1..65+w*2
    {
        qn : Table(s64, u8);
        for _, curr: q
        {
            x, y := curr % w, curr / w;

            for dir: [2]s64.[.[-1, 0], .[1, 0], .[0, -1], .[0, 1]]
            {
                nx, ny := x + dir[0], y + dir[1];
                if map[((ny%h)+h)%h][((nx%w)+w)%w] != #char "#"
                {
                    table_set(*qn, ny*w + nx, 0);
                }
            }
        }

        if it == 65 + w*0 part1 = q.count;
        q = qn;
        if it == 65 + w*0 t1 = q.count;
        if it == 65 + w*1 t2 = q.count;
        if it == 65 + w*2 t3 = q.count;
    }

    n := 26501365 / w;
    b0 := t1;
    b1 := t2-t1;
    b2 := t3-t2;
    part2 := b0 + b1*n + (n*(n-1)/2)*(b2-b1);
    return tprint("%", part1), tprint("%", part2);
}