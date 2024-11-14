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
    ��������� ��� ��������� � ��������� ������ ��������� �� ���������� ��������� ������
}
function GetNumberSystems(): custom_types.number_system_t;
var
  i, j: integer;  // ���������� ��� �������� �� ������
  in_array: Boolean;  // ���� ��� ��������, ���� �� ��� ��������� ������� ���������
  number_system_local: custom_types.number_system_t;
begin
  {
    �������������� ������ � ��������� ���������.
    ��������� ��� ������� ���������, ������� ���������� � ���� ���������� ���������.
    ���������� ������ ���������� ������� ���������.
  }

  // �������������� ��� �������� ������� ��������� -1 (�������� ���������� ��������)
  for i := 1 to MAX_NUMBER_SYSTEM do
    number_system_local[i] := -1;

  // ������������ ������ �������� ��������� ������, ������� � �������
  for i := 1 to ParamCount do
  begin
    in_array := false;  // ������������� ����, ��� ������� ��������� ��� �� ������� � �������

    // ���������, �� ���� �� ��� ������� ��������� ��� ��������� � ������
    for j := 1 to i do
      if number_system_local[j] = StrToInt(ParamStr(i)) then
        in_array := true;

    // ���� ������� ��������� ��� ���� ���������, ���������� ���� ��������
    if in_array then continue;

    // ���������, ��� ������� ��������� ��������� � ���������� ���������
    if (StrToInt(ParamStr(i)) > 1) and (StrToInt(ParamStr(i)) <= 256) then
      number_system_local[i] := StrToInt(ParamStr(i))  // ��������� ������� ��������� � ������
    else
    begin
      WriteLn('incorrect_number_system_range(system_argument)');
      Halt;  // ��������� ���������, ���� ������� ������������ ������� ���������
    end;
  end;

  // ���� �� ���� �������� �� ������ ���������, ������� ��������� �� ������
  if ParamCount = 0 then
  begin
    WriteLn('missing_number_system_argument');
    Halt;  // ��������� ���������
  end;
  GetNumberSystems := number_system_local;
end;
end.