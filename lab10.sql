use QuanLyBanHang
go

--Thêm dữ liệu cho bảng NhanVien sau đó thực hiện full backup
insert into NhanVien
values ('NV01','Tran Hong Nhat','Nam','dong nai','0328634871','nhat@gmail.com','ke toan');

BACKUP DATABASE QuanLyBanHang TO DISK = 'D:\ TranHongNhat' WITH INIT;


--Thêm dữ liệu cho bảng NhanVien sau đó thực hiện different backup

BACKUP DATABASE QuanLyBanHang TO DISK = 'D:\ TranHongNhat' WITH differential, format;

--thực hiện log backup
backup log QuanLyBanHang to disk = 'D:\ TranHongNhat'WITH INIT;

--khôi phục dữ liệu với file backup
RESTORE LOG QuanLyBanHang
FROM DISK = 'D:\ TranHongNhat\QlBanHang'
WITH RECOVERY