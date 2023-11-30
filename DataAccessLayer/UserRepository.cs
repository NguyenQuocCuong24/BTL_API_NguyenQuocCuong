using DataAccessLayer.Interfaces;
using DataModel;

namespace DataAccessLayer
{
    public class UserRepository :IUserRepository
    {
        private IDatabaseHelper _dbHelper;
        public UserRepository(IDatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }
        public UserModel Login(string taikhoan, string matkhau)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_login",
                     "@taikhoan", taikhoan,
                     "@matkhau", matkhau
                     );
                if (!string.IsNullOrEmpty(msgError))
                    throw new Exception(msgError);
                return dt.ConvertTo<UserModel>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public UserModel GetDatabyID(string accountid)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_get_tk_by_id",
                    "@id", accountid);
                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }
                return dt.ConvertTo<UserModel>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public bool Create(UserModel model)
        {
            try
            {
                string msgError;
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_insert_tai_khoan",
                    "@TenTaiKhoan", model.TenTaiKhoan,
                    "@MatKhau", model.MatKhau,
                    "@Email", model.Email,
                    "@MaLoai", model.LoaiTaiKhoan);

                if (result != null && !string.IsNullOrEmpty(result.ToString()))
                {
                    throw new Exception(Convert.ToString(result) + msgError);
                }

                return true;
            }
            catch (Exception ex)
            {
                // Xử lý ngoại lệ tại đây nếu cần
                throw ex;
            }
        }

        public bool Update(UserModel model)
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_update_tk",
                    "@id", model.MaTaiKhoan,
                    "@TenTaiKhoan", model.TenTaiKhoan,              
                    "@MatKhau", model.MatKhau,
                    "@LoaiTaiKhoan", model.LoaiTaiKhoan,
                    "@Email", model.Email
                    
                );
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
        public bool Delete(UserModel model)
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_delete_tk",
                "@id", model.MaTaiKhoan);
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
        
    }
}
