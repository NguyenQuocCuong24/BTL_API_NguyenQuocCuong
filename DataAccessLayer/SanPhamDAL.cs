using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataModel;

namespace DataAccessLayer
{
    public class SanPhamDAL : ISanPhamDAL
    {
        private IDatabaseHelper _dbHelper;

        public SanPhamDAL(IDatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        public SanPhamModel GetDatabyID(int id)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_GetSanPhamByID",
                     "@MaSanPham", id);
                if (!string.IsNullOrEmpty(msgError))
                    throw new Exception(msgError);
                return dt.ConvertTo<SanPhamModel>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool Create(SanPhamModel model)
        {
            try
            {
                string msgError = "";
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_InsertSanPham",
                    "@MaChuyenMuc", model.MaChuyenMuc,
                    "@TenSanPham", model.TenSanPham,
                    "@AnhDaiDien", model.AnhDaiDien,
                    "@Gia", model.Gia,
                    "@GiaGiam", model.GiaGiam,
                    "@SoLuong", model.SoLuong,
                    "@TrangThai", model.TrangThai,
                    "@LuotXem", model.LuotXem,
                    "@DacBiet", model.DacBiet);  // Chuyển giá trị bool thành 1 (true) hoặc 0 (false)

                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }

                // Kiểm tra giá trị trả về từ stored procedure (nếu cần)
                if (result != null)
                {
                    int newProductID;
                    if (int.TryParse(result.ToString(), out newProductID))
                    {
                        // Làm bất cứ xử lý gì bạn cần với newProductID
                        return true;
                    }
                    else
                    {
                        throw new Exception("Giá trị trả về không phải là một số nguyên.");
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool Update(SanPhamModel model)
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_update",
                "@MaChuyenMuc", model.MaChuyenMuc,
                "TenSanPham", model.TenSanPham,
                "@AnhDaiDien", model.AnhDaiDien,
                "@Gia", model.Gia,
                "@GiaGiam", model.GiaGiam,
                "@SoLuong", model.SoLuong,
                "@TrangThai", model.TrangThai,
                "@LuotXem", model.LuotXem,
                "@DacBiet", model.DacBiet);  
                if ((result != null && !string.IsNullOrEmpty(result.ToString())) || !string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(Convert.ToString(result) + msgError);
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public SanPhamModel DeleteItem(int id)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_DeleteSanPham",
                     "@MaSanPham", id);
                if (!string.IsNullOrEmpty(msgError))
                    throw new Exception(msgError);
                return dt.ConvertTo<SanPhamModel>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<SanPhamModel> ALLSP()
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_all"

                );
                if ((result != null && !string.IsNullOrEmpty(result.ToString())) || !string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(Convert.ToString(result) + msgError);
                }
                return result.ConvertTo<SanPhamModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}
