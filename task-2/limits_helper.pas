(*
 * Project: RationalNumbersCalculator
 * Date: 08.11.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit limits_helper;

interface

  function GCD(a, b: longword): longword; // Функция для нахождения наибольшего общего делителя (НОД)

  function LCM(a, b: longword): longword; // Функция для нахождения наименьшего общего кратного (НОК)

  function IsMultiplicationWithinLongIntLimits(a: longint; b: longword): boolean; // Проверка переполнения при умножении для longint

  function IsMultiplicationWithinLongWordLimits(a, b: longword): boolean; // Проверка переполнения при умножении для longword

  function IsWithinLongIntLimits(numerator: longint; number_system: integer; num: integer): boolean; // Проверка переполнения при операциях с longint

  function IsWithinLongWordLimits(denominator: longword; number_system: integer; num: integer): boolean; // Проверка переполнения при операциях с longword

  function IsAdditionWithinLongIntLimits(a: longint; b: longword): boolean; // Проверка переполнения при сложении longint и longword

  function IsSubtractionWithinLongIntLimits(a: longint; b: longword): boolean; // Проверка переполнения при вычитании longint и longword

implementation

uses custom_types;
{
  Алгоритм Евклида для нахождения наибольшего общего делителя (НОД)
}
function GCD(a, b: longword): longword;
begin
  while b <> 0 do
  begin
    a := a mod b;
    a := a + b;
    b := a - b;
    a := a - b;
  end;
  GCD := a; // Возвращаем НОД
end;

{
  Функция для нахождения наименьшего общего кратного (НОК)
}
function LCM(a, b: longword): longword;
begin
  // Наименьшее общее кратное через НОД с проверкой на переполнение
  if a > custom_types.MAX_LONGWORD div b then
  begin
    WriteLn('overflow_when_calculating_LCM');
    Halt;
  end;
  LCM := (a div GCD(a, b)) * b;
end;

{
  Проверка переполнения при умножении longint и longword
}
function IsMultiplicationWithinLongIntLimits(a: longint; b: longword): boolean;
begin
  // Если одно из чисел равно нулю, то переполнения не будет
  if (a = 0) or (b = 0) then
    Exit(true);

  // Если `a` положительный, проверяем, чтобы результат не превышал custom_types.MAX_LONGINT
  if a > 0 then
    Exit(a <= custom_types.MAX_LONGINT div longint(b));

  // Если `a` отрицательный, проверяем, чтобы результат не был меньше custom_types.MIN_LONGINT
  if a < 0 then
    Exit(a >= custom_types.MIN_LONGINT div longint(b));

  // Если все проверки пройдены, переполнения нет
  IsMultiplicationWithinLongIntLimits := true;
end;

{
  Проверка переполнения при умножении longword и longword
}
function IsMultiplicationWithinLongWordLimits(a, b: longword): boolean;
begin
  // Если одно из чисел равно нулю, то переполнения не будет
  if (a = 0) or (b = 0) then
    Exit(true);

  // Проверяем, чтобы результат умножения не превышал custom_types.MAX_LONGWORD
  if a > custom_types.MAX_LONGWORD div b then
    Exit(false);

  // Если проверка пройдена, переполнения нет
  IsMultiplicationWithinLongWordLimits := true;
end;

{
  Проверка переполнения для операций с longint (умножение и сложение)
}
function IsWithinLongIntLimits(numerator: longint; number_system: integer; num: integer): boolean;
begin
  // Проверка переполнения при умножении
  if (numerator > 0) and (numerator > custom_types.MAX_LONGINT div number_system) then
    exit(false)
  else if (numerator < 0) and (numerator < custom_types.MIN_LONGINT div number_system) then
    exit(false);

  // Если произведение в пределах, можно выполнить умножение
  numerator := numerator * number_system;

  // Проверка переполнения при сложении
  if (num > 0) and (numerator > custom_types.MAX_LONGINT - num) then
    exit(false)
  else if (num < 0) and (numerator < custom_types.MIN_LONGINT - num) then
    exit(false);

  // Если все проверки прошли, то переполнения не будет
  IsWithinLongIntLimits := true;
end;

{
  Проверка переполнения для операций с longword (умножение и сложение)
}
function IsWithinLongWordLimits(denominator: longword; number_system: integer; num: integer): boolean;
begin
  // Проверка переполнения при умножении
  if (number_system > 0) and (denominator > custom_types.MAX_LONGWORD div number_system) then
    exit(false);

  // Если произведение в пределах, можно выполнить умножение
  denominator := denominator * number_system;

  // Проверка переполнения при сложении
  if (num > 0) and (denominator > custom_types.MAX_LONGWORD - num) then
    exit(false);

  // Если все проверки прошли, то переполнения не будет
  IsWithinLongWordLimits := true;
end;

{
    Проверка переполнения при сложении longint и longword
}
function IsAdditionWithinLongIntLimits(a: longint; b: longword): boolean;
begin
  // Если b = 0, переполнение не может произойти
  if b = 0 then
    Exit(true);

  // Если a положительное, проверяем, чтобы результат не превысил custom_types.MAX_LONGINT
  if a > 0 then
    Exit(a + b <= custom_types.MAX_LONGINT);

  // Если a отрицательное, проверяем, чтобы результат не опустился ниже custom_types.MIN_LONGINT
  if a < 0 then
    Exit(a + b >= custom_types.MIN_LONGINT);

  // Если a = 0, переполнение не может произойти, так как b не выходит за пределы longint
  IsAdditionWithinLongIntLimits := true;
end;

{
  Проверка переполнения при вычитании longint и longword
}
function IsSubtractionWithinLongIntLimits(a: longint; b: longword): boolean;
begin
  // Если b = 0, переполнение не может произойти
  if b = 0 then
    Exit(true);

  // Если a положительное, проверяем, чтобы результат не стал меньше custom_types.MIN_LONGINT
  if a > 0 then
    Exit(a - b >= custom_types.MIN_LONGINT);

  // Если a отрицательное, проверяем, чтобы результат не стал больше custom_types.MAX_LONGINT
  if a < 0 then
    Exit(a - b <= custom_types.MAX_LONGINT);

  // Если a = 0, переполнение не может произойти, так как b не выходит за пределы longint
  IsSubtractionWithinLongIntLimits := true;
end;

end.