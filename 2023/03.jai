day3 :: (input: string) -> string, string
{
    gear_ratios : Table(s64, Gear_Ratio);

    part1, part2 := 0, 0;

    schematic := split(input, "\n");

    for row, y: schematic
    {
        for x: 0..row.count-1
        {
            if is_digit(row[x])
            {
                part_number, length := read_part_number(row, x);
                next_to_symbol, symbol, sx, sy := part_number_next_to_symbol(schematic, y, x, x + length - 1);
                x += length;

                if next_to_symbol
                {
                    part1 += part_number;

                    if symbol == #char "*"
                    {
                        gear_ratio := find_or_add(*gear_ratios, sx << 32 | sy);
                        gear_ratio.x = xx sx;
                        gear_ratio.y = xx sy;
                        array_add(*gear_ratio.gears, part_number);
                    }
                }
            }
        }
    }

    for * gear_ratios
    {
        if it.gears.count != 2 continue;
        part2 += it.gears[0] * it.gears[1];
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file;

Gear_Ratio :: struct
{
    x, y : s32;
    gears : [..]s64;
    
    #place x; id : s64;
}

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

part_number_next_to_symbol :: (schematic: []string, y: int, x0: int, x1: int) -> bool, u8, s64, s64
{
    left  := max(x0 - 1, 0);
    right := min(x1 + 1, schematic[0].count-1);

    if left  == x0-1 && schematic[y][left]  != #char "." return true, schematic[y][left],  left,  y;
    if right == x1+1 && schematic[y][right] != #char "." return true, schematic[y][right], right, y;

    if y > 0 for left..right
    {
        char := schematic[y-1][it];
        if !is_digit(char) && char != #char "." return true, char, it, y-1;
    }
        
    if y < schematic.count-1 for left..right
    {
        char := schematic[y+1][it];
        if !is_digit(char) && char != #char "." return true, char, it, y+1;
    }

    return false, 0, 0, 0;
}