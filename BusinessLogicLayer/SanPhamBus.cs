using BusinessLogicLayer.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataModel;
using DataAccessLayer;
using DataAccessLayer.Interfaces;

namespace BusinessLogicLayer
{
    public class SanPhamBUS : ISanPhamBUS
    {
        private ISanPhamDAL _res;

        public SanPhamBUS(ISanPhamDAL res)
        {
            _res = res;
        }

        public SanPhamModel GetDatabyID(int id)
        {
            return _res.GetDatabyID(id);
        }

        public bool Create(SanPhamModel model)
        {
            return _res.Create(model);
        }

        public bool Update(SanPhamModel model)
        {
            return _res.Update(model);
        }

        public SanPhamModel DeleteItem(int id)
        {
            return _res.DeleteItem(id);
        }
        public List<SanPhamModel> ALLSP()
        {
            return _res.ALLSP();
        }

        //public List<SanPhamModel> Search(int pageIndex, int pageSize, out long total, string tensp, int idsp, out string list_json_chitietsanpham)
        //{
        //    return _res.Search(pageIndex, pageSize, out total, tensp, idsp, out list_json_chitietsanpham);
        //}
    }
}
