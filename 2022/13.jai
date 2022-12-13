day13 :: (input: string) -> string, string
{
    packets : [..]*Item;

    while input array_add(*packets, parse_packet(*input));

    part1 := 0;
    for 0..packets.count/2-1
    {
        if is_ordered(packets[it*2], packets[it*2+1]) < 0
        {
            part1 += (it+1);
        }
    }

    div1 := make_divider(2);
    div2 := make_divider(6);
    array_add(*packets, div1);
    array_add(*packets, div2);
    quick_sort(packets, is_ordered);
    
    part2 := 1;
    for packets if it == div1 || it == div2 part2 *= it_index+1;
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Item :: struct
{
    items : [..]*Item;
    value : u8;
}

make_divider :: (value: u8) -> *Item
{
    d   := New(Item);
    dd  := New(Item);
    ddv := New(Item);
    ddv.value = value + 1;
    array_add(*d.items,  dd);
    array_add(*dd.items, ddv);
    return d;
}

is_ordered :: (a: *Item, b: *Item) -> s8
{
    a_length := a.items.count;
    b_length := b.items.count;
    length   := min(a_length, b_length);

    for 0..length-1
    {
        ai := a.items[it];
        bi := b.items[it];

        if ai.value && bi.value
        {
            if ai.value < bi.value return -1;
            if ai.value > bi.value return  1;
        }
        else if !ai.value && !bi.value
        {
            result := is_ordered(ai, bi);
            if result != 0 return result;
        }
        else if ai.value && !bi.value
        {
            new := New(Item);
            array_add(*new.items, ai);
            result := is_ordered(new, bi);
            if result != 0 return result;
        }
        else if !ai.value && bi.value
        {
            new := New(Item);
            array_add(*new.items, bi);
            result := is_ordered(ai, new);
            if result != 0 return result;
        }
    }

    if a_length < b_length return -1;
    if a_length > b_length return  1;
    return 0;
}

parse_packet :: (s: *string) -> *Item
{
    packet := New(Item);

    stack : [..]*Item;
    array_add(*stack, packet);

    advance(s); // skip opening [

    while s.count && s.data[0] != #char "\n"
    {
        if s.data[0] == #char "["
        {
            new := New(Item);
            array_add(*peek(stack).items, new);
            array_add(*stack, new);
            advance(s);
        }
        else if s.data[0] == #char "]"
        {
            pop(*stack);
            advance(s);
        }
        else if s.data[0] == #char ","
        {
            advance(s);
        }
        else
        {
            new := New(Item);
            new.value = read_number(u8, s, skip_trailing_whitespace=false) + 1;
            array_add(*peek(stack).items, new);
        }
    }

    skip_whitespace(s);

    return packet;
}