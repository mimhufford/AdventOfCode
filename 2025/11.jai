day11 :: (input: string) -> string, string
{
    part1, part2 : s64;

    devices := parse_devices(input);

    you := table_find_pointer(*devices, "you");
    out := table_find_pointer(*devices, "out");
    svr := table_find_pointer(*devices, "svr");

    part1 = count_paths(you, out, check = false);
    table_reset(*cache);
    part2 = count_paths(svr, out, check = true);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Device :: struct {
    id: string;
    output_devices: [..]*Device;
    output_ids: [..]string;
}

cache : Table(u32, s64);

count_paths :: (start: *Device, end: *Device, fft := false, dac := false, check := false) -> s64 {
    if start == end {
        if check return ifx fft && dac then 1 else 0;
        return 1;
    }

    key : u32;
    key |= (start.id[0].(u32) << 0);
    key |= (start.id[1].(u32) << 8);
    key |= (start.id[2].(u32) << 16);
    key |= ifx check && fft then (cast(u32, 1) << 25);
    key |= ifx check && dac then (cast(u32, 1) << 26);

    cached_result := table_find_pointer(*cache, key);
    if cached_result return cached_result.*;

    paths := 0;
    
    for start.output_devices {
        paths += count_paths(it, end, fft || it.id == "fft", dac || it.id == "dac", check);
    }

    table_add(*cache, key, paths);
    
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
        d := table_find_pointer(*devices, id);
        for oid: split(outs, " ") {
            od := table_find_pointer(*devices, oid);
            array_add(*d.output_devices, od);
            array_add(*d.output_ids, oid);
        }
    }

    return devices;
}