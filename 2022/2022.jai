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