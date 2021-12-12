day8 :: (input: string) -> string, string
{
    code := 0;
    memory := 0;

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
            advance(*input, 2);
        }
        else if input[0] == #char "\\" && input[1] == #char "x"
        {
            code += 4;
            memory += 1;
            advance(*input, 4);
        }
        else if input [0] == #char "\n"
        {
            advance(*input, 1);
            memory -= 2;
        }
        else
        {
            code += 1;
            memory += 1;
            advance(*input, 1);
        }
    }

    return tprint("%", code - memory), tprint("%", "");
}