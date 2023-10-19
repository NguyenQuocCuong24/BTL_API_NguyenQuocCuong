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