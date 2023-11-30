USE bankinhapi
GO


----------------------------------------------tim Khachhang theo id----------------------------------------

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_khach_get_by_id](@id int)
AS
    BEGIN
      SELECT  *
      FROM KhachHangs
      where id= @id;
    END;

	EXEC [dbo].[sp_khach_get_by_id] @id = 2

------------------------------------------------them khach hàng-------------------------------------
GO
create PROCEDURE [dbo].[sp_khach_create](
@TenKH nvarchar(50),
@GioiTinh bit,
@DiaChi nvarchar(250),
@SDT nvarchar(50),
@Email nvarchar(250)
)
AS
    BEGIN
       insert into KhachHangs(TenKH,GioiTinh,DiaChi,SDT,Email)
	   values(@TenKH,@GioiTinh,@DiaChi,@SDT,@Email);
    END;

	
--------------------------------------------------xóa khach hàng-------------------------------------

GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE deletekhachang(@id int)
AS
    BEGIN
        DELETE FROM KhachHangs
        WHERE id = @id;
    END;


	EXEC deletekhachang @id = 2;

select * from KhachHangs


--------------------------------------------------update khách hàng -------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE sp_khach_update
   (
    @Id int,
	@TenKH nvarchar(50),
	@GioiTinh bit,
	@DiaChi nvarchar(50),
	@SDT nvarchar(50),
	@Email nvarchar(50)
	)
AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[KhachHangs] WHERE Id = @Id)
	BEGIN
		UPDATE [dbo].[KhachHangs]
		SET TenKH = @TenKH,
		    GioiTinh = @GioiTinh,
			DiaChi = @DiaChi,
			SDT = @SDT,
			Email = @Email
		WHERE Id = @Id
	END;
END;

select * from Khachhangs


-----------------------------------------------tim hoa don theo id ---------------------------------------
create proc sp_hoadon_get_by_id
				@MaHoaDon int
			as
			begin
				select * from [dbo].[HoaDons] where MaHoaDon = @MaHoaDon
			end;
select * from HoaDons
exec sp_hoadon_get_by_id '1'




-- -----------------------------------------thu tuc xoa hoadon-----------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[deletehoadon]
	@MaHoaDon int
as
begin
	delete ct from [dbo].[HoaDons]  hd inner join ChiTietHoaDons ct on  hd.MaHoaDon = ct.MaHoaDon and hd.MaHoaDon = @MaHoaDon
	delete from [dbo].[HoaDons] where MaHoaDon = @MaHoaDon
end;

select * from HoaDons


-------------------------------------------Hoa Don Create--------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Alter PROCEDURE sp_hoadon_create
(@TenKH              NVARCHAR(50), 
 @Diachi          NVARCHAR(250), 
 @TrangThai         bit, 
 @GioiTinh bit,
 @list_json_chitiethoadon NVARCHAR(MAX)
)
AS
    BEGIN
		DECLARE @MaHoaDon INT;
        INSERT INTO HoaDons
                (TenKH, 
                 Diachi, 
				 GioiTinh,
                 TrangThai               
                )
                VALUES
                (@TenKH, 
                 @Diachi, 
				 @GioiTinh,
                 @TrangThai
                );

				SET @MaHoaDon = (SELECT SCOPE_IDENTITY());
                IF(@list_json_chitiethoadon IS NOT NULL)
                    BEGIN
                        INSERT INTO ChiTietHoaDons
						 (
						  MaHoaDon,
                          MaSanPham, 
                          SoLuong,
						  TongGia
                        )
                    SELECT 
                            @MaHoaDon, 
							JSON_VALUE(p.value, '$.maSanPham'), 
                            JSON_VALUE(p.value, '$.slBan'), 
                            JSON_VALUE(p.value, '$.giaBan')    
                    FROM OPENJSON(@list_json_chitiethoadon) AS p;
                END;
        SELECT '';
    END;

select * from HoaDons
EXEC [dbo].sp_hoadon_create
 


