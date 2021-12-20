day19 :: (data : string) -> string, string
{
    scanners: [..]Scanner;

    while data.count array_add(*scanners, read_scanner(*data));

    for * scanners
    {
        for i: 0..it.beacons.count-1
        {
            for j: i+1..it.beacons.count-1
            {
                a := it.beacons[i];
                b := it.beacons[j];
                d := distance_squared(a, b);
                bs : [3]int;
                bs[0] = it_index;
                bs[1] = i;
                bs[2] = j;
                // relying on all points being a unique distance apart
                assert(!table_find_pointer(it.distances, d));
                table_add(*it.distances, d, bs);
            }
        }
    }

    return tprint("%", ""), tprint("%", "");
}

/*
       +z
        | / +y
        |/
 -x ----o---- +x
       /|
   -y / |
       -z

*/

Scanner :: struct
{
    pos : Vector3;
    dir := Vector3.{0, 1, 0};
    up  := Vector3.{0, 0, 1};
    beacons : [..]Vector3;
    distances : Table(float, [3]int);
}

read_scanner :: (s: *string) -> Scanner
{
    scanner : Scanner;

    while s.data[0] != #char "\n" advance(s, 1);
    advance(s, 1);

    while s.count && s.data[0] != #char "\n"
    {
        array_add(*scanner.beacons, make_vector3(read_num(), read_num(), read_num()));
    }

    if s.count advance(s, 1);

    return scanner;

    read_num :: () -> float #expand
    {
        num : float;
        neg := false;
        
        if s.data[0] == #char "-"
        {
            neg = true;
            advance(s, 1);
        }

        while s.data[0] >= #char "0" && s.data[0] <= #char "9"
        {
            num *= 10;
            num += s.data[0] - #char "0";
            advance(s, 1);
        }

        advance(s, 1);

        return ifx neg then -num else num;
    }
}