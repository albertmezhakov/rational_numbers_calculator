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
    ��������� ��������� �����, ��������� ���������� ����� �������� (���) ��������� � �����������.
    ��������� ��� ���������:
      - num: ��������� ����� (longint)
      - den: ����������� ����� (longword)
    ����� ���������� ��������� � ����������� ������������ � ���� ����������� �����.
}
begin
  // ������� ��� ��������� � �����������
  gcd_result := GCD(abs(num), den);

  // ��������� ���������� �����
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
      ������� ��������� ������� ������������, ����������� ��������� �������� � �������.
      ��������� ������ ����� (input) � ��������� ��������� ��������� ���������.
      � ����������� �� ������� (��������, ���������, ���������, �������)
      ����������� ��������������� �������������� ��������. ����� �������
      ��������� ������������ � ������������ ����� �����.
      ���������� ����� ������, ������� �������� ������� ��������� ������������.
}
begin
  if (ord(input) = 13) or (ord(input) = 10) then
  begin
    // ��������� �� ������ ���������
    if status = 0 then exit(-3);

    // ����������� ������
    if (0 < status) and (status < 6) then
    begin
      WriteLn('structure error');
      Halt;
    end;

    // �������� �� ����������� ���������
    if (status = 6) and numerator_first_num then
    begin
      WriteLn('mising_numerator');
      Halt;
    end;

    // �������� �� ������������ ��������� ��� �����������
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
    

    // �������� ������� �� ����
    if denominator_temp = 0 then
    begin
      WriteLn('division_by_zero_1');
      Halt;
    end;

    // ��������� ��������� � �����������
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

    // ������� ��������� � �����������
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

    // �������� ������
    if ((command = 1) and (sign = 0)) or ((command = 2) and (sign = 1)) then
    begin
      // ������� ����� ����������� � ��������� ������������
      commonDen := LCM(denominator, denominator_temp);

      // �������� ������ ����� � ������ ����������� � ��������� ������������
      if not IsMultiplicationWithinLongIntLimits(numerator, commonDen div denominator) then
      begin
        WriteLn('multiplication_overflow_in_longint');
        Halt;
      end;

      numerator := numerator * (commonDen div denominator);
      denominator := commonDen;

      // �������� ������ ����� � ������ �����������
      if not IsMultiplicationWithinLongWordLimits(numerator_temp, commonDen div denominator_temp) then
      begin
        WriteLn('multiplication_overflow_in_longword');
        Halt;
      end;
      numerator_temp := numerator_temp * (commonDen div denominator_temp);
      denominator_temp := commonDen;

      // �������� ������������ ��� ��������
      if not IsAdditionWithinLongIntLimits(numerator, numerator_temp) then
      begin
        WriteLn('addition_overflow_in_longint');
        Halt;
      end;
      numerator := numerator + numerator_temp;
    end;

    // ��������� ������
    if ((command = 2) and (sign = 0)) or ((command = 1) and (sign = 1)) then
    begin
      // ������� ����� ����������� � ��������� ������������
      commonDen := LCM(denominator, denominator_temp);

      // �������� ������ ����� � ������ ����������� � ��������� ������������
      if not IsMultiplicationWithinLongIntLimits(numerator, commonDen div denominator) then
      begin
        WriteLn('multiplication_overflow_in_longint');
        Halt;
      end;

      numerator := numerator * (commonDen div denominator);
      denominator := commonDen;

      // �������� ������ ����� � ������ �����������
      if not IsMultiplicationWithinLongWordLimits(numerator_temp, commonDen div denominator_temp) then
      begin
        WriteLn('multiplication_overflow_in_longword');
        Halt;
      end;
      numerator_temp := numerator_temp * (commonDen div denominator_temp);
      denominator_temp := commonDen;

      // �������� ������������ ��� ���������
      if not IsSubtractionWithinLongIntLimits(numerator, numerator_temp) then
      begin
        WriteLn('subtraction_overflow_in_longint');
        Halt;
      end;
      numerator := numerator - numerator_temp;
    end;

    // �������� ������� �� ����
    if denominator = 0 then
    begin
      WriteLn('division_by_zero');
      Halt;
    end;

    // ���������� �����
    ReduceFraction(numerator, denominator);
    

    // ����� ��������� ������������
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
