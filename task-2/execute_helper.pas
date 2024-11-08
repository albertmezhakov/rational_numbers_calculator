(*
 * Project: RationalNumbersCalculator
 * Date: 27.10.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit execute_helper;

interface

uses types;

  procedure ReduceFraction(var num: longint; var den: longword);


  function ExecuteCommand(input: char; var numerator_first_num: Boolean; var sign: types.sign_type; var comment: Boolean;
                             var number_system, pointer, status: Integer; var command: types.command_type;
                             var numerator_temp: LongWord; var numerator: LongInt; var denominator_temp: LongWord;
                             var denominator: LongWord): Integer;


implementation

uses limits_helper;


procedure ReduceFraction(var num: longint; var den: longword);
var
  gcd_result: longword;
begin
  // Находим НОД числителя и знаменателя
  gcd_result := GCD(abs(num), den);

  // Обработка возможного знака
  if num < 0 then
  begin
    num := (abs(num) div gcd_result) * -1;
    den := den div gcd_result;
  end else begin
    num := abs(num) div gcd_result;
    den := den div gcd_result;
  end;
end;


function ExecuteCommand(input: char; var numerator_first_num: Boolean; var sign: types.sign_type; var comment: Boolean;
                           var number_system, pointer, status: Integer; var command: types.command_type;
                           var numerator_temp: LongWord; var numerator: LongInt; var denominator_temp: LongWord;
                           var denominator: LongWord): Integer;
var
  commonDen: longword;
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

//    if (denominator_temp = 0) and (command <> 4) then // ??????
    if denominator_temp = 0 then
    begin
      WriteLn('division_by_zero_1');
      Halt;
    end;
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
    if ((command = 1) and (sign = 0)) or ((command = 2) and (sign = 1))then
    begin
      // Находим общий знаменатель с проверкой переполнения
      commonDen := LCM(denominator, denominator_temp);

      // Приводим первую дробь к общему знаменателю с проверкой переполнения
      if not IsMultiplicationWithinLongIntLimits(numerator, commonDen div denominator) then
      begin
        WriteLn('Переполнение при приведении первой дроби к общему знаменателю');
        Halt;
      end;

      numerator := numerator * (commonDen div denominator);
      denominator := commonDen;

      if not IsMultiplicationWithinLongWordLimits(numerator_temp, commonDen div denominator_temp) then
      begin
        WriteLn('Переполнение при приведении второй дроби к общему знаменателю');
        Halt;
      end;
      numerator_temp := numerator_temp * (commonDen div denominator_temp);
      denominator_temp := commonDen;

      if not IsAdditionWithinLongIntLimits(numerator, numerator_temp) then
      begin
        WriteLn('Переполнение при cложение');
        Halt;
      end;
      numerator := numerator + numerator_temp;
    end;
    if ((command = 2) and (sign = 0)) or ((command = 1) and (sign = 1))then
    begin
      // Находим общий знаменатель с проверкой переполнения
      commonDen := LCM(denominator, denominator_temp);

      // Приводим первую дробь к общему знаменателю с проверкой переполнения
      if not IsMultiplicationWithinLongIntLimits(numerator, commonDen div denominator) then
      begin
        WriteLn('Переполнение при приведении первой дроби к общему знаменателю');
        Halt;
      end;

      numerator := numerator * (commonDen div denominator);
      denominator := commonDen;

      if not IsMultiplicationWithinLongWordLimits(numerator_temp, commonDen div denominator_temp) then
      begin
        WriteLn('Переполнение при приведении второй дроби к общему знаменателю');
        Halt;
      end;
      numerator_temp := numerator_temp * (commonDen div denominator_temp);
      denominator_temp := commonDen;

      if not IsSubtractionWithinLongIntLimits(numerator, numerator_temp) then
      begin
        WriteLn('Переполнение при вычитании');
        Halt;
      end;
      numerator := numerator - numerator_temp;
    end;
    if denominator = 0 then
    begin
      WriteLn('division_by_zero');
      Halt;
    end;


    WriteLn('Числитель(after1): ', numerator);
    WriteLn('Знаменатель(after1): ', denominator);
    ReduceFraction(numerator, denominator);
    WriteLn('Числитель(after2): ', numerator);
    WriteLn('Знаменатель(after2): ', denominator);
    status := 0;
    command := 0;
    number_system := 0;
    sign := 0;
    pointer := 1;
    numerator_first_num := true;
    numerator_temp := 0;
    denominator_temp := 1;
    comment := false;
    exit(-3);
  end;
  ExecuteCommand := status;
end;

end.

