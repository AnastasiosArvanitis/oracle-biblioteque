DECLARE
    nValue NUMBER(10) := &enter_value;
    vMessage varchar(30);

begin
  If nValue > 60000 then

    vMessage := q'!The value isn't valid.!';
    dbms_output.put_line(vMessage);
    End if;
end;
/

select * from Locations;