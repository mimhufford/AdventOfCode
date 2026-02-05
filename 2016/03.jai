day3 :: (data: string) -> string, string
{
    triangles : [..]Vector3;

    lines := split(data, "\n");
    lines.count -= 1;

    valid_rows := 0;
    valid_cols := 0;

    valid :: (a: float, b: float, c: float) -> int
    {
        return xx (a+b > c && a+c > b && b+c > a);
    }

    for * lines
    {
        it.* = trim_left(it.*);
        t : Vector3;
        t.x = xx next_u16(it);
        t.y = xx next_u16(it);
        t.z = xx next_u16(it);
        array_add(*triangles, t);

        valid_rows += valid(t.x, t.y, t.z);
    }

    for 0..triangles.count / 3 - 1
    {
        a := triangles[it*3+0];
        b := triangles[it*3+1];
        c := triangles[it*3+2];

        valid_cols += valid(a.x, b.x, c.x);
        valid_cols += valid(a.y, b.y, c.y);
        valid_cols += valid(a.z, b.z, c.z);
    }

    return tprint("%", valid_rows), tprint("%", valid_cols);
}