#import "Basic";
#import "File";
#import "String";

main :: ()
{
    init_time();

    total_time : float64;

    days : [] () -> (string, string) = .[ day1, day2, day3, day4, day5, day6, day7 ];

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
#load "1.jai";
#load "2.jai";
#load "3.jai";
#load "4.jai";
#load "5.jai";
#load "6.jai";
#load "7.jai";

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