day22 :: (data : string) -> string, string
{
    cubes : [..]Cube;

    while data.count
    {
        new_cube := read_cube(*data);

        to_add : [..]Cube;

        for existing_cube: cubes
        {
            intersects, cube_intersection := intersection(existing_cube, new_cube);
            if intersects
            {
                if equal(existing_cube, cube_intersection)
                {
                    remove existing_cube;
                }
                else if existing_cube.value == 1 && new_cube.value == 0
                {
                    cube_intersection.value = -1;
                    array_add(*to_add, cube_intersection);
                }
                else if existing_cube.value == 1 && new_cube.value == 1
                {
                    cube_intersection.value = -1;
                    array_add(*to_add, cube_intersection);
                }
                else if existing_cube.value == -1 && new_cube.value == 0
                {
                    cube_intersection.value = 1;
                    array_add(*to_add, cube_intersection);
                }
                else if existing_cube.value == -1 && new_cube.value == 1
                {
                    cube_intersection.value = 1;
                    array_add(*to_add, cube_intersection);
                }
            }
        }

        for to_add array_add(*cubes, it);
        if new_cube.value == 1 array_add(*cubes, new_cube);
    }

    part_1, part_2 : s64;

    for c: cubes
    {
        cube_worth := c.value * (c.x_max+1-c.x_min) * (c.y_max+1-c.y_min) * (c.z_max+1-c.z_min);

        part_2 += cube_worth;

        if c.x_min < -50 || c.x_max > 50 continue;
        if c.y_min < -50 || c.y_max > 50 continue;
        if c.z_min < -50 || c.z_max > 50 continue;

        part_1 += cube_worth;
    }

    return tprint("%", part_1), tprint("%", part_2);
}

intersection :: (a: Cube, b: Cube) -> bool, Cube
{
    if a.x_min > b.x_max return false, .{};
    if a.x_max < b.x_min return false, .{};
    if a.y_min > b.y_max return false, .{};
    if a.y_max < b.y_min return false, .{};
    if a.z_min > b.z_max return false, .{};
    if a.z_max < b.z_min return false, .{};

    c : Cube;

    c.x_min = max(a.x_min, b.x_min);
    c.x_max = min(a.x_max, b.x_max);
    c.y_min = max(a.y_min, b.y_min);
    c.y_max = min(a.y_max, b.y_max);
    c.z_min = max(a.z_min, b.z_min);
    c.z_max = min(a.z_max, b.z_max);

    return true, c;
}

equal :: (a: Cube, b: Cube) -> bool
{
    if a.x_min != b.x_min return false;
    if a.x_max != b.x_max return false;
    if a.y_min != b.y_min return false;
    if a.y_max != b.y_max return false;
    if a.z_min != b.z_min return false;
    if a.z_max != b.z_max return false;
    return true;
}

Cube :: struct
{
    value : s64;
    x_min, x_max : s32;
    y_min, y_max : s32;
    z_min, z_max : s32;
}

read_cube :: (s: *string) -> Cube
{
    c : Cube;

    if s.data[1] == #char "n" c.value = 1;
    advance(s, ifx c.value then 5 else 6);
    c.x_min = read_num(); advance(s, 2);
    c.x_max = read_num(); advance(s, 3);
    c.y_min = read_num(); advance(s, 2);
    c.y_max = read_num(); advance(s, 3);
    c.z_min = read_num(); advance(s, 2);
    c.z_max = read_num(); advance(s, 1);

    return c;

    read_num :: () -> s32 #expand
    {
        neg := false;
        num : s32;
        if s.data[0] == #char "-" { neg = true; advance(s, 1); }
        while s.data[0] >= #char "0" && s.data[0] <= #char "9"
        {
            num *= 10;
            num += s.data[0] - #char "0";
            advance(s, 1);
        }
        return ifx neg then -num else num;
    }
}