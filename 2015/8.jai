day8 :: (input: string) -> string, string
{
    code := 0;
    memory := 0;
    encoded := 0;

    while input.count
    {
        if input[0] == #char "\\" && input[1] == #char "\\"
        {
            code += 2;
            memory += 1;
            advance(*input, 2);
        }
        else if input[0] == #char "\\" && input[1] == #char "\""
        {
            code += 2;
            memory += 1;
            encoded += 4;
            advance(*input, 2);
        }
        else if input[0] == #char "\\" && input[1] == #char "x"
        {
            code += 4;
            memory += 1;
            encoded += 5;
            advance(*input, 4);
        }
        else if input [0] == #char "\n"
        {
            advance(*input, 1);
            memory -= 2;
        }
        else
        {
            if input[0] == #char "\"" encoded += 2;

            code += 1;
            memory += 1;
            encoded += 1;
            advance(*input, 1);
        }
    }

    return tprint("%", code - memory), tprint("%", encoded - code);
}