day18 :: (data : string) -> string, string
{
    nums := parse_snailfish_numbers(*data);

    return tprint("%", ""), tprint("%", "");
}

Number :: struct
{
    v : s64; // -1 == non-leaf
    l : *Number;
    r : *Number;
}

dump :: (n: *Number)
{
    if n.v >= 0
    {
        print("%", n.v);
        return;
    }

    print("[");
    dump(n.l);
    print(",");
    dump(n.r);
    print("]");
}

parse_snailfish_numbers :: (s: *string) -> [..]*Number
{
    nums : [..]*Number;

    while s.count
    {
        array_add(*nums, parse_number(*s));
        advance(s, 1); // skip the \n
    }

    return nums;

    parse_number :: (s: **string) -> *Number
    {
        n := New(Number);
        n.v = -1;

        advance(<<s, 1); // skip the [

        if (<<s).data[0] == #char "["
        {
            n.l = parse_number(s);
        }
        else
        {
            n.l = New(Number);
            n.l.v = (<<s).data[0] - #char "0";
            advance(<<s, 1);
        }
        
        advance(<<s, 1); // skip the ,

        if (<<s).data[0] == #char "["
        {
            n.r = parse_number(s);
        }
        else
        {
            n.r = New(Number);
            n.r.v = (<<s).data[0] - #char "0";
            advance(<<s, 1);
        }

        advance(<<s, 1); // skip the ]

        return n;
    }
}