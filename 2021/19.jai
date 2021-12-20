day19 :: (data : string) -> string, string
{
    scanners: [..]Scanner;
    beacons : [..]Vector3; // will add to this as beacons are reoriented to scanners[0]

    while data.count array_add(*scanners, read_scanner(*data));

    // going to re-orient everything to scanners[0], so add those beacons to the found list
    for scanners[0].beacons array_add(*beacons, it);

    // pre-calculate the distances between visible beacons to help find matches
    // if another scanner has the same bunch of distances it can be re-oriented
    // to check that beacons do all overlap
    for * scanners calculate_distances_between_all_beacon_pairs(it);

    return tprint("%", beacons.count), tprint("%", "");
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
    beacons : [..]Vector3;
    distances : Table(float, [2]int); // distance => beacon[i], beacon[j]
}

calculate_distances_between_all_beacon_pairs :: (s: *Scanner)
{
    for i: 0..s.beacons.count-1
    {
        for j: i+1..s.beacons.count-1
        {
            a := s.beacons[i];
            b := s.beacons[j];
            d := distance_squared(a, b);
            bs : [2]int;
            bs[0] = i;
            bs[1] = j;
            assert(!table_find_pointer(s.distances, d)); // relying on all points being a unique distance apart
            table_add(*s.distances, d, bs);
        }
    }
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