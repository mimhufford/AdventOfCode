day18 :: (data : string) -> string, string
{
    nums := parse_snailfish_numbers(*data);

    result := nums[0];

    for 1..nums.count-1
    {
        result = add(result, nums[it]);
        reduce(result);
    }

    return tprint("%", magnitude(result)), tprint("%", "");
}

Number :: struct
{
    v : s64; // -1 == non-leaf
    l : *Number;
    r : *Number;
    p : *Number;
}

left_of :: (n: *Number) -> *Number
{
    if !n.p return null;
    if n.p.l == n return left_of(n.p);
    if n.p.l.v >= 0 return n.p.l;
    r := n.p.l.r;
    while r.v < 0 r = r.r;
    return r;
}

right_of :: (n: *Number) -> *Number
{
    if !n.p return null;
    if n.p.r == n return right_of(n.p);
    if n.p.r.v >= 0 return n.p.r;
    l := n.p.r.l;
    while l.v < 0 l = l.l;
    return l;
}

reduce :: (n: *Number)
{
    while true
    {
        if explode(n) continue;
        if split(n)   continue;
        break;
    }
}

split :: (n: *Number) -> bool
{
    if n.v >= 10
    {
        n.l = New(Number);
        n.r = New(Number);
        n.l.p = n;
        n.r.p = n;
        n.l.v = (n.v + 0) / 2;
        n.r.v = (n.v + 1) / 2;
        n.v = -1;
        return true;   
    }

    if n.l && split(n.l) return true;
    if n.r && split(n.r) return true;

    return false;
}

explode :: (n: *Number, d := 0) -> bool
{
    if n.v >= 0 return false;

    if d == 4
    {
        l := left_of(n);
        r := right_of(n);
        if l l.v += n.l.v;
        if r r.v += n.r.v;
        n.v = 0;
        n.l = null;
        n.r = null;
        return true;
    }

    if explode(n.l, d+1) return true;
    if explode(n.r, d+1) return true;

    return false;
}

add :: (l: *Number, r: *Number) -> *Number
{
    n := New(Number);
    n.v = -1;
    n.l = l;
    n.r = r;
    n.l.p = n;
    n.r.p = n;
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
        array_add(*nums, parse_number(s));
        advance(s, 1); // skip the \n
    }

    return nums;

    parse_number :: (s: *string) -> *Number
    {
        n := New(Number);
        n.v = -1;

        advance(s, 1); // skip the [

        if s.data[0] == #char "["
        {
            n.l = parse_number(s);
            n.l.p = n;
        }
        else
        {
            n.l = New(Number);
            n.l.v = s.data[0] - #char "0";
            n.l.p = n;
            advance(s, 1);
        }
        
        advance(s, 1); // skip the ,

        if s.data[0] == #char "["
        {
            n.r = parse_number(s);
            n.r.p = n;
        }
        else
        {
            n.r = New(Number);
            n.r.v = s.data[0] - #char "0";
            n.r.p = n;
            advance(s, 1);
        }

        advance(s, 1); // skip the ]

        return n;
    }
}