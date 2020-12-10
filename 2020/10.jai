day10 :: (input: string) -> string, string
{
    adapters : [..]Adapter;

    array_add(*adapters, .{}); // outlet
    while input.count array_add(*adapters, read_number(*input));
    quick_sort(adapters, i => i.jolts);
    array_add(*adapters, .{}); // device
    adapters[adapters.count-1].jolts = adapters[adapters.count-2].jolts + 3;

    diff1, diff3 := 0;
    for i: 0..adapters.count-2
    {
        diff := adapters[i+1].jolts - adapters[i].jolts;
        if      diff == 1 diff1 += 1;
        else if diff == 3 diff3 += 1;

        // gather possible connections
        for j: i+1..adapters.count-1
        {
            a := *adapters[i];
            b := *adapters[j];
            diff1 := b.jolts - a.jolts;
            if diff1 <= 3 array_add(*a.children, b);
            else break;
        }
    }

    return tprint("%", diff1*diff3), tprint("%", arrangements_for(*adapters[0]));
}

#scope_file

#import "Sort";

Adapter :: struct
{
    jolts : u8;
    ways_to_reach_device : u64;
    children : [..]*Adapter;
}

arrangements_for :: (a: *Adapter) -> u64
{
    if a.ways_to_reach_device > 0 return a.ways_to_reach_device;
    if a.children.count == 0 return 1;
    count : u64 = 0;
    for a.children count += arrangements_for(it);
    a.ways_to_reach_device = count;
    return count;
}

read_number :: (s: *string) -> Adapter
{
    adapter : Adapter;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        adapter.jolts *= 10;
        adapter.jolts += s.data[0] - #char "0";
        advance(s, 1);
    }

    if s.count advance(s, 1);

    return adapter;
}