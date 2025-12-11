day11 :: (input: string) -> string, string
{
    part1, part2 : s64;

    devices := parse_devices(input);

    you := table_find_pointer(*devices, "you");
    out := table_find_pointer(*devices, "out");
    part1 = count_paths(you, out);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Device :: struct {
    id: string;
    output_devices: [..]*Device;
    output_ids: [..]string;
}

count_paths :: (start: *Device, end: *Device) -> s64 {
    if start == end return 1;
    paths := 0;
    for start.output_devices paths += count_paths(it, end);
    return paths;
}

parse_devices :: (input: string) -> Table(string, Device) {
    devices : Table(string, Device);

    for line: split(input, "\n") {
        if !line continue;
        ok, id, outs := split_from_left(line, ": ");
        find_or_add(*devices, id).id = id;
        for oid: split(outs, " ") find_or_add(*devices, oid).id = oid;
    }

    for line: split(input, "\n") {
        if !line continue;
        ok, id, outs := split_from_left(line, ": ");
        d := find_or_add(*devices, id);
        for oid: split(outs, " ") {
            od := find_or_add(*devices, oid);
            array_add(*d.output_devices, od);
            array_add(*d.output_ids, oid);
        }
    }

    return devices;
}