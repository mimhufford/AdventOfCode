results : [..]Day;
start_time : Apollo_Time;

main :: ()
{
    #insert #run generate_days();

    array_reserve(*results, 25);
    start_time = current_time_monotonic();

    thread_group : Thread_Group;
    thread_group.logging = false;
    init(*thread_group, 8, do_day);
    start(*thread_group);

    for days
    {
        day := array_add(*results);
        day.day   = xx (it_index + 1);
        day.input = read_entire_file(tprint("input/%.txt", formatInt(day.day, minimum_digits=2)));
        day.proc  = it;
        add_work(*thread_group, day);
    }

    output_results();

    completed := 0;
    while completed < results.count
    {
        sleep_milliseconds(1);
        done := get_completed_work(*thread_group);
        completed += done.count;
        if done.count output_results();
    }
}

output_results :: ()
{
    print("\x1B[2J\x1B[H"); // clear the console

    total_time := current_time_monotonic() - start_time;
    total_time_serial : Apollo_Time;

    for results
    {
        if it.done total_time_serial += it.duration;

        print("Day %: %ms - %\n",
            formatInt(it.day, minimum_digits=2),
            ifx it.done tprint("%", formatInt(to_milliseconds(it.duration), minimum_digits=4, padding=#char" ")) else "    ",
            ifx it.done tprint("% - %", it.part1, it.part2)
        );
    }

    print("\nTotal time: %ms (%ms)\n", to_milliseconds(total_time), to_milliseconds(total_time_serial));
}

do_day :: (group: *Thread_Group, thread: *Thread, work: *void) -> Thread_Continue_Status
{
    start := current_time_monotonic();
    day := cast(*Day)work;
    day.part1, day.part2 = day.proc(day.input);
    day.duration = current_time_monotonic() - start;
    day.done = true;
    return .CONTINUE;
}

Day :: struct
{
    day : u8;
    input : string;
    proc : (string) -> string, string;
    part1, part2 : string;
    duration : Apollo_Time;
    done : bool;
}

generate_days :: () -> string
{
    day_procs  : String_Builder;
    file_loads : String_Builder;

    append(*day_procs, "days := #type (string) -> (string, string).[");
    for 1..25 {
        file := tprint("%.jai", formatInt(it, minimum_digits=2));
        if !file_exists(file) continue;
        append(*day_procs, tprint("day%,", it));
        append(*file_loads, tprint("#load \"../%.jai\";", formatInt(it, minimum_digits=2)));
    }
    append(*day_procs, "];");

    return tprint("%\n%\n", builder_to_string(*day_procs), builder_to_string(*file_loads));
}

#import "File";
#import "Sort";
#import "Math";
#import "Basic";
#import "String";
#import "Thread";
#import "Bit_Array";
#import "Hash_Table";
#import "File_Utilities";
#import "Bit_Operations";

// Iterators e.g. for u16s("234 543 984") print("%\n", it);
u8s  :: s => ints(u8,  s);
u16s :: s => ints(u16, s);
u32s :: s => ints(u32, s);
u64s :: s => ints(u64, s);
s8s  :: s => ints(s8,  s);
s16s :: s => ints(s16, s);
s32s :: s => ints(s32, s);
s64s :: s => ints(s64, s);

for_expansion :: (i: *IntIterator, body: Code, flags: For_Flags) #expand
{
    `it_index := 0;

    while i.s.count > 0
    {
        skip_whitespace(*i.s);
        `it := read_number(i.T, *i.s);
        #insert body;
        `it_index += 1;
    }
}

// Consume elements from a string e.g. num := read_u8(*str);
read_u8  :: s => read_number(u8,  s);
read_u16 :: s => read_number(u16, s);
read_u32 :: s => read_number(u32, s);
read_u64 :: s => read_number(u64, s);
read_s8  :: s => read_number(s8,  s);
read_s16 :: s => read_number(s16, s);
read_s32 :: s => read_number(s32, s);
read_s64 :: s => read_number(s64, s);

read_word :: (s: *string) -> string
{
    word := <<s;
    word.count = 0;

    while s.count && !is_whitespace(s.data[0])
    {
        word.count += 1;
        advance(s);
    }

    skip_whitespace(s);

    return word;
}

skip_whitespace :: (s: *string)
{
    while s.count && is_whitespace(s.data[0])
    {
        advance(s);
    }
}

is_whitespace :: (c: u8) -> bool
{
    return c == #char " " || c == #char "\n" || c == #char "\r" || c == #char "\t";
}

skip_to_next_line :: (s: *string)
{
    while s.count && s.data[0] != #char "\n" advance(s);
    if s.count advance(s);
}

read_number :: ($T: Type, s: *string, $skip_trailing_whitespace := true) -> T
{
    num : T;
    
    #if T == s8 || T == s16 || T == s32 || T == s64
    {
        neg : bool;

        if s.count && s.data[0] == #char "-"
        {
            neg = true;
            advance(s);
        }
    }

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    #if skip_trailing_whitespace skip_whitespace(s);

    #if T == s8 || T == s16 || T == s32 || T == s64
    {
        return ifx neg then -num else num;
    }
    else
    {
        return num;
    }
}

#scope_file;

ints :: ($T: Type, s: string) -> IntIterator(T)
{
   i : IntIterator(T) = ---;
   i.s = s;
   return i;
}

IntIterator :: struct ($T: Type)
{
    s: string;
}