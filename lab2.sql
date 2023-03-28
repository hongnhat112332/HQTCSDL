use QuanLyBanHang
go

create table SanPham
(
	MaSP varchar(4) not null primary key,
	MaHangSX varchar(3) not null ,
	TenSP varchar(50) ,
	SoLuong int ,
	MauSac nvarchar(50) ,
	GiaBan bigint ,
	DonViTinh varchar(20) ,
	Mota nvarchar(50)
)
create table HangSX
(
	MaHangSX varchar(3) not null primary key ,
	TenHang varchar(50) not null , 
	DiaChi varchar(50) ,
	SDT varchar(20) ,
	Email varchar(20)
)
create table NhanVien
(
	MaNV varchar(4) not null primary key,
	TenNV varchar(50) ,
	GioiTinh varchar(3) ,
	DiaChi varchar(50) ,
	SDT varchar(20) ,
	Email varchar(30),
	Phong varchar(20)
)
create table Nhap
(
	SoHDN varchar(3) not null primary key,
	MaSP varchar(4) not null,
	MaNV varchar(4) not null,
	NgayNhap date ,
	SoLuongN int, 
	DonGian bigint
)
create table Xuat
(
	SoHDX varchar(3) not null primary key,
	MaSP varchar(4) not null,
	MaNV varchar(4) not null,
	NgayXuat date ,
	SoLuongX int
)
ALTER TABLE SanPham
ADD
   CONSTRAINT fk_1 FOREIGN KEY (MaHangSX) REFERENCES HangSX (MaHangSX)
   ON DELETE CASCADE
   ON UPDATE CASCADE

ALTER TABLE Nhap
ADD
   CONSTRAINT fk_2 FOREIGN KEY (MaSp) REFERENCES SanPham (MaSP),
   CONSTRAINT fk_3 FOREIGN KEY (MaNV) REFERENCES NhanVien (MaNV)
   ON DELETE CASCADE
   ON UPDATE CASCADE

ALTER TABLE Xuat
ADD
   CONSTRAINT fk_4 FOREIGN KEY (MaSp) REFERENCES SanPham (MaSP),
   CONSTRAINT fk_5 FOREIGN KEY (MaNV) REFERENCES NhanVien (MaNV)
   ON DELETE CASCADE
   ON UPDATE CASCADE

insert into HangSX
values('H01','Samsung',N'Korea',N'011-08271717',N'ss@gmail.com.kr'),
('H02','OPPO',N'china',N'081-08626262',N'oppo@gmail.com.cn'),
('H03','Vinfone',N'Việt Nam',N'084-098262626',N'vf@gmail.com.vn')

insert into NhanVien
values 
('NV01',N'Nguyễn Thị Thu',N'nữ',N'Hà Nội','0982626521','thu@gmail.com',N'Kế toán'),
('NV02',N'Lê văn Nam',N'nam',N'Bắc Ninh','0972525252','nam@gmail.com',N'Vật Tư'),
('NV03',N'Trần Hòa Bình',N'nữ',N'Hà Nội','0328388388','hb@gmail.com',N'Kế toán')

insert into SanPham
values 
('SP01','H02','F1 Plus','100',N'xám','7000000',N'chiếc',N'hàng cận cap cấp'),
('SP02','H01','Galaxy Note 11','50',N'đỏ','19000000',N'chiếc',N'hàng cap cấp'),
('SP03','H02','F3 lite','200',N'nâu','3000000',N'chiếc',N'hàng phổ thông'),
('SP04','H03','Vjoy3','200',N'xám','1500000',N'chiếc',N'hàng phổ thông'),
('SP05','H01','Galaxy v21','500',N'nâu','8000000',N'chiếc',N'hàng cận cap cấp')

insert into Nhap
values 
('N01','SP02','NV01','02-05-2019',10,17000000),
('N02','SP01','NV02','04-07	-2020',30,6000000),
('N03','SP04','NV02','05-17-2020',20,1200000),
('N04','SP01','NV03','03-22-2020',10,6200000),
('N05','SP05','NV01','07-07-2020',20,7000000)

insert into Xuat
values 
('X01','SP03','NV02','06-14-2020',5),
('X02','SP01','NV03','03-05-2019',3),
('X03','SP02','NV01','12-12-2020',1),
('X04','SP03','NV02','06-02-2020',2),
('X05','SP05','NV01','05-18-2020',1)

BACKUP DATABASE QuanLyBanHang TO DISK='D:\TranHongNhat\lab2'

RESTORE DATABASE QuanLyBanHang FROM DISK='D:\TranHongNhat\lab2'
