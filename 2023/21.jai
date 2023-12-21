day21 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");
    w, h := map[0].count, map.count;

    q1, q2 : [..]s64;
    qc, qn := *q1, *q2;
    array_add(qc, 65*w + 65);

    part1, part2 := 0;

    for 1..64
    {
        while qc.count
        {
            curr := pop(qc);
            x, y := curr % w, curr / w;

            for dir: [2]s64.[.[-1, 0], .[1, 0], .[0, -1], .[0, 1]]
            {
                nx, ny := x + dir[0], y + dir[1];
                if nx < 0 || nx >= w continue;
                if ny < 0 || ny >= h continue;
                if map[ny][nx] == #char "#" continue;
                array_add_if_unique(qn, ny*w + nx); // TODO: slow
            }
        }

        qc, qn = qn, qc;
        part1 = qc.count;
    }

    return tprint("%", part1), tprint("%", part2);
}

// 3535 too low