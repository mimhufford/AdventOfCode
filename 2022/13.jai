day13 :: (input: string) -> string, string
{
    packets : [..]*Item;

    while input array_add(*packets, parse_packet(*input));

    part1 := 0;
    for 0..packets.count/2-1
    {
        if is_ordered(packets[it*2], packets[it*2+1]) == 1
        {
            part1 += (it+1);
        }
    }
    
    return tprint("%", part1), tprint("%", "");
}

#scope_file

Item :: struct
{
    parent : *Item;
    items  : [..]*Item;
    value  : u8;
    is_val : bool;
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

        if ai.is_val && bi.is_val
        {
            if ai.value < bi.value return  1;
            if ai.value > bi.value return -1;
        }
        else if !ai.is_val && !bi.is_val
        {
            result := is_ordered(ai, bi);
            if result != 0 return result;
        }
        else if ai.is_val && !bi.is_val
        {
            new := New(Item);
            array_add(*new.items, ai);
            result := is_ordered(new, bi);
            if result != 0 return result;
        }
        else if !ai.is_val && bi.is_val
        {
            new := New(Item);
            array_add(*new.items, bi);
            result := is_ordered(ai, new);
            if result != 0 return result;
        }
    }

    if a_length < b_length return  1;
    if a_length > b_length return -1;
    return 0;
}

print :: (using i: *Item)
{
    if is_val print(" % ", value);
    if is_val return;
    print("[");
    for items print(it);
    print("]");
}

parse_packet :: (s: *string) -> *Item
{
    packet := New(Item);
    current := packet;

    advance(s); // skip opening [

    while s.count && s.data[0] != #char "\n"
    {
        if s.data[0] == #char "["
        {
            new := New(Item);
            new.parent = current;
            array_add(*current.items, new);
            current = new;
            advance(s);
        }
        else if s.data[0] == #char "]"
        {
            current = current.parent;
            advance(s);
        }
        else if s.data[0] == #char ","
        {
            advance(s);
        }
        else
        {
            new := New(Item);
            new.parent = current;
            new.is_val = true;
            new.value = read_number(u8, s, skip_trailing_whitespace=false);
            array_add(*current.items, new);
        }
    }

    skip_whitespace(s);

    return packet;
}