(*
 * Project: RationalNumbersCalculator
 * Date: 27.10.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
program rational_numbers_calculator;
uses execute_helper, custom_types, parser_helper, arguments_helper, output_helper;

var
  input: char;  // ���������� ��� �������� �������� �������, ���������� �������������
  input_buffer: custom_types.buffer_array_t;  // ����� ��� �������� ��������� ��������
  command: custom_types.command_t;  // �������
  sign: custom_types.sign_t;  // ���� ����� (��������, + ��� -)
  status: custom_types.status_t;  // ������� ������ ���������� ���������
  finish_status: custom_types.finish_status_t;  // ������ ���������� ���������
  number_system: Word;  // ������� ��������� (��������, 16 ��� �����������������)
  pointer: Integer;  // ��������� �� ������� ������� � ������
  numerator_first_num, denominator_first_num, comment: Boolean;  // �����, ���������� ��������� ���������
  numerator: longint;  // ���������
  denominator, numerator_temp, denominator_temp: longword;  // ����������� � ��������� ���������� ��� ��������� � �����������
  number_system_array: custom_types.number_system_t;  // ������ � ������� ���������
  i: Integer;



begin
  // ������������� ��������� ��������
  status := 0;
  command := 0;
  finish_status := 0;
  sign := 0;

  number_system := 0;
  pointer := 1;

  numerator_first_num := true;  // ���� ��� ������������ ������� ����� ���������
  denominator_first_num := true;  // ���� ��� ������������ ������� ����� �����������

  numerator := 0;  // ��������� ���������
  denominator := 1;  // ��������� ����������� (�� ����� ���� 0)
  numerator_temp := 0;  // ���������� ���� ������������� ��������� ������ � �������
  denominator_temp := 1;  // ���������� ���� ������������� ����������� ������ � �������

  comment := false;  // ���� ��� �����������, ��������� �� ��������� � ��������� �����������

  number_system_array := GetNumberSystems();


  WriteLn('=========================================');

  while true do
  begin
    Read(input);  // ������ ����� �� ������������ (���� ������ �� ���)
    // ��������� ������� � ���������� �������
    status := ExecuteCommand(input, numerator_first_num, denominator_first_num, sign, comment,
                              number_system, pointer, status, command,
                              numerator_temp, numerator, denominator_temp,
                              denominator);

    // ��������, ���� ������� ������ �������� ������ �����������, ���������� ���
    if CheckHaveComment(input, comment) and (status <> -3) then continue;

    // �������� �� ���������� ���������
    status := CheckFihish(input, status, finish_status);


    // � ����������� �� �������� �������, �������� ��������������� �������
    case status of
      -3: status := 0;  // ������ -3: ����� ���������
      -2: break;  // ������ -2: ���������� ���������
      -1: continue;  // ������ -1: ����������� ��������� (���������� ������� ������)
        // �������� ����� ��������� �����:
      0: status := InputCommandSymbol(input, command);  // ��������� ������� ������� (��������, +, -, *, /)
      1: status := InputSpaceAfterCommand(input);  // �������� ������� ����� �������
      2: status := InputFirstSymbolsNumberSystems(input, number_system);  // ��������� ������� ������� ������� ���������
      3: status := InputSymbolsNumberSystems(input, number_system);  // ��������� �������� ������� ���������
      4: status := InputSpaceAfterColomn(input);  // �������� ������� ����� ���������
      5: status := InputSignOrFirstNumbersNumerator(input, sign, numerator_first_num, input_buffer, numerator_temp, number_system, pointer);  // ���� ����� ��� ����� ���������
      6: status := InputNumbersNumerator(input, numerator_first_num, input_buffer, numerator_temp, number_system, pointer);  // ���� ����� ���������
      7: status := InputNumbersDenominator(input, input_buffer, denominator_temp, denominator_first_num, number_system, pointer);  // ���� ����� �����������
    end;
  end;
  WriteLn('=========================================');
  WriteLn(numerator);
  WriteLn(denominator);
  for i:=1 to MAX_NUMBER_SYSTEM do
  begin
    if number_system_array[i] = -1 then continue;
    WriteNumeratorDenominatorToBase(numerator, denominator, number_system_array[i]);
  end;

end.
