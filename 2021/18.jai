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

add :: (l: *Number, r: *Number) -> *Number
{
    n := New(Number);
    n.v = -1;
    n.l = l;
    n.r = r;
    return n;
}

magnitude :: (n: *Number) -> s64
{
    if n.v >= 0 return n.v;
    return 3 * magnitude(n.l) + 2 * magnitude(n.r);
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