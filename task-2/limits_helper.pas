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

function GCD(a, b: longword): longword;
{
  Алгоритм Евклида для нахождения наибольшего общего делителя (НОД)
}
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

function LCM(a, b: longword): longword;
const
  MAX_LONGWORD = 4294967295; // Максимальное значение для типа longword
{
    Функция для нахождения наименьшего общего кратного (НОК)
}
begin
  // Наименьшее общее кратное через НОД с проверкой на переполнение
  if a > MAX_LONGWORD div b then
  begin
    WriteLn('Переполнение при вычислении НОК');
    Halt;
  end;
  LCM := (a div GCD(a, b)) * b;
end;

function IsMultiplicationWithinLongIntLimits(a: longint; b: longword): boolean;
const
  MIN_LONGINT = -2147483648;  // Минимальное значение для longint
  MAX_LONGINT = 2147483647;   // Максимальное значение для longint
{
  Проверка переполнения при умножении longint и longword
}
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
  MAX_LONGWORD = 4294967295;  // Максимальное значение для longword

{
  Проверка переполнения при умножении longword и longword
}
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
  MIN_LONGINT = -2147483648;  // Минимальное значение для longint
  MAX_LONGINT = 2147483647;   // Максимальное значение для longint
{
  Проверка переполнения для операций с longint (умножение и сложение)
}
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
  MAX_LONGWORD = 4294967295;  // Максимальное значение для longword
{
  Проверка переполнения для операций с longword (умножение и сложение)
}
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

function IsAdditionWithinLongIntLimits(a: longint; b: longword): boolean;
const
  MIN_LONGINT = -2147483648;  // Минимальное значение для longint
  MAX_LONGINT = 2147483647;   // Максимальное значение для longint
{
  Проверка переполнения при сложении longint и longword
}
begin
  // Если b = 0, переполнение не может произойти
  if b = 0 then
    Exit(true);

  // Если a положительное, проверяем, чтобы результат не превысил MAX_LONGINT
  if a > 0 then
    Exit(a + b <= MAX_LONGINT);

  // Если a отрицательное, проверяем, чтобы результат не опустился ниже MIN_LONGINT
  if a < 0 then
    Exit(a + b >= MIN_LONGINT);

  // Если a = 0, переполнение не может произойти, так как b не выходит за пределы longint
  IsAdditionWithinLongIntLimits := true;
end;

function IsSubtractionWithinLongIntLimits(a: longint; b: longword): boolean;
const
  MIN_LONGINT = -2147483648;  // Минимальное значение для longint
  MAX_LONGINT = 2147483647;   // Максимальное значение для longint
{
  Проверка переполнения при вычитании longint и longword
}
begin
  // Если b = 0, переполнение не может произойти
  if b = 0 then
    Exit(true);

  // Если a положительное, проверяем, чтобы результат не стал меньше MIN_LONGINT
  if a > 0 then
    Exit(a - b >= MIN_LONGINT);

  // Если a отрицательное, проверяем, чтобы результат не стал больше MAX_LONGINT
  if a < 0 then
    Exit(a - b <= MAX_LONGINT);

  // Если a = 0, переполнение не может произойти, так как b не выходит за пределы longint
  IsSubtractionWithinLongIntLimits := true;
end;

end.