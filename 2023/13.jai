day13 :: (input: string) -> string, string
{
    maps := split(trim(input), "\n\n");

    part1 := 0;

    for maps
    {
        rows := split(it, "\n");
        w, h := rows[0].count, rows.count;

        for col: 1..w-1
        {
            ym := 0.5 * ((col-1) + col);

            for row: 0..h-1
            {
                for ya: 0..col-1
                {
                    yb := cast(s64)(2*ym - ya);
                    if yb >= w continue;
                    if rows[row][ya] != rows[row][yb] continue col;
                }
            }

            part1 += cast(s64)ceil(ym);
        }

        for row: 1..h-1
        {
            xm := 0.5 * ((row-1) + row);

            for col: 0..w-1
            {
                for xa: 0..row-1
                {
                    xb := cast(s64)(2*xm - xa);
                    if xb >= h continue;
                    if rows[xa][col] != rows[xb][col] continue row;
                }
            }

            part1 += cast(s64)ceil(xm) * 100;
        }
    }

    return tprint("%", part1), tprint("%", 0);
}