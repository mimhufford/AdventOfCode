#import "Basic";
#import "Bit_Array";
#import "File";
#import "String";

main :: ()
{
    init_time();

    total_time : float64;

    days : [] () -> (string, string) = .[ day1, day2, day3 ];

    for days
    {
        day_start := get_time();
        part1, part2 := it();
        day_time := get_time() - day_start;
        total_time += day_time;
        print("\nDay % - %ms\n", it_index+1, day_time*1000);
        print("- Part 1: %\n", part1);
        print("- Part 2: %\n", part2);
    }

    print("\nTotal time: %s", total_time);
}

// Solutions
day1 :: () -> string, string
{
    part1, part2 : string;

    entries := int_lines(1);
    last_index := entries.count - 1;

    for i1 : 0..last_index
    {
        e1 := entries[i1];

        for i2 : i1+1..last_index
        {
            e2 := entries[i2];

            if e1 + e2 == 2020
            {
                part1 = tprint("%", e1 * e2);
                if part2 return part1, part2;
            } 

            if e1 + e2 >= 2020  continue;

            for i3 : i2+1..last_index
            {
                e3 := entries[i3];

                if e1 + e2 + e3 == 2020
                {
                    part2 = tprint("%", e1 * e2 * e3);
                    if part1 return part1, part2;
                } 
            }
        }
    }

    return part1, part2;
}

day2 :: () -> string, string
{
    valid_passwords_rule_1 := 0;
    valid_passwords_rule_2 := 0;

    data := input(2);

    for i : 0..data.count-1
    {
        min := 0;
        while #char "0" <= data[i] && data[i] <= #char "9"
        {
            min = min * 10 + data[i] - #char "0";
            i += 1;
        } 

        i += 1; // skip the -

        max := 0;
        while #char "0" <= data[i] && data[i] <= #char "9"
        {
            max = max * 10 + data[i] - #char "0";
            i += 1;
        } 

        i += 1; // skip the space

        chr := data[i];

        i += 3; // skip the chr:space

        if (data[i+min-1] == chr) ^ (data[i+max-1] == chr)
        {
            valid_passwords_rule_2 += 1;
        } 

        count := 0;

        while i < data.count && data[i] != #char "\n"
        {
            if data[i] == chr
            {
                count += 1;
            } 

            i += 1;
        }

        if min <= count && count <= max
        {
            valid_passwords_rule_1 += 1;
        }
    }

    return tprint("%", valid_passwords_rule_1), tprint("%", valid_passwords_rule_2);
}

day3 :: () -> string, string
{
    lines := string_lines(3);
    map : [..]Bit_Array;
    for line : lines
    {
        row := make_bit_array(line.count);
        for i : 0..line.count-1
        {
            if line[i] == #char "#" set_bit(*row, i);
        }
        array_add(*map, row);
    }

    check_slope :: (map: []Bit_Array, dx : int, dy : int) -> int
    {
        x, y := 0, 0;
        count := 0;

        while y < map.count-1
        {
            x += dx;
            x %= map[0].count;
            y += dy;
            if map[y][x] count += 1;
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

// Input utilities
input :: (day : int) -> string
{
    return read_entire_file(tprint("input/%.txt", day));
}

ints :: (day : int, separator : string) -> []int
{
    nums := split(input(day), separator);
    ints : [..]int;
    for nums array_add(*ints, string_to_int(it));
    return ints;
}

string_lines :: (day : int) -> []string { return split(input(day), "\n"); }
int_lines :: (day : int) -> []int { return ints(day, "\n"); }
int_csv :: (day : int) -> []int { return ints(day, ","); }