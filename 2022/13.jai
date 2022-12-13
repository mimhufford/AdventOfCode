day13 :: (input: string) -> string, string
{
    part1 := 0;
    
    index := 0;
    while input
    {
        index += 1;
        a := parse_packet(*input);
        b := parse_packet(*input);

        if is_ordered(a, b) part1 += index;
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

is_ordered :: (a: *Item, b: *Item) -> bool
{
    // NOTE: in progress

    // if a.is_val && b.is_val
    // {
    //     return a.value < b.value; // nope
    // }

    // if a.is_val
    // {
    //     new := New(Item);
    //     array_add(*new.items, a);
    //     return is_ordered(new, b);
    // }
    
    // if b.is_val
    // {
    //     new := New(Item);
    //     array_add(*new.items, b);
    //     return is_ordered(a, new);
    // }

    return true;
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