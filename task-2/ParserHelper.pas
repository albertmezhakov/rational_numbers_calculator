(*
 * Project: RationalNumbersCalculator
 * User: BerhtAdal
 * Date: 27.10.2024
 *)
unit ParserHelper;

interface


type
  command_type = 0..4;

  buffer_aray = array[1..2] of Char;

  sign_type = 0..1;
  function IsMultiplicationWithinLongIntLimits(a: longint; b: longword): boolean;

  function IsMultiplicationWithinLongWordLimits(a, b: longword): boolean;

  function IsWithinLongIntLimits(numerator: longint; number_system: integer; num: integer): boolean;

  function IsWithinLongWordLimits(denominator: longword; number_system: integer; num: integer): boolean;


  function CheckFihish(input: char; var status: Integer; var finish_status: Integer): Integer;

  function ExecuteCommand(input: char; var numerator_first_num: Boolean; var sign: sign_type; var comment: Boolean;
                             var number_system, pointer, status: Integer; var command: command_type;
                             var numerator_temp: LongWord; var numerator: LongInt; var denominator_temp: LongWord;
                             var denominator: LongWord): Integer;

  function CheckHaveComment(input: char; var comment: Boolean): Boolean;

  function ConvertCharNumberToInteger(number: char): Integer;

  function CovertNumberToInteger(var input_buffer: buffer_aray; number_system: Integer): Integer;

  function InputCommandSymbol(input: char; var command: command_type): Integer;

  function InputSpaceAfterCommand(input: char): Integer;

  function InputSpaceAfterColomn(input: char): Integer;

  function InputFirstSymbolsNumberSystems(input: char; var number_system: Integer): Integer;

  function InputSymbolsNumberSystems(input: char; var number_system: Integer): Integer;


  function InputNumbersNumerator(input: char; var numerator_first_num: Boolean; var input_buffer: buffer_aray;
                                    var numerator: LongWord; var number_system, pointer: Integer): Integer;

  function InputSignOrFirstNumbersNumerator(input: char; var sign: sign_type; var numerator_first_num: Boolean;
                                               var input_buffer: buffer_aray; var numerator: LongWord;
                                               var number_system, pointer: Integer): Integer;

  function InputNumbersDenominator(input: char; var input_buffer: buffer_aray; var denominator: LongWord;
                                      var number_system, pointer: Integer): Integer;


implementation

uses SysUtils;


function IsMultiplicationWithinLongIntLimits(a: longint; b: longword): boolean;
const
  MIN_LONGINT = -2147483648;
  MAX_LONGINT = 2147483647;
begin
  // Если одно из чисел равно нулю, то переполнения не будет
  if (a = 0) or (b = 0) then
    Exit(true);

  // Если `a` положительный, проверяем, чтобы результат не превышал MAX_LONGINT
  if a > 0 then
    Exit(a <= MAX_LONGINT div longint(b));

  // Если `a` отрицательный, проверяем, чтобы результат не был меньше MIN_LONGINT
  if a < 0 then
    Exit(a >= MIN_LONGINT div longint(b));

  // Если все проверки пройдены, переполнения нет
  IsMultiplicationWithinLongIntLimits := true;
end;

function IsMultiplicationWithinLongWordLimits(a, b: longword): boolean;
const
  MAX_LONGWORD = 4294967295;
begin
  // Если одно из чисел равно нулю, то переполнения не будет
  if (a = 0) or (b = 0) then
    Exit(true);

  // Проверяем, чтобы результат умножения не превышал MAX_LONGWORD
  if a > MAX_LONGWORD div b then
    Exit(false);

  // Если проверка пройдена, переполнения нет
  IsMultiplicationWithinLongWordLimits := true;
end;

function IsWithinLongIntLimits(numerator: longint; number_system: integer; num: integer): boolean;
const
  MIN_LONGINT = -2147483648;
  MAX_LONGINT = 2147483647;
begin
  // Проверка переполнения при умножении
  if (numerator > 0) and (numerator > MAX_LONGINT div number_system) then
    exit(false)
  else if (numerator < 0) and (numerator < MIN_LONGINT div number_system) then
    exit(false);

  // Если произведение в пределах, можно выполнить умножение
  numerator := numerator * number_system;

  // Проверка переполнения при сложении
  if (num > 0) and (numerator > MAX_LONGINT - num) then
    exit(false)
  else if (num < 0) and (numerator < MIN_LONGINT - num) then
    exit(false);

  // Если все проверки прошли, то переполнения не будет
  IsWithinLongIntLimits := true;
