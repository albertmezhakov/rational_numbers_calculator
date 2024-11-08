(*
 * Project: RationalNumbersCalculator
 * User: BerhtAdal
 * Date: 26.10.2024
 *)
program TestReaderCommands;
uses ParserHelper;

var
  input: char;
  input_buffer: buffer_aray;
  command: ParserHelper.command_type;
  sign: ParserHelper.sign_type;
  number_system, status, pointer, finish_status: Integer;
  numerator_first_num, denominator_first_num,comment: Boolean;
  numerator: longint;
  denominator, numerator_temp, denominator_temp: longword;

begin
  status := 0;
  command := 0;
  number_system := 0;
  sign := 0;
  pointer := 1;
  numerator_first_num := true;
  denominator_first_num := true;
  numerator := 0;
  denominator := 1;
  numerator_temp := 0;
  denominator_temp := 1;
  finish_status := 0;
  comment := false;
  while true do
  begin
    Read(input);
    status := ExecuteCommand(input, numerator_first_num, sign, comment,
                              number_system, pointer, status, command,
                              numerator_temp, numerator, denominator_temp, denominator);
    status := CheckFihish(input, status, finish_status);
    if CheckHaveComment(input, comment) then continue;

    case status of
      -10: break;
      -3: status := 0;
      -1: continue;
      0: status := InputCommandSymbol(input, command);
      1: status := InputSpaceAfterCommand(input);
      2: status := InputFirstSymbolsNumberSystems(input, number_system);
      3: status := InputSymbolsNumberSystems(input, number_system);
      4: status := InputSpaceAfterColomn(input);
      5: status := InputSignOrFirstNumbersNumerator(input, sign, numerator_first_num, input_buffer, numerator_temp, number_system, pointer);
      6: status := InputNumbersNumerator(input, numerator_first_num, input_buffer, numerator_temp, number_system, pointer);
      7: status := InputNumbersDenominator(input, input_buffer, denominator_temp,denominator_first_num, number_system, pointer);
    end;


  end;


end.