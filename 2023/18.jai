day18 :: (input: string) -> string, string
{
    steps1, steps2 : s64;
    points1, points2: [..][2]s64;
    array_add(*points1, .[0, 0]);
    array_add(*points2, .[0, 0]);
    x1, y1, x2, y2 := 0;

    while input.count
    {
        dir1 := input;
        dir1.count = 1;
        advance(*input, 2);
        dist1 := read_u8(*input);
        advance(*input, 2);
        dist2str := input;
        dist2str.count = 5;
        dist2 := string_to_int(dist2str, base=16);
        advance(*input, 5);
        dir2 := input;
        dir2.count = 1;
        skip_to_next_line(*input);

        if      dir1 == "L" x1 -= dist1;
        else if dir1 == "R" x1 += dist1;
        else if dir1 == "U" y1 -= dist1;
        else                y1 += dist1;
        array_add(*points1, .[x1, y1]);
        steps1 += dist1;

        if      dir2 == "2" x2 -= dist2;
        else if dir2 == "0" x2 += dist2;
        else if dir2 == "3" y2 -= dist2;
        else                y2 += dist2;
        array_add(*points2, .[x2, y2]);
        steps2 += dist2;
    }

    part1, part2 := 0, 0;
    for i: 0..points1.count-1
    {
        a := points1[i];
        b := points1[(i+points1.count-1)%points1.count];
        part1 += b[0] * a[1] - b[1] * a[0];
    }
    part1 = part1 / 2 + steps1 / 2 + 1;

    for i: 0..points2.count-1
    {
        a := points2[i];
        b := points2[(i+points2.count-1)%points2.count];
        part2 += b[0] * a[1] - b[1] * a[0];
    }
    part2 = part2 / 2 + steps2 / 2 + 1;

    return tprint("%", part1), tprint("%", part2);
}