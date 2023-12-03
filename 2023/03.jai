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

                x += length;
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
    num := 0;
    len := 0;
    data := s;
    advance(*data, offset);

    while data.count && is_digit(data.data[0])
    {
        num *= 10;
        num += data.data[0] - #char "0";
        advance(*data);
        len += 1;
    }

    return num, len;
}

part_number_next_to_symbol :: (schematic: []string, y: int, x0: int, x1: int) -> bool, u8, s64, s64
{
    if x0 > 1                    && schematic[y][x0-1] != #char "." return true, schematic[y][x0-1], x0-1, y;
    if x1 < schematic[y].count-1 && schematic[y][x1+1] != #char "." return true, schematic[y][x1+1], x1+1, y;

    left  := max(x0 - 1, 0);
    right := min(x1 + 1, schematic[0].count-1);

    if y > 0 for left..right
    {
        char := schematic[y-1][it];
        if char == #char "." continue;
        if !is_digit(char) return true, schematic[y-1][it], it, y-1;
    }
        
    if y < schematic.count-1 for left..right
    {
        char := schematic[y+1][it];
        if char == #char "." continue;
        if !is_digit(char) return true, schematic[y+1][it], it, y+1;
    }

    return false, 0, 0, 0;
}