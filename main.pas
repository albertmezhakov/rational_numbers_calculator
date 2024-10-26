(*
 * Project: RationalNumbersCalculator
 * User: BerhtAdal
 * Date: 26.10.2024
 *)
program main;
uses  SysUtils;

const
  MAX_NUMBER_SYSTEM = 256;
type
  number_system_type = array[1..256] of Int16;
var
  number_systems: number_system_type;

procedure GetNumberSystems(var number_system_local: number_system_type);
var
  i, j: integer;
  in_array: Boolean;
begin
  {
    Инициализируем массив с системами сячиления.
    Считываем все счиления которые передаються в виде аргументов программы.
    Записываем только уникальные системы счиления.
  }
  for i:=1 to MAX_NUMBER_SYSTEM do number_system_local[i] := -1;
  for i:=1 to ParamCount do
  begin
    in_array := false;
    for j:=1 to i do if number_system_local[j] = StrToInt(ParamStr(i)) then in_array := true;
    if in_array then continue;
    if (StrToInt(ParamStr(i)) > 1) and (StrToInt(ParamStr(i)) <= 256) then
      number_system_local[i] := StrToInt(ParamStr(i))
    else
    begin
      WriteLn('Некоректная система счиления. Поддерживаються системы счисления от 2 до 256 включительно.');
      exit;
    end;
  end;
  if ParamCount = 0 then
  begin
    WriteLn('Нужно ввести минимум 1 систему счиления. ');
    exit
  end;
end;

begin
  GetNumberSystems(number_systems);
  
end.

