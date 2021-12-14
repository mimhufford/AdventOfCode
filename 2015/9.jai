day9 :: (data: string) -> string, string
{
    places : Table(string, Place);

    while data.count
    {
        a_name := read_place(*data);  advance(*data, 4);
        b_name := read_place(*data);  advance(*data, 3);
        dist := read_distance(*data); advance(*data, 1);

        a := find_or_create(*places, a_name);
        b := find_or_create(*places, b_name);

        ab : Edge; ab.place = b_name; ab.dist = dist;
        ba : Edge; ba.place = a_name; ba.dist = dist;

        array_add(a, ab);
        array_add(b, ba);
    }

    shortest := U16_MAX;
    longest  : u16;

    for edges, place : places explore(places, place, *shortest, *longest);

    return tprint("%", shortest), tprint("%", longest);
}

Place :: [..]Edge;

Edge :: struct
{
    place : string;
    dist  : u16;
}

explore :: (places : Table, place : string, shortest : *u16, longest : *u16)
{
    impl :: (places : Table, place : string, visited : [..]string, shortest : *u16, longest : *u16, distance : u16 = 0)
    {
        if array_find(visited, place) return;
        array_add(*visited, place);
        if visited.count == places.count
        { 
            if (distance < <<shortest) { <<shortest = distance; }
            if (distance > <<longest)  { <<longest  = distance; }
            return;
        }
        edges := <<table_find_pointer(places, place);
        for edges impl(places, it.place, visited, shortest, longest, distance + it.dist);
    }
    
    visited : [..]string;
    impl(places, place, visited, shortest, longest);
}

find_or_create :: (places : *Table, place : string) -> *Place
{
    ep := table_find_pointer(<<places, place);
    if ep return ep;

    np : Place;
    return table_add(places, place, np);
}

read_distance :: (s : *string) -> u16
{
    result : u16;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result *= 10;
        result += s.data[0] - #char "0";
        advance(s, 1);
    }

    return result;
}

read_place :: (s : *string) -> string
{
    result : string = ---;
    result.data = s.data;
    result.count = 0;

    while s.count && s.data[0] != #char " " && s.data[0] != #char "\n"
    {
        advance(s, 1);
        result.count += 1;
    }

    return result;
}