day13 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for split(trim(input), "\n\n")
    {
        rows := split(it, "\n");
        w, h := rows[0].count, rows.count;

        for col: 1..w-1
        {
            errors := 0;
            ym := 0.5 * ((col-1) + col);

            for row: 0..h-1
            {
                for ya: 0..col-1
                {
                    yb := cast(s64)(2*ym - ya);
                    if yb >= w continue;
                    if rows[row][ya] != rows[row][yb] errors += 1;
                    if errors > 1 continue col;
                }
            }

            if errors == 0 part1 += cast(s64)ceil(ym);
            if errors == 1 part2 += cast(s64)ceil(ym);
        }

        for row: 1..h-1
        {
            errors := 0;
            xm := 0.5 * ((row-1) + row);

            for col: 0..w-1
            {
                for xa: 0..row-1
                {
                    xb := cast(s64)(2*xm - xa);
                    if xb >= h continue;
                    if rows[xa][col] != rows[xb][col] errors += 1;
                    if errors > 1 continue row;
                }
            }

            if errors == 0 part1 += cast(s64)ceil(xm) * 100;
            if errors == 1 part2 += cast(s64)ceil(xm) * 100;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}