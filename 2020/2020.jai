#import "Basic";
#import "File";
#import "Hash_Table";
#import "String";
#import "Thread";

main :: ()
{
    init_time();

    total_time : float64;

    for days // days array generated in build.jai
    {
        input := read_entire_file(tprint("input/%.txt", it_index + 1));
        day_start := get_time();
        part1, part2 := it(input);
        day_time := get_time() - day_start;
        total_time += day_time;
        print("\nDay % - %ms\n", it_index+1, day_time*1000);
        print("- Part 1: %\n", part1);
        print("- Part 2: %\n", part2);
    }

    print("\nTotal time: %s", total_time);
}