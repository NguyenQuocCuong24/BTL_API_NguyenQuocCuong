using BusinessLogicLayer.Interfaces;
using Microsoft.AspNetCore.Mvc;
using DataModel;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Reflection;
using BusinessLogicLayer;

namespace WEBBANKINH.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class SanPhamController : ControllerBase
    {
        private ISanPhamBUS _sanphamnBusiness;
        public SanPhamController(ISanPhamBUS sanphamBusiness)
        {
            _sanphamnBusiness = sanphamBusiness;
        }

        [Route("get-by-id/{id}")]
        [HttpGet]
        public SanPhamModel GetDataByID(int id)
        {
            return _sanphamnBusiness.GetDatabyID(id);
        }

        [Route("create-sanpham")]
        [HttpPost]
        public SanPhamModel CreateItem([FromBody] SanPhamModel model)
        {

            _sanphamnBusiness.Create(model);
            return model;
        }


        [Route("update-sanpham")]
        [HttpPut]
        public bool Update(SanPhamModel model)
        {
            _sanphamnBusiness.Update(model);
            return Update(model);
        }

        [Route("delete-sanpham/{id}")]
        [HttpDelete]
        public SanPhamModel DeleteItem(int id)
        {
            return _sanphamnBusiness.DeleteItem(id);
        }
        [Route("get_ALL")]
        [HttpGet]
        public List<SanPhamModel> get_ALL ()
        {
            return _sanphamnBusiness.ALLSP();
        }

        //[Route("search")]
        //[HttpPost]
        //public IActionResult Search([FromBody] Dictionary<string, object> formData)
        //{
        //    try
        //    {
        //        var page = int.Parse(formData["page"].ToString());
        //        var pageSize = int.Parse(formData["pageSize"].ToString());
        //        string tensp = "";
        //        if (formData.Keys.Contains("tensp") && !string.IsNullOrEmpty(Convert.ToString(formData["tensp"]))) { tensp = Convert.ToString(formData["tensp"]); }
        //        long total = 0;
        //        string list_json_chitietsanpham = "";
        //        int idsp = 0;
        //        if (formData.Keys.Contains("idsp") && !string.IsNullOrEmpty(Convert.ToString(formData["idsp"]))) { idsp = int.Parse(Convert.ToString(formData["idsp"])); }
        //        var data = _sanphamnBusiness.Search(page, pageSize, out total, tensp, idsp, out list_json_chitietsanpham);
        //        return Ok(
        //            new
        //            {
        //                TotalItems = total,
        //                Data = data,
        //                Page = page,
        //                PageSize = pageSize
        //            }
        //            );
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new Exception(ex.Message);
        //    }
        //}
    }
}
