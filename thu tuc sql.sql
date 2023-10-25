USE bankinhapi
GO


--get Khachhang--
alter proc sp_khach_get_by_id
	@Id int
as
begin
	select * from [dbo].[Khachhangs] where Id = @Id
end;

select * from Khachhangs

--DROP PROCEDURE sp_khach_get_by_id--
 
 SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_khach_get_by_id](@id int)
AS
    BEGIN
      SELECT  *
      FROM KhachHangs
      where id= @id;
    END;

	EXEC [dbo].[sp_khach_get_by_id] @id = 2

-----------------------------------
	SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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


-----xóa khach hàng--
	SET ANSI_NULLS ON
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


-----update khách hàng 
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


---get hoa don---
			create proc sp_hoadon_get_by_id
				@MaHoaDon int
			as
			begin
				select * from [dbo].[HoaDons] where MaHoaDon = @MaHoaDon
			end;
select * from HoaDons
exec sp_hoadon_get_by_id '1'

-- thu tuc xoa hoadon
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

--thêm hóa đơn--
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE sp_hoadon_create
(@TenKH              NVARCHAR(50), 
 @GioiTinh        bit,
 @Diachi          NVARCHAR(250), 
 @TrangThai         bit,	
 @list_json_chitiethoadon NVARCHAR(MAX)
)
AS
    BEGIN
		DECLARE @MaHoaDon INT;
        INSERT INTO HoaDons
                (TenKH,
				 GioiTinh,
                 Diachi, 
                 TrangThai               
                )
                VALUES
                (@TenKH, 
				 @GioiTinh,
                 @Diachi, 
                 @TrangThai
                );

				SET @MaHoaDon = (SELECT SCOPE_IDENTITY());
                IF(@list_json_chitiethoadon IS NOT NULL)
                    BEGIN
                        INSERT INTO ChiTietHoaDons
						 (MaSanPham, 
						  MaHoaDon,
                          SoLuong, 
                          TongGia               
                        )
                    SELECT JSON_VALUE(p.value, '$.maSanPham'), 
                            @MaHoaDon, 
                            JSON_VALUE(p.value, '$.soLuong'), 
                            JSON_VALUE(p.value, '$.tongGia')    
                    FROM OPENJSON(@list_json_chitiethoadon) AS p;
                END;
        SELECT '';
    END;

---update hóa đơn 
	
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE sp_hoa_don_update
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

--- used
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE sp_login (@taikhoan nvarchar(50), @matkhau nvarchar(50))
AS
    BEGIN
      SELECT  *
      FROM TaiKhoans
      where TenTaiKhoan= @taikhoan and MatKhau = @matkhau;
    END;

	--tim kiem--
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