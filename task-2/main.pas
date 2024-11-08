(*
 * Project: RationalNumbersCalculator
 * Date: 26.10.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
program main;
uses  SysUtils;

const
  MAX_NUMBER_SYSTEM = 256;  // ћаксимальное количество поддерживаемых систем счислени€

type
  number_system_type = array[1..256] of Int16;  // “ип данных дл€ хранени€ массивов систем счислени€ (до 256 уникальных значений)

var
  number_systems: number_system_type;  // ћассив, в котором будут хранитьс€ переданные пользователем системы счислени€


procedure GetNumberSystems(var number_system_local: number_system_type);
var
  i, j: integer;  // ѕеременные дл€ итерации по циклам
  in_array: Boolean;  // ‘лаг дл€ проверки, была ли уже добавлена система счислени€
{
    ѕроцедура дл€ получени€ и обработки систем счислени€ из аргументов командной строки
}
begin
  {
    »нициализируем массив с системами счислени€.
    —читываем все системы счислени€, которые передаютс€ в виде аргументов программы.
    «аписываем только уникальные системы счислени€.
  }

  // »нициализируем все элементы массива значением -1 (означает отсутствие значени€)
  for i := 1 to MAX_NUMBER_SYSTEM do
    number_system_local[i] := -1;

  // ќбрабатываем каждый аргумент командной строки, начина€ с первого
  for i := 1 to ParamCount do
  begin
    in_array := false;  // ”станавливаем флаг, что система счислени€ еще не найдена в массиве

    // ѕровер€ем, не была ли эта система счислени€ уже добавлена в массив
    for j := 1 to i do
      if number_system_local[j] = StrToInt(ParamStr(i)) then
        in_array := true;

    // ≈сли система счислени€ уже была добавлена, пропускаем этот аргумент
    if in_array then continue;

    // ѕровер€ем, что система счислени€ находитс€ в допустимом диапазоне
    if (StrToInt(ParamStr(i)) > 1) and (StrToInt(ParamStr(i)) <= 256) then
      number_system_local[i] := StrToInt(ParamStr(i))  // ƒобавл€ем систему счислени€ в массив
    else
    begin
      WriteLn('Ќекорректна€ система счислени€. ѕоддерживаютс€ системы счислени€ от 2 до 256 включительно.');
      exit;  // «авершаем программу, если введена некорректна€ система счислени€
    end;
  end;

  // ≈сли не было передано ни одного аргумента, выводим сообщение об ошибке
  if ParamCount = 0 then
  begin
    WriteLn('Ќужно ввести минимум 1 систему счислени€.');
    exit;  // «авершаем программу
  end;
end;

begin
  GetNumberSystems(number_systems);
end.
