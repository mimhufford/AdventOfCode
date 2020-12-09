#import "Basic";
#import "File";
#import "Hash_Table";
#import "String";

main :: ()
{
    init_time();

    total_time : float64;

    for days // days array generated in build.jai
    {
        TIMES :: 1;
        input := read_entire_file(tprint("input/%.txt", it_index + 1));
        part1, part2 : string;
        day_start := get_time();
        for i: 1..TIMES { reset_temporary_storage(); part1, part2 = it(input); }
        day_time := (get_time() - day_start) / TIMES;
        total_time += day_time;
        print("\nDay % - %ms\n", it_index+1, day_time*1000);
        print("- Part 1: %\n", part1);
        print("- Part 2: %\n", part2);
    }

    print("\nTotal time: %s", total_time);
}