(*
 * Project: RationalNumbersCalculator
 * Date: 08.11.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit arguments_helper;

interface

uses custom_types;

  function GetNumberSystems(): custom_types.number_system_t;

implementation

uses
  sysutils;

{
    ѕроцедура дл€ получени€ и обработки систем счислени€ из аргументов командной строки
}
function GetNumberSystems(): custom_types.number_system_t;
var
  i, j: integer;  // ѕеременные дл€ итерации по циклам
  in_array: Boolean;  // ‘лаг дл€ проверки, была ли уже добавлена система счислени€
  number_system_local: custom_types.number_system_t;
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
      WriteLn('incorrect_number_system_range(system_argument)');
      Halt;  // «авершаем программу, если введена некорректна€ система счислени€
    end;
  end;

  // ≈сли не было передано ни одного аргумента, выводим сообщение об ошибке
  if ParamCount = 0 then
  begin
    WriteLn('missing_number_system_argument');
    Halt;  // «авершаем программу
  end;
  GetNumberSystems := number_system_local;
end;
end.