day3 :: () -> string, string
{
    lines := string_lines(3);
    map : [..]Bit_Array;
    for line : lines
    {
        row := make_bit_array(line.count);
        for i : 0..line.count-1
        {
            if line[i] == #char "#" set_bit(*row, i);
        }
        array_add(*map, row);
    }

    check_slope :: (map: []Bit_Array, dx : int, dy : int) -> int
    {
        x, y := 0, 0;
        count := 0;

        while y < map.count-1
        {
            x += dx;
            x %= map[0].count;
            y += dy;
            if map[y][x] count += 1;
        }

        return count;
    }

    s1 := check_slope(map, 1, 1);
    s2 := check_slope(map, 3, 1);
    s3 := check_slope(map, 5, 1);
    s4 := check_slope(map, 7, 1);
    s5 := check_slope(map, 1, 2);

    return tprint("%", s2), tprint("%", s1*s2*s3*s4*s5);
}