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
            visible_l, visible_r, visible_u, visible_d := true;
            for < l: x-1..0       if lines[y][l] >= lines[y][x]  { visible_l = false; break; }
            for   r: x+1..cols-1  if lines[y][r] >= lines[y][x]  { visible_r = false; break; }
            for < u: y-1..0       if lines[u][x] >= lines[y][x]  { visible_u = false; break; }
            for   d: y+1..rows-1  if lines[d][x] >= lines[y][x]  { visible_d = false; break; }
            visible_from_outside += cast(s64)(visible_l || visible_r || visible_u || visible_d);

            vl, vr, vu, vd := 0;
            for < l: x-1..0       { vl += 1; if lines[y][l] >= lines[y][x] break; }
            for   r: x+1..cols-1  { vr += 1; if lines[y][r] >= lines[y][x] break; }
            for < u: y-1..0       { vu += 1; if lines[u][x] >= lines[y][x] break; }
            for   d: y+1..rows-1  { vd += 1; if lines[d][x] >= lines[y][x] break; }
            best_scenic_score = max(best_scenic_score, vl * vr * vu * vd);
        }
    }

    return tprint("%", visible_from_outside), tprint("%", best_scenic_score);
}