create or replace procedure checkAccTranslog(n_min in number,
                                             n_max in number) as
  C_ALL_CURSOR  types.ref_cursor;
  C_ITEM_CURSOR types.ref_cursor;

  type t_pay_log is record(
    count    number(30),
    acc_name varchar2(1000));
  st_pay_log t_pay_log;

  type t_item is record(
    acc_name     varchar2(1000),
    item_type    NUMBER default 0,
    acct_balance NUMBER default 0,
    freeze_money NUMBER default 0,
    credit_money NUMBER default 0);
  st_item t_item;

  type t_translog is record(
    acc_name     varchar2(1000),
    MONEY_AFTER  number,
    MONEY_BEFORE number,
    MONEY        number,
    ITEM_TYPE    number,
    ACCT_TYPE    number,
    OPT_TYPE     number);
  st_translog t_translog;

  CURSOR CUR_TUSER IS
    SELECT *
      FROM T_A_USER
     WHERE mod(to_number(SUBSTR(U_USERNAME, -2, 2)), 64) in (n_min, n_max);
  ROW_TUSER CUR_TUSER%rowtype;

  TSTR_INDEX     VARCHAR2(3);
  TNUM_INDEX     NUMBER;
  n_total_cash   number;
  n_total_limit  number;
  n_cash         number;
  n_limit        number;
  n_freeze       number;
  n_isnull       number;
  n_MONEY_AFTER  number;
  n_MONEY_BEFORE number;
  n_count        number;
  n_offset       number;
  n_ACCT_TYPE    number;
  n_ITEM_TYPE    number;
  s_acc_name     varchar2(1000);
