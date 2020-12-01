#import "Basic";
#import "String";
#import "File";

main :: ()
{
    init_time();

    total_time : float64;

    days : [] () -> (string, string) = .[ day1 ];

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

    for i1 : 0..entries.count-1
    {
        for i2 : i1+1..entries.count-1
        {
            e1 := entries[i1];
            e2 := entries[i2];
            if e1 + e2 == 2020  part1 = tprint("%", e1 * e2);

            for i3 : i2+1..entries.count-1
            {
                e3 := entries[i3];
                if e1 + e2 + e3 == 2020  part2 = tprint("%", e1 * e2 * e3);

                if part1 && part2  return part1, part2;
            }
        }
    }

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