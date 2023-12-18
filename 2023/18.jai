day18 :: (input: string) -> string, string
{
    part1,  part2  := 0;
    perim1, perim2 : s64;
    point1, point2 : [2]s64;

    while input.count
    {
        dir1   := input; dir1.count   = 1; advance(*input, 2);
        dist1  := read_u8(*input);         advance(*input, 2);
        dist2s := input; dist2s.count = 5; advance(*input, 5);
        dir2   := input; dir2.count   = 1; skip_to_next_line(*input);
        dist2  := string_to_int(dist2s, base=16);

        perim1 += dist1;
        next_point1 := point1;
        if      dir1 == "L" next_point1[0] -= dist1;
        else if dir1 == "R" next_point1[0] += dist1;
        else if dir1 == "U" next_point1[1] -= dist1;
        else                next_point1[1] += dist1;

        perim2 += dist2;
        next_point2 := point2;
        if      dir2 == "2" next_point2[0] -= dist2;
        else if dir2 == "0" next_point2[0] += dist2;
        else if dir2 == "3" next_point2[1] -= dist2;
        else                next_point2[1] += dist2;

        part1 += (next_point1[0] + point1[0]) * (next_point1[1] - point1[1]);
        part2 += (next_point2[0] + point2[0]) * (next_point2[1] - point2[1]);
        point1 = next_point1;
        point2 = next_point2;
    }

    part1 = part1 / 2 + perim1 / 2 + 1;
    part2 = part2 / 2 + perim2 / 2 + 1;

    return tprint("%", part1), tprint("%", part2);
}