----------------------------------------update hóa đơn------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_hoa_don_update]
(@MaHoaDon        int, 
 @TenKH              NVARCHAR(50), 
 @Diachi          NVARCHAR(250), 
 @TrangThai         bit,  
 @list_json_chitiethoadon NVARCHAR(MAX)
)
AS
    BEGIN
		UPDATE HoaDons
		SET
			TenKH  = @TenKH ,
			Diachi = @Diachi,
			TrangThai = @TrangThai
		WHERE MaHoaDon = @MaHoaDon;
		
		IF(@list_json_chitiethoadon IS NOT NULL) 
		BEGIN
			 -- Insert data to temp table 
		   SELECT
			  JSON_VALUE(p.value, '$.maChiTietHoaDon') as maChiTietHoaDon,
			  JSON_VALUE(p.value, '$.maHoaDon') as maHoaDon,
			  JSON_VALUE(p.value, '$.maSanPham') as maSanPham,
			  JSON_VALUE(p.value, '$.soLuong') as soLuong,
			  JSON_VALUE(p.value, '$.tongGia') as tongGia,
			  JSON_VALUE(p.value, '$.status') AS status 
			  INTO #Results 
		   FROM OPENJSON(@list_json_chitiethoadon) AS p;
		 
		 -- Insert data to table with STATUS = 1;
			INSERT INTO ChiTietHoaDons (MaSanPham, 
						  MaHoaDon,
                          SoLuong, 
                          TongGia ) 
			   SELECT
				  #Results.maSanPham,
				  @MaHoaDon,
				  #Results.soLuong,
				  #Results.tongGia			 
			   FROM  #Results 
			   WHERE #Results.status = '1' 
			
			-- Update data to table with STATUS = 2
			  UPDATE ChiTietHoaDons 
			  SET
				 SoLuong = #Results.soLuong,
				 TongGia = #Results.tongGia
			  FROM #Results 
			  WHERE  ChiTietHoaDons.maChiTietHoaDon = #Results.maChiTietHoaDon AND #Results.status = '2';
			
			-- Delete data to table with STATUS = 3
			DELETE C
			FROM ChiTietHoaDons C
			INNER JOIN #Results R
				ON C.maChiTietHoaDon=R.maChiTietHoaDon
			WHERE R.status = '3';
			DROP TABLE #Results;
		END;
        SELECT '';
    END;

select * from HoaDons
select * from ChiTietHoaDons



------------------------------------------ tai khoản admin --------------------------------------------------

go

create proc sp_get_tk_by_id @id nvarchar(10)
as
	begin 
		select * from TaiKhoans where MaTaiKhoan = @id
	end
go


DROP PROCEDURE IF EXISTS sp_create_tk;
go

-- Corrected stored procedure
CREATE PROCEDURE sp_insert_tai_khoan
    @TenTaiKhoan NVARCHAR(50),
    @MatKhau NVARCHAR(50),
    @Email NVARCHAR(150),
    @MaLoai INT -- Thêm tham số cho Mã Loại tài khoản
AS
BEGIN
    DECLARE @MaTaiKhoan INT;

    -- Thêm tài khoản vào bảng TaiKhoans
    INSERT INTO TaiKhoans (LoaiTaiKhoan, TenTaiKhoan, MatKhau, Email)
    VALUES (@MaLoai, @TenTaiKhoan, @MatKhau, @Email);

    -- Lấy Mã Tài Khoản vừa được tạo
    SET @MaTaiKhoan = SCOPE_IDENTITY();

    -- Đoạn mã khác nếu bạn cần xử lý thêm sau khi thêm vào bảng TaiKhoans

    -- In ra Mã Tài Khoản vừa được tạo (bạn có thể xóa dòng này nếu không cần)
    SELECT @MaTaiKhoan AS MaTaiKhoan;
END;
EXEC sp_insert_tai_khoan
    @TenTaiKhoan = N'hiep123',
    @MatKhau = N'123',
    @Email = N'email1@example.com',
    @MaLoai = 2; 
GO


-------------------------------------------update tai khoan -----------------------------


create proc sp_update_tk @id nvarchar(10),
@TenTaiKhoan nvarchar(max),
@MatKhau nvarchar(max),
@Email nvarchar(max),
@LoaiTaiKhoan nvarchar(10)
as
	begin
		update TaiKhoans
		set TenTaiKhoan = @TenTaiKhoan,
			MatKhau = @MatKhau,
			Email = @Email,
			LoaiTaiKhoan = @LoaiTaiKhoan
		where MaTaiKhoan = @id
	end
go

create proc sp_delete_tk @id nvarchar(10)
as
	begin 
		delete from TaiKhoans where MaTaiKhoan = @id
	end
go



-------------------------------------------------tim kiem------------------------------------------------
	SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_khach_update]
   (
    @Id int,
	@TenKH nvarchar(50),
	@GioiTinh bit,
	@DiaChi nvarchar(50),
	@SDT nvarchar(50),
	@Email nvarchar(50)
	)
AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[KhachHangs] WHERE Id = @Id)
	BEGIN
		UPDATE [dbo].[KhachHangs]
		SET TenKH = @TenKH,
		    GioiTinh = @GioiTinh,
			DiaChi = @DiaChi,
			SDT = @SDT,
			Email = @Email
		WHERE Id = @Id
	END;
END;


----------------------------------------------sản phẩm --------------------------------------------------------

