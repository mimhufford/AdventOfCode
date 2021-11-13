main :: ()
{
    #insert #run generate_day_procedures();

    init_time();

    total_time : float64;

    for days
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

generate_day_procedures :: () -> string
{
    code : String_Builder;

    append(*code, "days := #type (string) -> (string, string).[");
    for 1..25 {
        file := tprint("%.jai", it);
        if !file_exists(file) continue;
        append(*code, tprint("day%,", it));
    }
    append(*code, "];");

    for 1..25 {
        file := tprint("%.jai", it);
        if !file_exists(file) continue;
        append(*code, tprint("#load \"%.jai\";", it));
    }

    return builder_to_string(*code);
}

#import "File";
#import "Basic";
#import "String";
#import "Thread";
#import "Hash_Table";
#import "File_Utilities";