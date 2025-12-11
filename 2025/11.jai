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

    while input {
        id := read_up_to(*input, ":");
        advance(*input); // skip ":""

        device := find_or_add(*devices, id);
        device.id = id;

        while input[0] != "\n" {
            advance(*input); // skip " "
            output_id := input;
            output_id.count = 3;
            advance(*input, 3);
            
            output_device := find_or_add(*devices, output_id);
            output_device.id = output_id;
            array_add(*device.output_ids, output_id);
        }
        advance(*input); // skip "\n"
    }

    for * d: devices {
        for output_id: d.output_ids {
            array_add(*d.output_devices, table_find_pointer(*devices, output_id));
        }
    }

    return devices;
}