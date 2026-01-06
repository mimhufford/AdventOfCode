main :: () {
    #insert #run generate_days();

    total_time : Apollo_Time;

    for days {
        input := read_entire_file(tprint("input/%.txt", formatInt(it_index + 1, minimum_digits=2)));
        start := current_time_monotonic();
        part1, part2 := it(input);
        duration := current_time_monotonic() - start;
        total_time += duration;
        print("Day %: %ms - %\n",
            formatInt(it_index + 1, minimum_digits=2),
            tprint("%", formatFloat(0.001 * to_microseconds(duration), width=7, trailing_width=3, zero_removal=.NO)),
            tprint("% - %", part1, part2)
        );
    }

    print("\nTotal time: %ms\n", to_milliseconds(total_time));
}

read_up_to :: (s: *string, end: u8) -> string {
    result := string.{ data = s.data, count = 0 };
    while s.count && s.data[0] != end { result.count += 1; advance(s); }
    return result;
}

is_whitespace :: (c: u8) -> bool {
    return c == " " || c == "\n" || c == "\r" || c == "\t";
}

get :: ($T: Type, s: *string) -> T {
    #if T == string { 
        word := string.{ data = s.data, count = 0 };
        while s.count && !is_whitespace(s.data[0]) { word.count += 1; advance(s); }
        while s.count &&  is_whitespace(s.data[0]) { advance(s); }
        return word;
    } else {
        num : T;
        
        #if T == s8 || T == s16 || T == s32 || T == s64 {
            while s.count && s.data[0] != "-" && (s.data[0] < "0" || s.data[0] > "9") advance(s);
            neg := s.count && s.data[0] == "-";
            if neg advance(s);
        } else {
            while s.count && (s.data[0] < "0" || s.data[0] > "9") advance(s);
        }

        while s.count && s.data[0] >= "0" && s.data[0] <= "9" {
            num = num * 10 + (s.data[0] - "0");
            advance(s);
        }

        while s.count && is_whitespace(s.data[0]) advance(s);

        #if T == s8 || T == s16 || T == s32 || T == s64 {
            return ifx neg then -num else num;
        } else {
            return num;
        }
    } 
}

lcm :: (a: s64, b: s64) -> s64 { return a / gcd(a, b) * b; }
gcd :: (a: s64, b: s64) -> s64 { if b return gcd(b, a % b); return a; }

#import "File";
#import "Sort";
#import "Math";
#import "Hash";
#import "Basic";
#import "String";
#import "Thread";
#import "Random";
#import "Bit_Array";
#import "Hash_Table";
#import "Sloppy_Math";
#import "File_Utilities";
#import "Bit_Operations";

#scope_file

generate_days :: () -> string {
    day_procs, file_loads : String_Builder;

    append(*day_procs, "days := #type (string) -> (string, string).[");
    for 1..25 {
        file := tprint("%.jai", formatInt(it, minimum_digits=2));
        if !file_exists(file) continue;
        append(*day_procs, tprint("day%,", it));
        append(*file_loads, tprint("#load \"%.jai\";", formatInt(it, minimum_digits=2)));
    }
    append(*day_procs, "];");

    return tprint("%\n%\n", builder_to_string(*day_procs), builder_to_string(*file_loads));
}