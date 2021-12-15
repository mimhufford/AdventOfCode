main :: ()
{
    #insert #run generate_days();

    init_time();

    total_time : float64;

    for days
    {
        input := read_entire_file(tprint("input/%.txt", formatInt(it_index+1, minimum_digits=2)));
        day_start := get_time();
        part1, part2 := it(input);
        day_time := get_time() - day_start;
        total_time += day_time;
        print("Day % ", formatInt(it_index+1, minimum_digits=2));
        print("- %ms ", formatFloat(day_time*1000, width=7, trailing_width=3, zero_removal=.NO));
        print("- % ", part1);
        print("- %\n", part2);
    }

    print("\nTotal time: %ms\n", total_time*1000);
}

generate_days :: () -> string
{
    code : String_Builder;

    append(*code, "days := #type (string) -> (string, string).[");
    for 1..25 {
        file := tprint("%.jai", formatInt(it, minimum_digits=2));
        if !file_exists(file) continue;
        append(*code, tprint("day%,", it));
    }
    append(*code, "];");

    for 1..25 {
        file := tprint("%.jai", formatInt(it, minimum_digits=2));
        if !file_exists(file) continue;
        append(*code, tprint("#load \"%.jai\";", formatInt(it, minimum_digits=2)));
    }

    return builder_to_string(*code);
}

#import "File";
#import "Sort";
#import "Math";
#import "Basic";
#import "String";
#import "Thread";
#import "Hash_Table";
#import "File_Utilities";
#import "Bit_Operations";

next_num :: (s: *string, $T: Type) -> T #expand
{
    num : T;
    
    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    while s.count && (s.data[0] < #char "0" || s.data[0] > #char "9")
    {
        advance(s, 1);
    }

    return num;
}

next_u8  :: s => next_num(s, u8 );
next_u16 :: s => next_num(s, u16);
next_u32 :: s => next_num(s, u32);
next_u64 :: s => next_num(s, u64);
next_s8  :: s => next_num(s, s8 );
next_s16 :: s => next_num(s, s16);
next_s32 :: s => next_num(s, s32);
next_s64 :: s => next_num(s, s64);