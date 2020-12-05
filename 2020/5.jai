day5 :: () -> string, string
{
    data := input(5);

    highest_seat_id := 0;

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
    }

    return tprint("%", highest_seat_id), "";
}