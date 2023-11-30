using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataModel
{
    public class SanPhamModel
    {
        //    public int MaSP { get; set; }

        //    public int IDLoaiSP { get; set; }

        //    public string TenSP { get; set; }

        //    public decimal GiaSP { get; set; }

        //    public string TinhTrang { get; set; }

        //    public string AnhSP { get; set; }

        //    public List<ChitietSanPhamModel> list_json_chitietsanpham { get; set; }
        //}

        //public class ChitietSanPhamModel
        //{
        //    public int IDCTSP { get; set; }

        //    public int MaSP { get; set; }

        //    public int SoLuong { get; set; }

        //    public string AnhCTSP { get; set; }

        //    public string MoTa { get; set; }

        //    public int status { get; set; }
        public int MaSanPham { get; set; }
        public int? MaChuyenMuc { get; set; }
        public string? TenSanPham { get; set; }
        public string AnhDaiDien { get; set; }
        public decimal? Gia { get; set; }
        public decimal? GiaGiam { get; set; }
        public int? SoLuong { get; set; }
        public bool? TrangThai { get; set; }
        public int? LuotXem { get; set; }
        public bool DacBiet { get; set; }

    }
}
