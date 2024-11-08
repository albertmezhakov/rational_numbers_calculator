(*
 * Project: RationalNumbersCalculator
 * User: BerhtAdal
 * Date: 26.10.2024
 *)
program TestReaderCommands;
uses  SysUtils;

type
  buffer_aray = array[1..2] of Char;

  command_type = 0..4;

  sign_type = 0..1;
var
  input: char;
  input_buffer: buffer_aray;
  command: command_type;
  sign: sign_type;
  number_system, status: Integer;
  is_first_command, comment, numerator_first_num: Boolean;
  numerator, denominator: LongInt;
  pointer: Integer;

begin
  status := 0;
  command := 0;
  number_system := 0;
  sign := 0;
  is_first_command := true;
  comment := false;
  numerator := 0;
  numerator_first_num:= true;
  denominator := 0;
  pointer := 1;

  while true do
  begin
    Read(input);


    if (ord(input) = 13) or (ord(input) = 10) then
    begin
      if pointer = 2 then
      begin
        WriteLn('Кол-во цифр нечетно. Ошибка.');
        exit;
      end;
      WriteLn('Correct');
//      WriteLn('Команда: ', command);
//      WriteLn('СС: ', number_system);
//      WriteLn('Знак: ', sign);
//      WriteLn('Финальный статус: ', status);
//      WriteLn('Коментарии: ', comment);
      break
    end;

    if comment then continue;
    if (input = '#') then
    begin
      comment := true;
      continue
    end;
    if (input = '/') and (status = 6) and (not numerator_first_num) then
    begin
      status := status + 1;
      continue
    end;
    if (input = ' ') and ((status = 1) or (status = 4)) then
    begin
      status := status + 1;
      continue
    end;

    if (input = ' ') and ((status <> 3) and (status <> 5) and (status <> 6) and (status <> 7)) then continue;

    if status = 0 then
    begin
      case input of
        '+': command := 1;
        '-': command := 2;
        '*': command := 3;
        '/': command := 4;
      else
      begin
        WriteLn('Некоректный знак действия. Допустимы только +, -, *, /.', input);
        exit;
      end;
      end;
//      if is_first_command then
//      begin
//        if input = '+' then command := 1 else begin
//          WriteLn('Некоректный знак действия. Для первой команды допустим только +');
//          exit;
//        end;
//      end;
      if command <> 0 then status := status + 1;
      continue
    end;

    if status = 1 then
    begin
      WriteLn('Ошибка структуры 1634453');
      exit;
    end;

    if status = 2 then
    begin
      if input = ':' then
      begin
        WriteLn('Вы не ввели систему счисления');
        exit;
      end;
      if not (('0' <= input) and (input <= '9')) then
      begin
        WriteLn('Ввели недопустимый символ 8765765');
        exit;
      end;
      status := 3;
    end;

    if status = 3 then
    begin
      if input = ':' then
      begin
        if (number_system < 257) and (number_system< 2) then
        begin
          WriteLn('Система счисление не может быть больше 256 и меньше 2');
          exit;
        end;
        status := 4;
        continue
      end;
      if not (('0' <= input) and (input <= '9')) then
      begin
        WriteLn('Ввели недопустимый символ 465343566453');
        exit;
      end;
      number_system := number_system * 10 + StrToInt(input);
      if number_system > 256 then
      begin
        WriteLn('Система счиление не может быть больше 256');
        exit;
      end;
    end;

    if status = 4 then
    begin
      WriteLn('Ошибка структуры 869748532135672');
      exit;
    end;

    if status = 5 then
    begin
      if not ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f')) or (input = '+') or (input = '-')) then
      begin
        if input = ' ' then
        begin
          WriteLn('Должен быть 1 пробел 56342363564365435');
          exit;
        end;
        WriteLn('Ввели недопустимый символ 74564545433645');
        exit;
      end;
      case input of
        '+': sign := 0;
        '-': sign := 1;
      else sign := 0
      end;
      if (('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f')) then
      begin
        status := status + 1
      end
      else begin
        status := status + 1;
        continue
      end;
    end;

    if status = 6 then
    begin
      if (input = '/') and numerator_first_num then
      begin
        // Ошибка после знака нельзя ноль
        WriteLn('Ошибка невведено не одного числа перед дробной частью');
        exit;
        continue
      end;

      if (pointer = 1) and (input = ' ') and numerator_first_num then
      begin
        // Ошибка после знака нельзя ноль
        WriteLn('Ошибка после знака нельзя ноль');
        exit;
      end;

      if (pointer = 2) and (input = ' ') then
      begin
        // Пробел между цифрами
        WriteLn('Пробел между цифрами, некоректный');
        exit;
        continue
      end;

      if (pointer = 1) and (input = ' ') then
      begin
        // Пробел между цифрами
        // WriteLn('Пробел между цифрами');
        continue
      end;

      if ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f'))) and (pointer < 3) then
      begin
        input_buffer[pointer] := input;
        pointer := pointer + 1;
      end;

      if (pointer = 3) then
      begin
        // Считаем число в нужную систему и пишем новую пару чисел
        // WriteLn('Считаем число в нужную систему и пишем новую пару чисел');
        pointer := 1;
        numerator_first_num:= false;
      end;
    end;

    if status = 7 then
    begin
      if (pointer = 2) and (input = ' ') then
      begin
        WriteLn('Пробел между цифрами, некоректный 435434');
        exit;
        continue
      end;

      if (pointer = 1) and (input = ' ') then
      begin
        // WriteLn('Пробел между цифрами');
        continue
      end;

      if ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f'))) and (pointer < 3) then
      begin
        input_buffer[pointer] := input;
        pointer := pointer + 1;
      end;

      if (pointer = 3) then
      begin
        // Считаем число в нужную систему и пишем новую пару чисел
        // WriteLn('Считаем число в нужную систему и пишем новую пару чисел');
        pointer := 1;
      end;
    end;

  end;

end.