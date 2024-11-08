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


function GetNumberSystems(): custom_types.number_system_t;
var
  i, j: integer;  // Переменные для итерации по циклам
  in_array: Boolean;  // Флаг для проверки, была ли уже добавлена система счисления
  number_system_local: custom_types.number_system_t;
{
    Процедура для получения и обработки систем счисления из аргументов командной строки
}
begin
  {
    Инициализируем массив с системами счисления.
    Считываем все системы счисления, которые передаются в виде аргументов программы.
    Записываем только уникальные системы счисления.
  }

  // Инициализируем все элементы массива значением -1 (означает отсутствие значения)
  for i := 1 to MAX_NUMBER_SYSTEM do
    number_system_local[i] := -1;

  // Обрабатываем каждый аргумент командной строки, начиная с первого
  for i := 1 to ParamCount do
  begin
    in_array := false;  // Устанавливаем флаг, что система счисления еще не найдена в массиве

    // Проверяем, не была ли эта система счисления уже добавлена в массив
    for j := 1 to i do
      if number_system_local[j] = StrToInt(ParamStr(i)) then
        in_array := true;

    // Если система счисления уже была добавлена, пропускаем этот аргумент
    if in_array then continue;

    // Проверяем, что система счисления находится в допустимом диапазоне
    if (StrToInt(ParamStr(i)) > 1) and (StrToInt(ParamStr(i)) <= 256) then
      number_system_local[i] := StrToInt(ParamStr(i))  // Добавляем систему счисления в массив
    else
    begin
      WriteLn('Некорректная система счисления. Поддерживаются системы счисления от 2 до 256 включительно.');
      Halt;  // Завершаем программу, если введена некорректная система счисления
    end;
  end;

  // Если не было передано ни одного аргумента, выводим сообщение об ошибке
  if ParamCount = 0 then
  begin
    WriteLn('Нужно ввести минимум 1 систему счисления.');
    Halt;  // Завершаем программу
  end;
  GetNumberSystems := number_system_local;
end;
end.