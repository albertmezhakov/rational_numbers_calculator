(*
 * Project: RationalNumbersCalculator
 * Date: 27.10.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit execute_helper;

interface

uses custom_types;

  procedure ReduceFraction(var num: longint; var den: longword);


  function ExecuteCommand(input: char; var numerator_first_num: Boolean;var denominator_first_num: Boolean; var sign: custom_types.sign_t; var comment: Boolean;
                             var number_system: Word; var pointer: Integer; var status: custom_types.status_t; var command: custom_types.command_t;
                             var numerator_temp: LongWord; var numerator: LongInt; var denominator_temp: LongWord;
                             var denominator: LongWord): custom_types.status_t;


implementation

uses limits_helper;

procedure ReduceFraction(var num: longint; var den: longword);
var
  gcd_result: longword;
{
    Процедура сокращает дробь, используя наибольший общий делитель (НОД) числителя и знаменателя.
    Принимает два параметра:
      - num: числитель дроби (longint)
      - den: знаменатель дроби (longword)
    После выполнения числитель и знаменатель возвращаются в виде сокращенной дроби.
}
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

function ExecuteCommand(input: char; var numerator_first_num: Boolean; var denominator_first_num:Boolean; var sign: custom_types.sign_t; var comment: Boolean;
                           var number_system: Word; var pointer: Integer; var status: custom_types.status_t; var command: custom_types.command_t;
                           var numerator_temp: LongWord; var numerator: LongInt; var denominator_temp: LongWord;
                           var denominator: LongWord): custom_types.status_t;
var
  commonDen: longword;
{
      Функция выполняет команду калькулятора, обрабатывая различные операции с дробями.
      Принимает символ ввода (input) и обновляет различные параметры состояния.
      В зависимости от команды (сложение, вычитание, умножение, деление)
      выполняются соответствующие арифметические операции. Также функция
      проверяет переполнение и корректность ввода чисел.
      Возвращает новый статус, который отражает текущее состояние калькулятора.
}
begin
  if (ord(input) = 13) or (ord(input) = 10) then
  begin
    // Проверяем на пустое состояние
    if status = 0 then exit(-3);

    // Структурная ошибка
    if (0 < status) and (status < 6) then
    begin
      WriteLn('structure error');
      Halt;
    end;

    // Проверка на недостающий числитель
    if (status = 6) and numerator_first_num then
    begin
      WriteLn('mising_numerator');
      Halt;
    end;

    // Проверка на некорректный числитель или знаменатель
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
    

    // Проверка деления на ноль
    if denominator_temp = 0 then
    begin
      WriteLn('division_by_zero_1');
      Halt;
    end;

    // Умножение числителя и знаменателя
    if command = 3 then
    begin
      if not IsMultiplicationWithinLongIntLimits(numerator, numerator_temp) then
      begin
        WriteLn('multiplication_overflow_in_longint');
        Halt;
      end;
      if not IsMultiplicationWithinLongWordLimits(denominator, denominator_temp) then
      begin
        WriteLn('multiplication_overflow_in_longword');
        Halt;
      end;
      numerator := numerator * numerator_temp;
      denominator := denominator * denominator_temp;
      if sign = 1 then numerator := numerator * -1;
    end;

    // Деление числителя и знаменателя
    if command = 4 then
    begin
      if not IsMultiplicationWithinLongIntLimits(numerator, denominator_temp) then
      begin
        WriteLn('multiplication_overflow_in_longint');
        Halt;
      end;
      if not IsMultiplicationWithinLongWordLimits(denominator, numerator_temp) then
      begin
        WriteLn('multiplication_overflow_in_longword');
        Halt;
      end;

      numerator := numerator * denominator_temp;
      denominator := denominator * numerator_temp;
      if sign = 1 then numerator := numerator * -1;
    end;

    // Сложение дробей
    if ((command = 1) and (sign = 0)) or ((command = 2) and (sign = 1)) then
    begin
      // Находим общий знаменатель с проверкой переполнения
      commonDen := LCM(denominator, denominator_temp);

      // Приводим первую дробь к общему знаменателю с проверкой переполнения
      if not IsMultiplicationWithinLongIntLimits(numerator, commonDen div denominator) then
      begin
        WriteLn('multiplication_overflow_in_longint');
        Halt;
      end;

      numerator := numerator * (commonDen div denominator);
      denominator := commonDen;

      // Приводим вторую дробь к общему знаменателю
      if not IsMultiplicationWithinLongWordLimits(numerator_temp, commonDen div denominator_temp) then
      begin
        WriteLn('multiplication_overflow_in_longword');
        Halt;
      end;
      numerator_temp := numerator_temp * (commonDen div denominator_temp);
      denominator_temp := commonDen;

      // Проверка переполнения при сложении
      if not IsAdditionWithinLongIntLimits(numerator, numerator_temp) then
      begin
        WriteLn('addition_overflow_in_longint');
        Halt;
      end;
      numerator := numerator + numerator_temp;
    end;

    // Вычитание дробей
    if ((command = 2) and (sign = 0)) or ((command = 1) and (sign = 1)) then
    begin
      // Находим общий знаменатель с проверкой переполнения
      commonDen := LCM(denominator, denominator_temp);

      // Приводим первую дробь к общему знаменателю с проверкой переполнения
      if not IsMultiplicationWithinLongIntLimits(numerator, commonDen div denominator) then
      begin
        WriteLn('multiplication_overflow_in_longint');
        Halt;
      end;

      numerator := numerator * (commonDen div denominator);
      denominator := commonDen;

      // Приводим вторую дробь к общему знаменателю
      if not IsMultiplicationWithinLongWordLimits(numerator_temp, commonDen div denominator_temp) then
      begin
        WriteLn('multiplication_overflow_in_longword');
        Halt;
      end;
      numerator_temp := numerator_temp * (commonDen div denominator_temp);
      denominator_temp := commonDen;

      // Проверка переполнения при вычитании
      if not IsSubtractionWithinLongIntLimits(numerator, numerator_temp) then
      begin
        WriteLn('subtraction_overflow_in_longint');
        Halt;
      end;
      numerator := numerator - numerator_temp;
    end;

    // Проверка деления на ноль
    if denominator = 0 then
    begin
      WriteLn('division_by_zero');
      Halt;
    end;

    // Сокращение дроби
    ReduceFraction(numerator, denominator);
    

    // Сброс состояния калькулятора
    status := 0;
    command := 0;
    number_system := 0;
    sign := 0;
    pointer := 1;
    numerator_first_num := true;
    denominator_first_num := true;
    numerator_temp := 0;
    denominator_temp := 1;
    comment := false;

    exit(-3);
  end;

  ExecuteCommand := status;
end;

end.
