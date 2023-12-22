day22 :: (input: string) -> string, string
{
    bricks : [..]Brick;

    while input
    {
        b := array_add(*bricks);
        b.x1 = read_s64(*input);          advance(*input);
        b.y1 = read_s64(*input);          advance(*input);
        b.z1 = read_s64(*input);          advance(*input);
        b.x2 = read_s64(*input);          advance(*input);
        b.y2 = read_s64(*input);          advance(*input);
        b.z2 = read_s64(*input); if input advance(*input);
    }

    part1, part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Brick :: struct
{
    x1, x2, y1, y2, z1, z2 : s64;
}