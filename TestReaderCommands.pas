(*
 * Project: RationalNumbersCalculator
 * User: BerhtAdal
 * Date: 26.10.2024
 *)
program TestReaderCommands;
uses  SysUtils;

type
  buffer_aray = array[1..6] of Char;

  command_type = 0..4;
var
  input: char;
  command: command_type;
  number_system: Integer;
  input_buffer: buffer_aray;
  pointer: Integer;
  is_first_command: Boolean;
begin

  command := 0;
  number_system := 0;
  pointer := 1;
  is_first_command := true;
  while true do
  begin
    Read(input);
    if command = 0 then
    begin
      if is_first_command then
      begin
        is_first_command := false;
        if input = '+' then command := 1 else begin
          WriteLn('Некоректный знак действия. Для первой команды допустим только +');
          exit;
        end;
      end;
      case input of
        '+': command := 1;
        '-': command := 2;
        '*': command := 3;
        '/': command := 4;
      else
      begin
        WriteLn('Некоректный знак действия. Допустимы только +, -, *, /.');
        exit;
      end;
      end;
      continue
    end;


    if (number_system = 0) then
    begin
      if input = ' ' then number_system := 1 else begin
        WriteLn('Ошибка введен символ кроме " " после знака действия');
        exit;
      end;
      continue;
    end;
    if (number_system = 1) then
    begin
      if (input <> ':') and (not (('0' <= input) and (input <= '9'))) then
      begin

        WriteLn('Ошибка введен символ кроме [0-9] при вводе системы счиления');
        exit;
      end;
      if (pointer <= 4) and (pointer > 1) and (input = ':') then
      begin
        // Успешно введена система счиления от 1 до 3 цифр и :
        case pointer of
          2: number_system := StrToInt(input_buffer[1]);
          3: number_system := StrToInt(input_buffer[1]) * 10 + StrToInt(input_buffer[2]);
          4: number_system := StrToInt(input_buffer[1]) * 100 + StrToInt(input_buffer[2]) * 10 + StrToInt(input_buffer[3]);
        end;
        WriteLn(number_system);
        
      end;
      if (pointer = 1) and (input = ':') then
      begin
        WriteLn('Ошибка введен символ ":", не введено не одной цифры');
        exit;
      end;
      if (pointer = 4) and (input <> ':') then
      begin
        WriteLn('Ошибка введена 4-ая цифра. Система счиления превышает допустимую');
        exit;
      end;
      if ('0' <= input) and (input <= '9') then
      begin
        input_buffer[pointer] := input;
        pointer := pointer + 1;
      end;
    end;

  end;

end.