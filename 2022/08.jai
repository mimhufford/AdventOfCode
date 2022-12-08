day8 :: (input: string) -> string, string
{
    lines := split(input, "\n");
    lines.count -= 1;
    cols  := lines[0].count;
    rows  := lines.count;

    visible_from_outside := rows*2 + cols*2 - 4;

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
        }
    }

    return tprint("%", visible_from_outside), tprint("%", "");
}