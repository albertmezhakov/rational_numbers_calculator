(*
 * Project: RationalNumbersCalculator
 * Date: 08.11.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit parser_helper;

interface

uses types;

  function CheckFihish(input: char; var status: Integer; var finish_status: Integer): Integer;

  function CheckHaveComment(input: char; var comment: Boolean): Boolean;

  function ConvertCharNumberToInteger(number: char): Integer;

  function CovertNumberToInteger(var input_buffer: types.buffer_aray; number_system: Integer): Integer;

  function InputCommandSymbol(input: char; var command: types.command_type): Integer;

  function InputSpaceAfterCommand(input: char): Integer;

  function InputSpaceAfterColomn(input: char): Integer;

  function InputFirstSymbolsNumberSystems(input: char; var number_system: Integer): Integer;

  function InputSymbolsNumberSystems(input: char; var number_system: Integer): Integer;


  function InputNumbersNumerator(input: char; var numerator_first_num: Boolean; var input_buffer: types.buffer_aray;
                                    var numerator: LongWord; var number_system, pointer: Integer): Integer;

  function InputSignOrFirstNumbersNumerator(input: char; var sign: types.sign_type; var numerator_first_num: Boolean;
                                               var input_buffer: types.buffer_aray; var numerator: LongWord;
                                               var number_system, pointer: Integer): Integer;

  function InputNumbersDenominator(input: char; var input_buffer: types.buffer_aray; var denominator: LongWord; var denominator_first_num: Boolean; var number_system, pointer: Integer): Integer;


implementation

uses limits_helper, sysutils;

function CheckFihish(input: char; var status: Integer; var finish_status: Integer): Integer;
begin
  if (status = 0) or (status = -1) then
  begin
    if (input = 'f') and (finish_status = 0) then
    begin
      finish_status := 1;
      exit(-1);
    end;
    if (input = 'i') and (finish_status = 1) then
    begin
      finish_status := 2;
      exit(-1);
    end;
    if (input = 'n') and (finish_status = 2) then
    begin
      finish_status := 3;
      exit(-1);
    end;
    if (input = 'i') and (finish_status = 3) then
    begin
      finish_status := 4;
      exit(-1);
    end;
    if (input = 's') and (finish_status = 4) then
    begin
      finish_status := 5;
      exit(-1);
    end;
    if (input = 'h') and (finish_status = 5) then
    begin
      exit(-10);
    end;
    if (finish_status = 0) then
    begin
      exit(0);
    end else begin
      WriteLn('finish_structure_error');
      Halt;
    end;
  end else
  begin
    exit(status);
  end;
end;

function CheckHaveComment(input: char; var comment: Boolean): Boolean;
begin
  if comment then exit(true);
  if (input = '#') then
  begin
    comment := true;
    CheckHaveComment := true;
  end
  else CheckHaveComment := false;

end;

function ConvertCharNumberToInteger(number: char): Integer;
begin
  case LowerCase(number) of
    '0': ConvertCharNumberToInteger := 0;
    '1': ConvertCharNumberToInteger := 1;
    '2': ConvertCharNumberToInteger := 2;
    '3': ConvertCharNumberToInteger := 3;
    '4': ConvertCharNumberToInteger := 4;
    '5': ConvertCharNumberToInteger := 5;
    '6': ConvertCharNumberToInteger := 6;
    '7': ConvertCharNumberToInteger := 7;
    '8': ConvertCharNumberToInteger := 8;
    '9': ConvertCharNumberToInteger := 9;
    'a': ConvertCharNumberToInteger := 10;
    'b': ConvertCharNumberToInteger := 11;
    'c': ConvertCharNumberToInteger := 12;
    'd': ConvertCharNumberToInteger := 13;
    'e': ConvertCharNumberToInteger := 14;
    'f': ConvertCharNumberToInteger := 15;
  end;
end;

function CovertNumberToInteger(var input_buffer: types.buffer_aray; number_system: Integer): Integer;
var
  number: Integer;
begin
  number := ConvertCharNumberToInteger(input_buffer[1]) * 15 + ConvertCharNumberToInteger(input_buffer[2]);
  if number >= number_system then
  begin
    WriteLn('incorect_number(number_bigger_then_number_system) ');
    Halt;
  end;
  CovertNumberToInteger := number;
end;

function InputCommandSymbol(input: char; var command: types.command_type): Integer;
begin
  if input = ' ' then exit(0);
  case input of
    '+': command := 1;
    '-': command := 2;
    '*': command := 3;
    '/': command := 4;
  else
  begin
    if ('0' <= input) and (input <= '9') then
    begin
      WriteLn('missing_operation');
      Halt;
    end;
    WriteLn('invalid_operation_symbol');
    Halt;
  end;
  end;
  InputCommandSymbol := 1;
end;

function InputSpaceAfterCommand(input: char): Integer;
begin
  if input = ' ' then
  begin
    InputSpaceAfterCommand := 2;
  end
  else begin
    WriteLn('missing_required_whitespace_after_operation');
    Halt;
  end;
end;

function InputFirstSymbolsNumberSystems(input: char; var number_system: Integer): Integer;
begin
  if input = ' ' then exit(2);
  if input = ':' then
  begin
    WriteLn('missing_radix');
    Halt;
  end;
  if not (('0' <= input) and (input <= '9')) then
  begin
    WriteLn('invalid_radix_format');
    Halt;
  end;
  InputFirstSymbolsNumberSystems := 3;
  InputSymbolsNumberSystems(input, number_system);
end;

function InputSymbolsNumberSystems(input: char; var number_system: Integer): Integer;
begin
  if input = ' ' then
  begin
    WriteLn('missing_colomn');
    Halt;
  end;
  if input = ':' then
  begin
    if (number_system < 257) and (number_system < 2) then
    begin
      WriteLn('radix_out_of_range');
      Halt;
    end;
    exit(4);
  end;
  if not (('0' <= input) and (input <= '9')) then
  begin
    WriteLn('invalid_radix_format');
    Halt;
  end;
  number_system := number_system * 10 + StrToInt(input);
  if number_system > 256 then
  begin
    WriteLn('radix_out_of_range');
    Halt;
  end;
  InputSymbolsNumberSystems := 3;
end;

function InputSpaceAfterColomn(input: char): Integer;
begin
  if input = ' ' then
  begin
    InputSpaceAfterColomn := 5;
  end
  else begin
    WriteLn('missing_required_whitespace_after_colomn');
    Halt;
  end;
end;

function InputNumbersNumerator(input: char; var numerator_first_num: Boolean; var input_buffer: types.buffer_aray; var numerator: LongWord; var number_system, pointer: Integer): Integer;
begin

  if (input = '/') and numerator_first_num then
  begin
    WriteLn('mising_numerator');
    Halt;
  end;
  if (pointer = 1) and (input = ' ') and numerator_first_num then
  begin
    WriteLn('unexpected_whitespace_after_sign');
    Halt;
  end;

  if (pointer = 2) and (input = ' ') then
  begin
    WriteLn('unexpected_whitespace_in_number(numerator)');
    Halt;
  end;

  if (pointer = 1) and (input = ' ') then
  begin
    exit(6)
  end;

  if (input = '/') and not numerator_first_num then
  begin
    exit(7)
  end;
  numerator_first_num := false;
  if ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f'))) and (pointer < 3) then
  begin
    input_buffer[pointer] := input;
    pointer := pointer + 1;
  end;

  if (pointer = 3) then
  begin
    if not IsWithinLongIntLimits(numerator, number_system, CovertNumberToInteger(input_buffer, number_system)) then
    begin
      WriteLn('limit_longint');
      Halt;
    end;
    numerator := numerator * number_system + CovertNumberToInteger(input_buffer, number_system);
    pointer := 1;
  end;
  InputNumbersNumerator := 6;
end;

function InputSignOrFirstNumbersNumerator(input: char; var sign: types.sign_type; var numerator_first_num: Boolean; var input_buffer: types.buffer_aray; var numerator: LongWord; var number_system, pointer: Integer): Integer;
begin
  if not ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f')) or (input = '+') or (input = '-')) then
  begin
    if input = ' ' then
    begin
      WriteLn('max_one_whitespace_after_colon');
      Halt;
    end;
    if input = '/' then
    begin
      WriteLn('mising_numerator');
      Halt;
    end;
    WriteLn('invalid_sign_or_numerator__symbol');
    Halt;
  end;
  case input of
    '+': sign := 0;
    '-': sign := 1;
  else sign := 0
  end;
  if (('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f')) then
  begin
    InputNumbersNumerator(input, numerator_first_num, input_buffer, numerator, number_system, pointer);
    InputSignOrFirstNumbersNumerator := 6;
  end
  else begin
    InputSignOrFirstNumbersNumerator := 6;
  end;
end;

function  InputNumbersDenominator(input: char; var input_buffer: types.buffer_aray; var denominator: LongWord; var denominator_first_num: Boolean; var number_system, pointer: Integer): Integer;
begin

  if (pointer = 2) and (input = ' ') then
  begin
    WriteLn('unexpected_whitespace_in_number(denominator)');
    Halt
  end;

  if (pointer = 1) and (input = ' ') then
  begin
    exit(7);
  end;

  if ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f'))) and (pointer < 3) then
  begin
    input_buffer[pointer] := input;
    pointer := pointer + 1;
  end;

  if (pointer = 3) then
  begin
    if not IsWithinLongWordLimits(denominator, number_system, CovertNumberToInteger(input_buffer, number_system)) then
    begin
      WriteLn('limit_longint');
      Halt;
    end;
    if denominator_first_num then
      denominator := 0;
    denominator_first_num := false;
    denominator := denominator * number_system + CovertNumberToInteger(input_buffer, number_system);
    pointer := 1;
  end;
  InputNumbersDenominator := 7;
end;

end.