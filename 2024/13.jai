day13 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input
    {
        advance(*input, 12); ax := read_s64(*input);
        advance(*input,  4); ay := read_s64(*input);
        advance(*input, 12); bx := read_s64(*input);
        advance(*input,  4); by := read_s64(*input);
        advance(*input,  9); tx := read_s64(*input);
        advance(*input,  4); ty := read_s64(*input);

        part1 += best_cost(ax, ay, bx, by, tx, ty);
        part2 += best_cost(ax, ay, bx, by, tx + 10000000000000, ty + 10000000000000);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

best_cost :: (ax: s64, ay: s64, bx: s64, by: s64, tx: s64, ty: s64) -> s64
{
    // Solve the following for a and b:
    //   (ax * a) + (bx * b) == tx
    //   (ay * a) + (by * b) == ty

    b := ((tx * ay) - (ty * ax)) / ((ay * bx) - (by * ax));
    a := ((tx * by) - (ty * bx)) / ((by * ax) - (bx * ay));

    if (ax * a) + (bx * b) != tx return 0;
    if (ay * a) + (by * b) != ty return 0;

    return (3 * a) + b;
}