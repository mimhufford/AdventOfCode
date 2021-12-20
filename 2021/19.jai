day19 :: (data : string) -> string, string
{
    scanners: [..]Scanner;
    sauron:   Scanner; // will see everything, beacons will be merged into it as they are matched

    while data.count array_add(*scanners, read_scanner(*data));

    // pre-calculate the distances between visible beacons to help find matches
    // if another scanner has the same bunch of distances it can be re-oriented
    // to check that beacons do all overlap
    for * scanners calculate_distances_between_all_beacon_pairs(it);

    // going to re-orient everything to scanners[0], so make sauron start as scanner[0]
    sauron = scanners[0];

    // and take it out the list so we don't look at it any more
    array_unordered_remove_by_index(*scanners, 0);

    while scanners.count
    {
        // find the scanner with the most beacons that overlap with what sauron can see
        scanner_index_to_merge_in := find_scanner_with_most_potential_overlaps(sauron, scanners);

        // reorient the scanner, match the beacons, and merge them into sauron
        merge_into_sauron(*sauron, *scanners[scanner_index_to_merge_in]);

        // and take it out the list so we don't look at it again
        array_unordered_remove_by_index(*scanners, scanner_index_to_merge_in);
    }

    return tprint("%", sauron.beacons.count), tprint("%", "");
}

Scanner :: struct
{
    position : Vector3;
    beacons : [..]Vector3;
    distances : Table(float, [2]int); // distance => beacon[i], beacon[j]
}

calculate_distances_between_all_beacon_pairs :: (s: *Scanner)
{
    table_reset(*s.distances);

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

find_scanner_with_most_potential_overlaps :: (sauron: Scanner, scanners: []Scanner) -> int
{
    most_distance_matches := 0;
    best_scanner_index    := 0;

    for 0..scanners.count-1
    {
        distance_matches := 0;
        for indexes, distance: scanners[it].distances
        {
            if table_find_pointer(sauron.distances, distance)
            {
                distance_matches += 1;
            }
        }

        if distance_matches > most_distance_matches
        {
            most_distance_matches = distance_matches;
            best_scanner_index = it;
        }
    }

    return best_scanner_index;
}

merge_into_sauron :: (sauron: *Scanner, s: *Scanner)
{
    // find a matching pair, there are 2 of each because it's not clear which ones match yet
    s_beacons, sauron_beacons := find_beacons_to_match_on(sauron, s);

    // test all the different orientation for the scanner
    for orientation: 1..24
    {
        reorient_scanner(s, orientation);

        offset := sauron.beacons[sauron_beacons[0]] - s.beacons[s_beacons[0]];

        print("% % % %\n", sauron.beacons[sauron_beacons[0]], s.beacons[s_beacons[0]] + offset,
                           sauron.beacons[sauron_beacons[1]], s.beacons[s_beacons[1]] + offset);

        if sauron.beacons[sauron_beacons[1]] == s.beacons[s_beacons[1]] + offset
        {
            print("MATCH");
        }

        // TODO
        // calculate the offset to make at least 12 beacons overlap
        // remove duplicates
        // merge the reoriented and offset beacons into sauron
    }

    // now sauron can see more, recalculate distance pairs for next match
    calculate_distances_between_all_beacon_pairs(sauron);
}

find_beacons_to_match_on :: (sauron: *Scanner, s: *Scanner) -> [2]int, [2]int
{
    for indexes, distance: s.distances
    {
        match := table_find_pointer(sauron.distances, distance);
        
        if match return indexes, <<match;
    }

    assert(false);
    return .[0, 0], .[0, 0];
}

reorient_scanner :: (s: *Scanner, orientation: int)
{
    for * d: s.beacons
    {
        s := <<d;

        if orientation ==
        {
            case  1;  d.x, d.y, d.z = +s.x, +s.y, +s.z;
            case  2;  d.x, d.y, d.z = +s.x, -s.z, +s.y;
            case  3;  d.x, d.y, d.z = +s.x, -s.y, -s.z;
            case  4;  d.x, d.y, d.z = +s.x, +s.z, -s.y;
            case  5;  d.x, d.y, d.z = -s.x, -s.y, +s.z;
            case  6;  d.x, d.y, d.z = -s.x, +s.z, +s.y;
            case  7;  d.x, d.y, d.z = -s.x, +s.y, -s.z;
            case  8;  d.x, d.y, d.z = -s.x, -s.z, -s.y;
            case  9;  d.x, d.y, d.z = +s.y, -s.x, +s.z;
            case 10;  d.x, d.y, d.z = +s.y, -s.z, -s.x;
            case 11;  d.x, d.y, d.z = +s.y, +s.x, -s.z;
            case 12;  d.x, d.y, d.z = +s.y, +s.z, +s.x;
            case 13;  d.x, d.y, d.z = -s.y, +s.x, +s.z;
            case 14;  d.x, d.y, d.z = -s.y, +s.z, -s.x;
            case 15;  d.x, d.y, d.z = -s.y, -s.x, -s.z;
            case 16;  d.x, d.y, d.z = -s.y, -s.z, +s.x;
            case 17;  d.x, d.y, d.z = +s.z, -s.x, -s.y;
            case 18;  d.x, d.y, d.z = +s.z, +s.y, -s.x;
            case 19;  d.x, d.y, d.z = +s.z, +s.x, +s.y;
            case 20;  d.x, d.y, d.z = +s.z, -s.y, +s.x;
            case 21;  d.x, d.y, d.z = -s.z, +s.x, -s.y;
            case 22;  d.x, d.y, d.z = -s.z, -s.y, -s.x;
            case 23;  d.x, d.y, d.z = -s.z, -s.x, +s.y;
            case 24;  d.x, d.y, d.z = -s.z, +s.y, +s.x;
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