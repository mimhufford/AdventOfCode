day5 :: (data: string) -> string, string
{
    highest_seat_id := 0;
    seats : [1024]u8;

    for i: 0..data.count - 1
    {
        seat_id := 0;
        if data[i] == #char "B" seat_id |= 1<<9; i += 1;
        if data[i] == #char "B" seat_id |= 1<<8; i += 1;
        if data[i] == #char "B" seat_id |= 1<<7; i += 1;
        if data[i] == #char "B" seat_id |= 1<<6; i += 1;
        if data[i] == #char "B" seat_id |= 1<<5; i += 1;
        if data[i] == #char "B" seat_id |= 1<<4; i += 1;
        if data[i] == #char "B" seat_id |= 1<<3; i += 1;
        if data[i] == #char "R" seat_id |= 1<<2; i += 1;
        if data[i] == #char "R" seat_id |= 1<<1; i += 1;
        if data[i] == #char "R" seat_id |= 1<<0; i += 1;

        if seat_id > highest_seat_id  highest_seat_id = seat_id;
        seats[seat_id] = 1;
    }

    for 1..1022
    {
        if seats[it-1] == 1 && seats[it] == 0 && seats[it+1] == 1
        {
            return tprint("%", highest_seat_id), tprint("%", it);
        }
    }

    return "ERROR", "ERROR";
}