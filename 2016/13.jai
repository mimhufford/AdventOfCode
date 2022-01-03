day13 :: (data: string) -> string, string
{
    id := string_to_int(data);
    explore_50_steps(xx id);
    locations_reachable_in_50_steps := seen.count;
    steps_to_31_39 := steps_to(xx id, 31, 39);
    return tprint("%", steps_to_31_39), tprint("%", locations_reachable_in_50_steps);
}

#scope_file;

seen : Table(s64, s64);

walkable :: (id: s64, x: s64, y: s64) -> bool { return popcount(x*x + 3*x + 2*x*y + y + y*y + id) % 2 == 0; }

explore_50_steps :: (id: s64, x : s64 = 1, y : s64 = 1, steps : s64 = 0)
{
    if steps > 50 return;
    if x < 0 || y < 0 return;
    if !walkable(id, x, y) return;

    hash := x << 32 | y;
    prev := table_find_pointer(seen, hash);
    if prev && <<prev < steps return;
    if prev { <<prev = steps; }
    else table_add(*seen, hash, steps);

    explore_50_steps(id, x+1, y, steps + 1);
    explore_50_steps(id, x-1, y, steps + 1);
    explore_50_steps(id, x, y+1, steps + 1);
    explore_50_steps(id, x, y-1, steps + 1);
}

steps_to :: (id: s64, tx: s64, ty: s64, x : s64 = 1, y : s64 = 1, steps : s64 = 0) -> s64
{
    if x == tx && y == ty return steps;

    hash := x << 32 | y;
    prev := table_find_pointer(seen, hash);
    if prev && <<prev < steps return S64_MAX;
    if prev { <<prev = steps; }
    else table_add(*seen, hash, steps);

    if x < 0 || y < 0 return S64_MAX;
    if !walkable(id, x, y) return S64_MAX;

    return min(
        steps_to(id, tx, ty, x+1, y, steps + 1),
        steps_to(id, tx, ty, x-1, y, steps + 1),
        steps_to(id, tx, ty, x, y+1, steps + 1),
        steps_to(id, tx, ty, x, y-1, steps + 1),
    );
}