end;

function IsWithinLongWordLimits(denominator: longword; number_system: integer; num: integer): boolean;
const
  MAX_LONGWORD = 4294967295;
begin
  // Проверка переполнения при умножении
  if (number_system > 0) and (denominator > MAX_LONGWORD div number_system) then
    exit(false);

  // Если произведение в пределах, можно выполнить умножение
  denominator := denominator * number_system;

  // Проверка переполнения при сложении
  if (num > 0) and (denominator > MAX_LONGWORD - num) then
    exit(false);

  // Если все проверки прошли, то переполнения не будет
  IsWithinLongWordLimits := true;
end;

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

function ExecuteCommand(input: char; var numerator_first_num: Boolean; var sign: sign_type; var comment: Boolean;
                           var number_system, pointer, status: Integer; var command: command_type;
                           var numerator_temp: LongWord; var numerator: LongInt; var denominator_temp: LongWord;
                           var denominator: LongWord): Integer;

begin
  if (ord(input) = 13) or (ord(input) = 10) then
  begin
    if status = 0 then exit(-3);
    if (0 < status) and (status < 6) then
    begin
      WriteLn('structure error');
      Halt;
    end;
    if (status = 6) and numerator_first_num then
    begin
      WriteLn('mising_numerator');
      Halt;
    end;
    if (pointer = 2) and (status = 7) then
    begin
      WriteLn('incorect_number(numerator)');
      Halt;
    end;
    if (pointer = 2) and (status = 6) then
    begin
      WriteLn('incorect_number(denominator)');
      Halt;
    end;
    WriteLn('Correct');
    WriteLn('Команда: ', command);
    WriteLn('СС: ', number_system);
    WriteLn('Знак: ', sign);
    WriteLn('Финальный статус: ', status);
    WriteLn('Числитель(input): ', numerator_temp);
    WriteLn('Знаменатель(input): ', denominator_temp);
    WriteLn('Числитель: ', numerator);
    WriteLn('Знаменатель: ', denominator);
    if command = 3 then
    begin
      if not IsMultiplicationWithinLongIntLimits(numerator, numerator_temp) then
      begin
        WriteLn('limit_numerator_multiplication');
        Halt;
      end;
      if not IsMultiplicationWithinLongWordLimits(denominator, denominator_temp) then
      begin
        WriteLn('limit_denominator_multiplication');
        Halt;
      end;
      numerator := numerator * numerator_temp;
      denominator := denominator * denominator_temp;
      if sign = 1 then numerator := numerator * -1;
    end;
    if command = 4 then
    begin
      if not IsMultiplicationWithinLongIntLimits(numerator, denominator_temp) then
      begin
        WriteLn('limit_numerator_division');
        Halt;
      end;
      if not IsMultiplicationWithinLongWordLimits(denominator, numerator_temp) then
      begin
        WriteLn('limit_denominator_division');
        Halt;
      end;

      numerator := numerator * denominator_temp;
      denominator := denominator * numerator_temp;
      if sign = 1 then numerator := numerator * -1;
    end;

    if denominator = 0 then
    begin
      WriteLn('division_by_zero');
      Halt;
    end;

    status := 0;
    command := 0;
    number_system := 0;
    sign := 0;
    pointer := 1;
    numerator_first_num := true;
    numerator_temp := 0;
    denominator_temp := 0;
    comment := false;
    exit(-3);
  end;
  ExecuteCommand := status;
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

function CovertNumberToInteger(var input_buffer: buffer_aray; number_system: Integer): Integer;
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

function InputCommandSymbol(input: char; var command: command_type): Integer;
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

function InputNumbersNumerator(input: char; var numerator_first_num: Boolean; var input_buffer: buffer_aray; var numerator: LongWord; var number_system, pointer: Integer): Integer;
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

function InputSignOrFirstNumbersNumerator(input: char; var sign: sign_type; var numerator_first_num: Boolean; var input_buffer: buffer_aray; var numerator: LongWord; var number_system, pointer: Integer): Integer;
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

function  InputNumbersDenominator(input: char; var input_buffer: buffer_aray; var denominator: LongWord; var number_system, pointer: Integer): Integer;
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
    denominator := denominator * number_system + CovertNumberToInteger(input_buffer, number_system);
    pointer := 1;
  end;
  InputNumbersDenominator := 7;
end;

end.

