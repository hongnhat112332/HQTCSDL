use QuanLyBanHang
go

/*câu 1: Tạo trigger kiểm soát việc nhập dữ liệu cho bảng nhập. 
hãy kiểm tra các ràng buộc toàn vẹn: masp có trong bảng sản phẩm chưa?
 manv có trong bảng nhân viên chưa? kiểm tra các ràng buộc dữ liệu: soluongN và dongiaN>0? 
 Sau khi nhập thì soluong ở bảng Sanpham sẽ được cập nhật theo.*/

 CREATE TRIGGER trgNhap ON Nhap AFTER INSERT AS
BEGIN
    DECLARE @masp VARCHAR(10)
    DECLARE @manv VARCHAR(10)
    DECLARE @soluongN INT
    DECLARE @dongiaN FLOAT

    SELECT @masp = masp, @manv = manv, @soluongN = soluongN, @dongiaN = dongiaN FROM inserted

    IF NOT EXISTS (SELECT masp FROM Sanpham WHERE masp = @masp)
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng Sanpham.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF NOT EXISTS (SELECT manv FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng Nhanvien.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF @soluongN <= 0 OR @dongiaN <= 0
    BEGIN
        RAISERROR('Số lượng và đơn giá phải lớn hơn 0.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    UPDATE Sanpham SET soluong = soluong + @soluongN WHERE masp = @masp
END

/*câu 2:. Tạo trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc toàn vẹn: masp có trong bảng sản phẩm chưa?
 manv có trong bảng nhân viên chưa? kiểm tra các ràng buộc dữ liệu: soluongX < soluong trong bảng sanpham? 
 Sau khi xuất thì soluong ở bảng Sanpham sẽ được cập nhật theo.*/
CREATE TRIGGER kiem_soat_xuat
ON Xuat
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @masp INT, @manv INT, @soluongX INT;

    SELECT @masp = masp, @manv = manv, @soluongX = soluongX
    FROM inserted;

    -- Kiểm tra ràng buộc toàn vẹn
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RAISERROR ('Mã sản phẩm không tồn tại trong bảng Sanpham', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RAISERROR ('Mã nhân viên không tồn tại trong bảng Nhanvien', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Kiểm tra ràng buộc dữ liệu
    IF @soluongX < 1
    BEGIN
        RAISERROR ('Số lượng xuất phải lớn hơn 0', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DECLARE @soluong_old INT;
    DECLARE @cursor CURSOR;

    SET @cursor = CURSOR FAST_FORWARD FOR
        SELECT soluong FROM Sanpham WHERE masp = @masp;

    OPEN @cursor;
    FETCH NEXT FROM @cursor INTO @soluong_old;

    -- Kiểm tra số lượng sản phẩm còn lại
    IF @soluong_old < @soluongX
    BEGIN
        RAISERROR ('Số lượng xuất lớn hơn số lượng hiện có', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Cập nhật số lượng sản phẩm sau khi xuất
    UPDATE Sanpham SET soluong = @soluong_old - @soluongX WHERE masp = @masp;

    CLOSE @cursor;
    DEALLOCATE @cursor;
END;

/*câu 3. Tạo trigger kiểm soát việc xóa phiếu xuất, 
khi phiếu xuất xóa thì số lượng hàng trong bảng sanpham sẽ được cập nhật tăng lên.*/