begin
  EXECUTE IMMEDIATE 'truncate table t_TMP_ITEM';

  FOR TNUM_INDEX IN n_min .. n_max LOOP
  
    open C_ALL_CURSOR for 'select acc_name, count(1) count from T_ACCOUNT_TRANSLOG' || TNUM_INDEX || ' t where t.opt_type in(9) and t.money_before-t.money_after != t.money group by acc_name';
    loop
      fetch C_ALL_CURSOR
        into s_acc_name, n_count;
      exit when C_ALL_CURSOR%notfound;
      dbms_output.put_line('acc_name=' || s_acc_name || ', counts=' ||
                           n_count);
    end loop;
    close C_ALL_CURSOR;
  
    open C_ALL_CURSOR for 'SELECT A.acc_name,B.MONEY_AFTER,B.MONEY_BEFORE FROM T_ACCOUNT_ITEM' || TNUM_INDEX || ' A  INNER JOIN 
          (SELECT * FROM T_ACCOUNT_TRANSLOG' || TNUM_INDEX || ' WHERE OFFSET IN
          (SELECT OFFSET FROM( SELECT MAX(OFFSET) OFFSET,ITEM_TYPE,ACC_NAME FROM T_ACCOUNT_TRANSLOG' || TNUM_INDEX || ' WHERE STATUS=10 AND acct_type=2 GROUP BY ITEM_TYPE,ACC_NAME)))
           B ON A.ACC_NAME=B.ACC_NAME AND A.ITEM_TYPE=B.ITEM_TYPE AND A.ACCT_BALANCE!=B.MONEY_AFTER';
    loop
      fetch C_ALL_CURSOR
        into s_acc_name, n_MONEY_BEFORE, n_MONEY_AFTER;
      exit when C_ALL_CURSOR%notfound;
      dbms_output.put_line('acc_name=' || s_acc_name || ', before=' ||
                           n_MONEY_BEFORE || ', after=' || n_MONEY_AFTER);
    end loop;
    close C_ALL_CURSOR;
  
    open C_ALL_CURSOR for 'SELECT A.UA_NAME ACC_NAME,B.MONEY_AFTER,B.MONEY_BEFORE FROM T_ACCOUNT' || TNUM_INDEX || ' A  INNER JOIN 
          (SELECT * FROM T_ACCOUNT_TRANSLOG' || TNUM_INDEX || ' WHERE OFFSET IN
          (SELECT OFFSET FROM( SELECT MAX(OFFSET) OFFSET,ITEM_TYPE,ACC_NAME FROM T_ACCOUNT_TRANSLOG' || TNUM_INDEX || ' WHERE STATUS=10 AND acct_type in(1,3) GROUP BY ITEM_TYPE,ACC_NAME)))
           B ON A.Ua_Name=B.ACC_NAME  AND A.UA_CASH+A.UA_LIMITED_MONEY!=B.MONEY_AFTER';
    loop
      fetch C_ALL_CURSOR
        into s_acc_name, n_MONEY_BEFORE, n_MONEY_AFTER;
      exit when C_ALL_CURSOR%notfound;
      dbms_output.put_line('acc_name=' || s_acc_name || ', before=' ||
                           n_MONEY_BEFORE || ', after=' || n_MONEY_AFTER);
    end loop;
    close C_ALL_CURSOR;
  END LOOP;

  open CUR_TUSER;
  loop
    FETCH CUR_TUSER
      INTO ROW_TUSER;
    Exit when(CUR_TUSER%NOTFOUND);
    IF (CUR_TUSER%FOUND) then
      TSTR_INDEX := SUBSTR(ROW_TUSER.U_USERNAME, -2, 2);
      TNUM_INDEX := mod(to_number(TSTR_INDEX), 64);
      -- check pay
      -- thirdparty pay OPT_TRANSFER_IN(5) OPT_THIRDPARTY_PAY(8)
      -- banlance pay
      --????????
      n_total_cash := -1;
      open C_ALL_CURSOR for 'SELECT DISTINCT A.ACCT_TYPE,A.ITEM_TYPE,A.MONEY_BEFORE,A.OFFSET FROM T_ACCOUNT_TRANSLOG' || TNUM_INDEX || ' A INNER JOIN (
          SELECT MIN(TRANSACTION) TRANSACTION,ACCT_TYPE FROM T_ACCOUNT_TRANSLOG' || TNUM_INDEX || ' WHERE ACC_NAME=:1 AND STATUS=10  GROUP BY ACCT_TYPE
          ) B ON A.TRANSACTION=B.TRANSACTION ORDER BY OFFSET'
        USING ROW_TUSER.U_USERNAME;
      loop
        fetch C_ALL_CURSOR
          into n_ACCT_TYPE, n_item_type, n_MONEY_BEFORE, n_offset;
        exit when C_ALL_CURSOR%notfound;
        case
          when n_ACCT_TYPE = 1 then
            n_total_cash := n_MONEY_BEFORE;
            --n_total_limit:=0;
          when n_ACCT_TYPE = 3 AND n_total_cash = -1 then
            n_total_cash := n_MONEY_BEFORE;
          when n_ACCT_TYPE = 2 then
            insert into TMP_ITEM

              (acc_name,
               item_type,
               acct_balance,
               freeze_money,
               credit_money)
            values
              (ROW_TUSER.U_USERNAME, n_item_type, n_MONEY_BEFORE, 0, 0);
          ELSE
            NULL;
        end case;
      
      end loop;
      close C_ALL_CURSOR;
      open C_ALL_CURSOR for 'SELECT acc_name,MONEY_AFTER,MONEY_BEFORE,MONEY,ITEM_TYPE,ACCT_TYPE,OPT_TYPE FROM T_ACCOUNT_TRANSLOG' || TNUM_INDEX || ' WHERE ACC_NAME=:1 AND STATUS=10 ORDER BY TRANSACTION,OFFSET'
        using ROW_TUSER.U_USERNAME;
      loop
        fetch C_ALL_CURSOR
          into st_translog;
        exit when C_ALL_CURSOR%notfound;
      
        if st_translog.ACCT_TYPE = 2 then
          EXECUTE IMMEDIATE 'SELECT acc_name,item_type,acct_balance,freeze_money,credit_money FROM TMP_ITEM WHERE acc_name=:1 AND item_type=:2'
            into st_item
            using st_translog.acc_name, st_translog.ITEM_TYPE;
        end if;
        case
          when st_translog.OPT_TYPE = 2 then
            -- recharge
            case
              when st_translog.ACCT_TYPE = 1 then
                n_total_cash := n_total_cash + st_translog.MONEY;
              when st_translog.ACCT_TYPE = 3 then
                n_total_cash := n_total_cash + st_translog.MONEY;
              when st_translog.ACCT_TYPE = 2 then
                st_item.acct_balance := st_item.acct_balance +
                                        st_translog.MONEY;
            end case;
          when st_translog.OPT_TYPE = 4 then
            --CASH_OUT
            n_total_cash := n_total_cash - st_translog.MONEY;
          when st_translog.OPT_TYPE = 5 then
            --TRANSFER_IN 
            case
              when st_translog.ACCT_TYPE = 1 then
                n_total_cash := n_total_cash + st_translog.MONEY;
              when st_translog.ACCT_TYPE = 3 then
                n_total_cash := n_total_cash + st_translog.MONEY;
              when st_translog.ACCT_TYPE = 2 then
                st_item.acct_balance := st_item.acct_balance +
                                        st_translog.MONEY;
            end case;
          when st_translog.OPT_TYPE = 6 then
            --TRANSFER_OUT 
            case
              when st_translog.ACCT_TYPE = 1 then
                n_total_cash := n_total_cash - st_translog.MONEY;
              when st_translog.ACCT_TYPE = 3 then
                n_total_cash := n_total_cash - st_translog.MONEY;
              when st_translog.ACCT_TYPE = 2 then
                st_item.acct_balance := st_item.acct_balance -
                                        st_translog.MONEY;
            end case;
          
          when st_translog.OPT_TYPE = 8 then
            --OPT_THIRDPARTY_PAY
            case
              when st_translog.ACCT_TYPE = 1 then
                n_total_cash := n_total_cash - st_translog.MONEY;
              when st_translog.ACCT_TYPE = 3 then
                n_total_cash := n_total_cash - st_translog.MONEY;
              when st_translog.ACCT_TYPE = 2 then
                st_item.acct_balance := st_item.acct_balance -
                                        st_translog.MONEY;
            end case;
          when st_translog.OPT_TYPE = 9 then
            --PAY
            case
              when st_translog.ACCT_TYPE = 1 then
                n_total_cash := n_total_cash - st_translog.MONEY;
              when st_translog.ACCT_TYPE = 3 then
                n_total_cash := n_total_cash - st_translog.MONEY;
              when st_translog.ACCT_TYPE = 2 then
                st_item.acct_balance := st_item.acct_balance -
                                        st_translog.MONEY;
            end case;
          when st_translog.OPT_TYPE = 10 then
            --PAY_IN
            case
              when st_translog.ACCT_TYPE = 1 then
                n_total_cash := n_total_cash + st_translog.MONEY;
              when st_translog.ACCT_TYPE = 3 then
                n_total_cash := n_total_cash + st_translog.MONEY;
              when st_translog.ACCT_TYPE = 2 then
                st_item.acct_balance := st_item.acct_balance +
                                        st_translog.MONEY;
            end case;
          when st_translog.OPT_TYPE = 12 then
            --REFUND
            case
              when st_translog.ACCT_TYPE = 1 then
                n_total_cash := n_total_cash - st_translog.MONEY;
              when st_translog.ACCT_TYPE = 3 then
                n_total_cash := n_total_cash - st_translog.MONEY;
              when st_translog.ACCT_TYPE = 2 then
                st_item.acct_balance := st_item.acct_balance -
                                        st_translog.MONEY;
            end case;
          when st_translog.OPT_TYPE = 13 then
            --REFUND_IN
            case
              when st_translog.ACCT_TYPE = 1 then
                n_total_cash := n_total_cash + st_translog.MONEY;
              when st_translog.ACCT_TYPE = 3 then
                n_total_cash := n_total_cash + st_translog.MONEY;
              when st_translog.ACCT_TYPE = 2 then
                st_item.acct_balance := st_item.acct_balance +
                                        st_translog.MONEY;
            end case;
          ELSE
            NULL;
        end case;
        if st_translog.ACCT_TYPE = 2 then
          update TMP_ITEM
             set acct_balance = st_item.acct_balance,
                 freeze_money = st_item.freeze_money
           where acc_name = st_item.acc_name
             and ITEM_TYPE = st_item.ITEM_TYPE;
        end if;
      end loop;
      close C_ALL_CURSOR;
    
    END IF;
  
    EXECUTE IMMEDIATE 'INSERT INTO t_TMP_ITEM(acc_name,item_type,acct_balance,freeze_money,credit_money,Tab_Suffix,CHECK_BALANCE,ACCT_TYPE)select a.acc_name,a.item_type,a.acct_balance,a.freeze_money,a.credit_money,' ||
                      TNUM_INDEX || ',b.acct_balance,2 from T_ACCOUNT_ITEM' ||
                      TNUM_INDEX ||
                      ' a inner join TMP_ITEM b on a.acc_name=b.acc_name and a.item_type=b.item_type where a.acct_balance!=b.acct_balance or a.freeze_money!=b.freeze_money';
  
    EXECUTE IMMEDIATE 'SELECT UA_CASH,UA_LIMITED_MONEY,UA_FREEZE_TOTAL FROM T_ACCOUNT' ||
                      TNUM_INDEX || ' WHERE UA_NAME=:1'
      into n_cash, n_limit, n_freeze
      using ROW_TUSER.U_USERNAME;
    n_cash := n_cash + n_limit;
    if n_total_cash != n_cash AND n_total_cash != -1 then
      INSERT INTO t_TMP_ITEM
        (acc_name,
         item_type,
         acct_balance,
         freeze_money,
         credit_money,
         Tab_Suffix,
         CHECK_BALANCE,
         ACCT_TYPE)
      VALUES
        (ROW_TUSER.U_USERNAME,
         0,
         n_cash,
         0,
         0,
         TNUM_INDEX,
         n_total_cash,
         1);
    end if;
  
    EXECUTE IMMEDIATE 'truncate table TMP_ITEM';
  
  END LOOP;
  close CUR_TUSER;

end checkAccTranslog;