-------------------------------------Tìm kiếm Sản Phẩm  theo mã ID-----------------------------------------
CREATE PROCEDURE sp_GetSanPhamByID
    @MaSanPham INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM
        SanPhams
    WHERE
        MaSanPham = @MaSanPham;
END
GO
select * from SanPhams



-----------------------------------------Tạo Sản Phẩm------------------------------------------------
CREATE PROCEDURE sp_InsertSanPham
    @MaChuyenMuc int,
    @TenSanPham nvarchar(150),
    @AnhDaiDien nvarchar(350),
    @Gia decimal(18, 0),
    @GiaGiam decimal(18, 0),
    @SoLuong int,
    @TrangThai bit,
    @LuotXem int,
    @DacBiet bit
AS
BEGIN
    INSERT INTO SanPhams (MaChuyenMuc, TenSanPham, AnhDaiDien, Gia, GiaGiam, SoLuong, TrangThai, LuotXem, DacBiet)
    VALUES (@MaChuyenMuc, @TenSanPham, @AnhDaiDien, @Gia, @GiaGiam, @SoLuong, @TrangThai, @LuotXem, @DacBiet)
    
    SELECT SCOPE_IDENTITY() -- Trả về ID của sản phẩm vừa được thêm vào
END
GO
exec sp_InsertSanPham 34,hiep,sting,5000,10,50,true,10,true
GO
DECLARE @MaChuyenMuc int,
        @TenSanPham nvarchar(150),
        @AnhDaiDien nvarchar(350),
        @Gia decimal(18, 0),
        @GiaGiam decimal(18, 0),
        @SoLuong int,
        @TrangThai bit,
        @LuotXem int,
        @DacBiet bit;

-- Gán giá trị cho các biến
SET @MaChuyenMuc = 37; -- Thay giá trị tùy theo MaChuyenMuc mong muốn
SET @TenSanPham = N'Tên Sản Phẩm Mới';
SET @AnhDaiDien = N'URL_anh';
SET @Gia = 100000;
SET @GiaGiam = 50000;
SET @SoLuong = 10;
SET @TrangThai = 1; -- 1 là true, 0 là false
SET @LuotXem = 0;
SET @DacBiet = 0; -- 1 là true, 0 là false
GO
---------------------------------------------delete sản phẩm--------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE sp_DeleteSanPham
    @MaSanPham int
AS
BEGIN
	
    DELETE FROM SanPhams
    WHERE MaSanPham = @MaSanPham
END
GO



-------------------------------------------------update sản phẩm----------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_update]
   (
	@MaSanPham int,
    @MaChuyenMuc int,
    @TenSanPham nvarchar(150),
    @AnhDaiDien nvarchar(350),
    @Gia decimal(18, 0),
    @GiaGiam decimal(18, 0),
    @SoLuong int,
    @TrangThai bit,
    @LuotXem int,
    @DacBiet bit
	)
AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[SanPhams] WHERE MaChuyenMuc = @MaChuyenMuc)
	BEGIN
		UPDATE [dbo].[SanPhams]
		SET 
			MaSanPham = @MaSanPham,
			MaChuyenMuc = @MaChuyenMuc,
		    TenSanPham = @TenSanPham,
			AnhDaiDien = @AnhDaiDien,
			Gia = @Gia,
			GiaGiam = @GiaGiam,
			SoLuong = @SoLuong,
			TrangThai = @TrangThai,
			LuotXem = @LuotXem,
			DacBiet = @DacBiet
		WHERE MaChuyenMuc = @MaChuyenMuc
	END;
END;
select * from SanPhams

------------------------------------------------all sản phẩm-------------------------------
CREATE PROCEDURE sp_all
as 
	begin 
		select * from SanPhams
		end;
go
----------------------------------------------------Nhan vien----------------------------------
alter PROCEDURE nhanvienID
    @MaNhanVien char(10)
AS
BEGIN
    SELECT *
    FROM tbl_NhanVien
    WHERE MaNhanVien = @MaNhanVien;
END


select * from tbl_NhanVien
-- tạo nhân viên
alter PROCEDURE nhanvienCreate
    @MaNhanVien char(10),
    @TenNhanVien nvarchar(50),
    @GioiTinh nvarchar(10),
    @DiaChi nvarchar(100),
    @SoDienThoai varchar(15),
    @Email char(30),
    @NgaySinh date
AS
BEGIN
    INSERT INTO tbl_NhanVien (MaNhanVien, TenNhanVien,GioiTinh, DiaChi, SoDienThoai, Email, NgaySinh)
    VALUES (@MaNhanVien, @TenNhanVien, @GioiTinh, @DiaChi, @SoDienThoai, @Email, @NgaySinh);
END

SELECT * FROM LoaiTaiKhoans