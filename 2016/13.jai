day13 :: (data: string) -> string, string
{
    explore :: (id: s64, x : s64 = 1, y : s64 = 1, steps : s64 = 0)
    {
        if steps > 50 return;
        if x < 0 || y < 0 return;
        if !walkable(id, x, y) return;

        hash := x << 32 | y;
        prev := table_find_pointer(seen, hash);
        if prev && <<prev < steps return;
        if prev { <<prev = steps; }
        else table_add(*seen, hash, steps);

        print("% %\n", x, y);

        explore(id, x+1, y, steps + 1);
        explore(id, x-1, y, steps + 1);
        explore(id, x, y+1, steps + 1);
        explore(id, x, y-1, steps + 1);
    }

    explore(xx string_to_int(data));

    target := <<table_find_pointer(seen, 31<<32|39);
    
    return tprint("%", target), tprint("%", seen.count);
}

#scope_file;

seen : Table(s64, s64);

walkable :: (id: s64, x: s64, y: s64) -> bool { return popcount(x*x + 3*x + 2*x*y + y + y*y + id) % 2 == 0; }