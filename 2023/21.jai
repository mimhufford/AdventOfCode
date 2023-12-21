day21 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    w, h := map[0].count, map.count;

    q1, q2 : Table(s64, u8);
    qc, qn := *q1, *q2;
    table_set(qc, 65*w + 65, 0);

    part1, part2 := 0;

    for 1..64
    {
        for _, curr: qc
        {
            x, y := curr % w, curr / w;

            for dir: [2]s64.[.[-1, 0], .[1, 0], .[0, -1], .[0, 1]]
            {
                nx, ny := x + dir[0], y + dir[1];
                if nx < 0 || nx >= w continue;
                if ny < 0 || ny >= h continue;
                if map[ny][nx] == #char "#" continue;
                table_set(qn, ny*w + nx, 0);
            }
        }

        qc, qn = qn, qc;
        part1 = qc.count;
    }

    return tprint("%", part1), tprint("%", part2);
}