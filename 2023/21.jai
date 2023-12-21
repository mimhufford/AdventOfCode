day21 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    w, h := map[0].count, map.count;

    q1, q2 : Table(u32, u8);
    qc, qn := *q1, *q2;
    table_set(qc, Point.{65, 65}.hash, 0);

    t1, t2, t3 := 0;
    part1 := 0;

    for 1..65 + w*2
    {
        for _, curr: qc
        {
            p : Point;

            for dir: [2]s16.[.[-1, 0], .[1, 0], .[0, -1], .[0, 1]]
            {
                p.hash = curr;
                p.x += dir[0];
                p.y += dir[1];
                if map[((p.y%h)+h)%h][((p.x%w)+w)%w] != #char "#"
                {
                    table_set(qn, p.hash, 0);
                }
            }
        }

        if it == 65 + w*0 part1 = qc.count;
        qc, qn = qn, qc;
        if it == 65 + w*0 t1 = qc.count;
        if it == 65 + w*1 t2 = qc.count;
        if it == 65 + w*2 t3 = qc.count;
    }

    n := 26501365 / w;
    b0 := t1;
    b1 := t2-t1;
    b2 := t3-t2;
    part2 := b0 + b1*n + (n*(n-1)/2)*(b2-b1);

    return tprint("%", part1), tprint("%", part2);
}

Point :: struct
{
    x, y: s16;
    #place x;
    hash: u32;
}