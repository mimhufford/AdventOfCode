day10 :: (input: string) -> string, string
{
    adapters : [..]u8;

    array_add(*adapters, 0); // outlet
    while input.count array_add(*adapters, read_number(*input));
    quick_sort(adapters, i => i);
    array_add(*adapters, adapters[adapters.count-1] + 3); // device

    diff1, diff3 := 0;
    for i: 0..adapters.count-2
    {
        diff := adapters[i+1] - adapters[i];
        if      diff == 1 diff1 += 1;
        else if diff == 3 diff3 += 1;
    }

    return tprint("%", diff1*diff3), "";
}

#scope_file

#import "Sort";

read_number :: (s: *string) -> u8
{
    num : u8;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    if s.count advance(s, 1);

    return num;
}