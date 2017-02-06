Linux
===========
top -c : dùng để xem thông tin hoạt động của server
free -m : dùng để kiểm tra thông tin bộ nhớ
df -h : dùng để kiểm tra dụng lượng ổ cứng
sync; echo 3 > /proc/sys/vm/drop_caches : dùng để giải phóng caches và làm tăng bộ nhớ
zip -r tenthumuc.zip tenthumuc :  nén thư mục 
unzip tenthumuc.zip
netstat -an |grep :80 |wc -l: xem có bao nhiêu kết nối đến cổng 80
mkdir: tạo thư mục mới
rm -rf tenthumuc/tenfile: xóa tệp tin
chmod +x *.sh     : phân quyền chạy các file sh
chmod -R 0777 /tênthưmục : phân quyền đọc ghi file trên folder cho tất cả user
set CATALINA_OPTS=-Xmx2g -XX:PermSize=500M -XX:MaxPermSize=800m
//-- gọi đến file setenv.bat
if not exist "%CATALINA_BASE%\bin\setenv.bat" goto checkSetenvHome
call "%CATALINA_BASE%\bin\setenv.bat"
goto setenvDone
:checkSetenvHome
if exist "%CATALINA_HOME%\bin\setenv.bat" call "%CATALINA_HOME%\bin\setenv.bat"
:setenvDone
//--

CATALINA_OPTS="-Xmx1g -XX:PermSize=256M -XX:MaxPermSize=500m" -- Tăng bộ nhớ Tomcat khi bị PermGem, viết trong Catalina.sh(Linux) hoặc Catalina.bat(Window)
export JAVA_HOME="/u01/qlqt/jdk1.7.0_25" --Chỉnh java_home cho Tomcat

--Trong file setenv.bat--
Window: set JAVA_OPTS=-Dfile.encoding=UTF-8 -Xms128m -Xmx1024m -XX:PermSize=64m -XX:MaxPermSize=256m
Linux: export JAVA_OPTS="-Xms1024m -Xmx10246m -XX:NewSize=256m -XX:MaxNewSize=356m -XX:PermSize=256m -XX:MaxPermSize=356m" 

--Xóa log server linux
echo 3 > /proc/sys/vm/drop_caches

--Xóa archive log server linux
rman TARGET / NOCATALOG   
delete archivelog from time 'SYSDATE-100' until time 'SYSDATE-10';


Oracle
===========
su - oracle  (dùng để vào oracle)
sqlplus / "as sysdba"               -- Login khong can user, su dung quyen DBA
startup                             -- Bat service
shutdown immediate                  -- Tat service


create user HSCV_THA identified by HSCV_THA;
grant dba to HSCV_THA;
GRANT CONNECT TO VSA_VOFFICE_FULL;
GRANT RESOURCE TO VSA_VOFFICE_FULL;
grant create any table to VSA_VOFFICE_FULL;


CREATE DIRECTORY DMPDIR as '/u02/dmpdir'; //create directory for importdb/exportdb

      
select file_id,file_name from dba_data_files where tablespace_name='USERS';
alter database datafile 4 autoextend on maxsize unlimited;
alter database datafile '/u01/oradata/qlcb/users01.dbf' autoextend on next 5m maxsize 900m;


---import & export---
--Các bước khi exp, imp dữ liệu:
--Bước1: Dùng tool WinSCP hoặc Secure Shell Client để kết nối đến server DB, ssh vào tài khoản root
--Bước 2: (Sau khi đã đăng nhập vào tài khoản root rồi), gõ các lệnh

su - oracle

--Bước 3: Tiếp tục sử dụng các lệnh exp hoặc imp, sử dungj ngoài sqlplus (nếu dùng sql gõ sqlplus sau khi đã su oracle)

--1.Sử dụng datapumb: chú ý thư mục directory chính là directory_name trong câu lệnh select datapump
expdp HSCV_BTP_FINAL/HSCV_BTP_FINAL schemas=HSCV_BTP_FINAL directory=DMPDIR dumpfile=file.dmp logfile=export.log
impdp QLQT_REAL/QLQT_REAL  REMAP_SCHEMA=QLQT1:QLQT_REAL directory=DATA_PUMP_DIR dumpfile=QLQT.DMP logfile=impQLQT.log;
--Note:     + SELECT * FROM all_directories where directory_name like 'DATA_PUMP_DIR';
            + Trong lệnh impdp, remap_schemas: QLQT1 - là user đã export db, QLQT_REAL - là user sẽ import db
            + Đã export bằng datapump thì phải import bằng datapump

Lệnh export exclude: expdp SOTUPHAP_LLTP/SOTUPHAP_LLTP schemas=SOTUPHAP_LLTP EXCLUDE=TABLE:\"LIKE \'%ACTION_LOG%\'\" directory=DATA_EXP dumpfile=QLLTP_OLD_2710.dmp logfile=QLLTP_OLD_2710.log

--2.Cách thường
imp username/password @database file=<đường dẫn\tenfile.dmp> ;
exp username/password @database file=<đường dẫn\tenfile.dmp> ; 


II.KHẮC PHỤC SỰ CỐ
1. Protocol adapter error
- Khắc phục: Restart service, listener server DB (services.msc)




-- Xoa limit password, doi password dinh ky, so lan login sai
SELECT profile FROM dba_users where username = 'QLQT';
ALTER PROFILE DEFAULT LIMIT               //DEFAULT là tên profile cần đổi, ở đây profile mặc định của user 'QLQT' là DEFAULT
FAILED_LOGIN_ATTEMPTS UNLIMITED
PASSWORD_LIFE_TIME UNLIMITED;

--Import va Export khi khac version, exclude là ko exp ra bang trong lenh exclude 
expdp SOTUPHAP_LLTP/SOTUPHAP_LLTP schemas=SOTUPHAP_LLTP EXCLUDE=TABLE:\"LIKE \'%ACTION_LOG%\'\" VERSION=10.2.0.4.0 directory=DATA_EXP dumpfile=QLLTP_OLD_2710.dmp logfile=QLLTP_OLD_2710.log

--Kill session
SELECT * FROM v$session where username =  'THA_DEMO';
ALTER SYSTEM KILL SESSION 'SID,SERIAL#' IMMEDIATE; 

-- Tao table space
 create tablespace TASKMANAGER
  logging
  datafile 'TASKMANAGERAIC.dbf' 
  size 512m -- tuy du lieu tang truong
  autoextend on 
  next 1024m maxsize 2048m -- tuy du lieu tang truong thuong la de 2048m
  extent management local;
  
ALTER SYSTEM KILL SESSION '18,20254';



ALTER TABLESPACE
   users
ADD DATAFILE
   '/u01/app/oracle/oradata/gpcntt/users01_add.dbf'
size 1024m;

ALTER TABLESPACE ILEGO_DATA DROP DATAFILE 'D:\oracle\oradata\btp\ILEGO_DATA_EXTENT.dbf';

ALTER TABLESPACE ILEGO_DATA 
    ADD DATAFILE 'D:\oracle\oradata\btp\ILEGO_DATA_EXTENT.dbf'
    SIZE 2048M
    AUTOEXTEND ON
    NEXT 512M
    MAXSIZE 30000M;

SELECT * FROM V$tablespace;

ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/gpcntt/users01_add.dbf'
    AUTOEXTEND ON;
