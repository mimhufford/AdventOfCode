day3 :: (input: string) -> string, string
{
    part1, part2 := 0, 0;

    schematic := split(input, "\n");

    for row, y: schematic
    {
        for x: 0..row.count-1
        {
            if is_digit(row[x])
            {
                part_number, length := read_part_number(row, x);

                if part_number_next_to_symbol(schematic, y, x, x + length - 1)
                {
                    part1 += part_number;
                }

                x += length;
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
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

part_number_next_to_symbol :: (schematic: []string, y: int, x0: int, x1: int) -> bool
{
    if x0 > 1                    && schematic[y][x0-1] != #char "." return true;
    if x1 < schematic[y].count-1 && schematic[y][x1+1] != #char "." return true;

    left  := max(x0 - 1, 0);
    right := min(x1 + 1, schematic[0].count-1);

    if y > 0 for left..right
    {
        char := schematic[y-1][it];
        if char == #char "." continue;
        if !is_digit(char) return true;
    }
        
    if y < schematic.count-1 for left..right
    {
        char := schematic[y+1][it];
        if char == #char "." continue;
        if !is_digit(char) return true;
    }

    return false;
}