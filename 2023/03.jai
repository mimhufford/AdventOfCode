day3 :: (input: string) -> string, string
{
    part1, part2 := 0, 0;
    gear_ratios : Table(s64, [..]s64);
    schematic := split(input, "\n");

    for row, y: schematic
    {
        for x: 0..row.count-1
        {
            if is_digit(row[x])
            {
                part_number, length := read_part_number(row, x);
                symbol, sx, sy := part_number_next_to_symbol(schematic, y, x, x + length - 1);
                x += length;

                if symbol
                {
                    part1 += part_number;

                    if symbol == #char "*"
                    {
                        gear_ratio := find_or_add(*gear_ratios, sx << 32 | sy);
                        array_add(gear_ratio, part_number);
                    }
                }
            }
        }
    }

    for gear_ratios
    {
        if it.count != 2 continue;
        part2 += it[0] * it[1];
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file;

read_part_number :: (s: string, offset: int) -> s64, s64
{
    num, length := 0;

    data := s;
    advance(*data, offset);

    while data.count && is_digit(data.data[0])
    {
        num *= 10;
        num += data.data[0] - #char "0";
        advance(*data);
        length += 1;
    }

    return num, length;
}

part_number_next_to_symbol :: (schematic: []string, y: int, x0: int, x1: int) -> u8, s64, s64
{
    left  := max(x0 - 1, 0);
    right := min(x1 + 1, schematic[0].count-1);

    if left  == x0-1 && schematic[y][left]  != #char "." return schematic[y][left],  left,  y;
    if right == x1+1 && schematic[y][right] != #char "." return schematic[y][right], right, y;

    if y > 0 for left..right
    {
        char := schematic[y-1][it];
        if !is_digit(char) && char != #char "." return char, it, y-1;
    }
        
    if y < schematic.count-1 for left..right
    {
        char := schematic[y+1][it];
        if !is_digit(char) && char != #char "." return char, it, y+1;
    }

    return 0, 0, 0;
}