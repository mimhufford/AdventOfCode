day21 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    w, h := map[0].count, map.count;

    q1, q2 : Table(u32, u8);
    qc, qn := *q1, *q2;
    table_set(qc, Point.{65, 65}.hash, 0);

    terms : [..]s64;
    part1 := 0;

    for 1..S64_MAX
    {
        for _, curr: qc
        {
            p : Point;

            for dir: [2]s16.[.[-1, 0], .[1, 0], .[0, -1], .[0, 1]]
            {
                p.hash = curr;
                p.x += dir[0];
                p.y += dir[1];
                if map[((p.y%h)+h)%h][((p.x%w)+w)%w] == #char "#" continue;
                table_set(qn, p.hash, 0);
            }
        }

        qc, qn = qn, qc;

        if it == 64 part1 = qc.count;
        if it % 131 == 65
        {
            array_add(*terms, qc.count);
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