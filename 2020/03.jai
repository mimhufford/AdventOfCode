day3 :: (data: string) -> string, string
{
    width, height := 0, 0;
    for 0..data.count-1
    {
        if data[it] == #char "\n" { width = 0; height += 1; }
        else { width += 1; }
    }

    check_slope :: (data: string, width: int, height: int, dx: int, dy: int) -> int
    {
        x, y, count := 0, 0, 0;

        while y < height-1
        {
            x = (x + dx) % width;
            y += dy;
            index := y*(width+1) + x;
            if data[index] == #char "#" count += 1;
        }

        return count;
    }

    s1 := check_slope(data, width, height, 1, 1);
    s2 := check_slope(data, width, height, 3, 1);
    s3 := check_slope(data, width, height, 5, 1);
    s4 := check_slope(data, width, height, 7, 1);
    s5 := check_slope(data, width, height, 1, 2);

    return tprint("%", s2), tprint("%", s1*s2*s3*s4*s5);
}