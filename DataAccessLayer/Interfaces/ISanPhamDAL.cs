using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataModel;

namespace DataAccessLayer
{
    public partial interface ISanPhamDAL
    {
        SanPhamModel GetDatabyID(int id);
        bool Create(SanPhamModel model);

        bool Update(SanPhamModel model);

        SanPhamModel DeleteItem(int id);

        public List<SanPhamModel> ALLSP();

        //public List<SanPhamModel> Search(int pageIndex, int pageSize, out long total, string tensp, int idsp, out string list_json_chitietsanpham);
    }
}
