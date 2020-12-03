day3 :: () -> string, string
{
    map := string_lines(3);

    check_slope :: (map: []string, dx : int, dy : int) -> int
    {
        height := map.count;
        width := map[0].count;
        x, y, count := 0, 0, 0;

        while y < height-1
        {
            x = (x + dx) % width;
            y += dy;
            if map[y][x] == #char "#" count += 1;
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