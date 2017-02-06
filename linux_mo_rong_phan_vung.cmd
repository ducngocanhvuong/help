MỞ RỘNG PHÂN VÙNG TRÊN LINUX KHÔNG CẦN REBOOT
I.	GHI CHÚ
-	Không áp dụng với disk cài OS (thông thường là sda) 
-	Không áp dụng với disk được chia nhiều partition, ví dụ, disk /dev/sdb được chia làm 2 partition:
o	/dev/sdb1  -> mount vào /u01
o	/dev/sdb2  -> mount vào /u02
	 Hai trường hợp trên có cách thực hiện khác  đang hoàn thiện guideline
II.	CÁCH THỰC HIỆN
Ví dụ: Cần mở rộng disk /dev/sdb, với /dev/sdb1được mount vào /u01
2.1.	Scan vùng mở rộng của Disk
Mỗi disk có 1 ID riêng, dùng lệnh: 
#ls /sys/bus/scsi/devices    để xem ID của Disk cần mở rộng, ví dụ như:
sda -> 0\:0\:0\:0
sdb -> 0\:0\:1\:0
sdc -> 0\:0\:2\:0
.....
Dùng lệnh sau để scan phần mở rộng của disk:
#echo 1 > /sys/bus/scsi/devices/0\:0\:1\:0/rescan 
# /sbin/fdisk -l |grep sdb     		->   Kiểm tra xem disk /dev/sdb đã nhận đủ dung lượng đã add thêm.
#umount /u01
2.2.	Các bước thực hiện mở rộng
# /sbin/fdisk /dev/sdb
The number of cylinders for this disk is set to 1958.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)
Command (m for help): d            -> Chọn d để delete partition cũ
Selected partition 1
Command (m for help): n   	    -> Chọn n để tạo partition mới
Command action
   e   extended
   p   primary partition (1-4)
p  				  -> Chọn p
Partition number (1-4): 1           -> Chọn 1
First cylinder (1-1958, default 1): 
Using default value 1
Last cylinder or +size or +sizeM or +sizeK (1-1958, default 1958): 
Using default value 1958
Command (m for help): w	-> Chọn w để ghi lại.
2.3.	Thực hiện tiếp các lệnh sau để mở rộng partition
#/sbin/e2fsck -f /dev/sdb1
#/sbin/resize2fs /dev/sdb1
#mount /dev/sdb1 /u01
->	Kết thúc, kiểm tra lại dữ liệu và dung lượng trong /u01.
