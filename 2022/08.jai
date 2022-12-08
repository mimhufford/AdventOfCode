day8 :: (input: string) -> string, string
{
    lines := split(input, "\n");
    lines.count -= 1;
    cols  := lines[0].count;
    rows  := lines.count;

    visible_from_outside := rows*2 + cols*2 - 4;
    best_scenic_score    := 0;

    for y: 1..rows-2
    {
        for x: 1..cols-2
        {
            count_l, count_r, count_u, count_d := 0;
            for < l: x-1..0       { count_l += 1; if lines[y][l] >= lines[y][x] break; }
            for   r: x+1..cols-1  { count_r += 1; if lines[y][r] >= lines[y][x] break; }
            for < u: y-1..0       { count_u += 1; if lines[u][x] >= lines[y][x] break; }
            for   d: y+1..rows-1  { count_d += 1; if lines[d][x] >= lines[y][x] break; }
            best_scenic_score = max(best_scenic_score, count_l * count_r * count_u * count_d);
            visible_from_outside += cast(s64)(
                count_l == x         && lines[y][0     ] < lines[y][x] ||
                count_r == cols-1-x  && lines[y][cols-1] < lines[y][x] ||
                count_u == y         && lines[0     ][x] < lines[y][x] ||
                count_d == rows-1-y  && lines[rows-1][x] < lines[y][x]
            );
        }
    }

    return tprint("%", visible_from_outside), tprint("%", best_scenic_score);
}