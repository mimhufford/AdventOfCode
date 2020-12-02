#import "Basic";
#import "String";
#import "File";

main :: ()
{
    init_time();

    total_time : float64;

    days : [] () -> (string, string) = .[ day1, day2 ];

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
    part1, part2 : string;

    valid_passwords_rule_1 := 0;
    valid_passwords_rule_2 := 0;
    passwords := string_lines(2);

    for passwords
    {
        parts := split(it, "-");
        min := parse_int(*parts[0]);
        max := parse_int(*parts[1]);
        advance(*parts[1], 1);
        chr := parts[1][0];
        advance(*parts[1], 3);
        password := parts[1];

        count := 0;
        for i : 0..password.count-1 if chr == password[i] count += 1;

        if min <= count && count <= max valid_passwords_rule_1 += 1;

        if (password[min-1] == chr) ^ (password[max-1] == chr) valid_passwords_rule_2 += 1;
    }

    part1 = tprint("%", valid_passwords_rule_1);
    part2 = tprint("%", valid_passwords_rule_2);

    return part1, part2;
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