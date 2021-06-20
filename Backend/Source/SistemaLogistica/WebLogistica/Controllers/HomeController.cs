using WebLogistica.Web.Filters;
using WebLogistica.Web.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebLogistica.Data;
using static WebLogistica.Data.ApiAccess;
using WebLogistica.Domain;

namespace WebLogistica.Web.Controllers
{
    [AuthActionFilter]
    public class HomeController : Controller
    {
    
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult AjaxHandler(jQueryDataTableParamModel param)
        {

						var allEnvios = GetEnvios();

						IEnumerable<EnvioTable> filteredEnvios;
            //Check whether the companies should be filtered by keyword
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                //Used if particulare columns are filtered 
                var envioFilter = Convert.ToString(Request["sSearch_1"]);
                var clienteFilter = Convert.ToString(Request["sSearch_2"]);
                var transportistaFilter = Convert.ToString(Request["sSearch_3"]);
                var estadoFilter = Convert.ToString(Request["sSearch_4"]);

                //Optionally check whether the columns are searchable at all 
                var isEnvioSearchable = Convert.ToBoolean(Request["bSearchable_1"]);
                var isClienteSearchable = Convert.ToBoolean(Request["bSearchable_2"]);
                var isTransportistaSearchable = Convert.ToBoolean(Request["bSearchable_3"]);
                var isEstadoSearchable = Convert.ToBoolean(Request["bSearchable_4"]);

                filteredEnvios = GetEnvios()
                   .Where(c => isEnvioSearchable && c.DescEnvio.ToString().ToLower().Contains(param.sSearch.ToLower())
                               ||
                               isClienteSearchable && c.DescCLiente.ToLower().Contains(param.sSearch.ToLower())
                               ||
                               isTransportistaSearchable && c.DescTransportista.ToLower().Contains(param.sSearch.ToLower())
                               ||
                               isEstadoSearchable && c.DescEstado.ToLower().Contains(param.sSearch.ToLower()));
                }
                else
                {
                    filteredEnvios = allEnvios;
                }

                var isEnvioSortable = Convert.ToBoolean(Request["bSortable_1"]);
                var isClienteSortable = Convert.ToBoolean(Request["bSortable_2"]);
                var isTransportistaSortable = Convert.ToBoolean(Request["bSortable_3"]);
                var isEstadoSortable = Convert.ToBoolean(Request["bSortable_4"]);
								var isFecCargaSortable = Convert.ToBoolean(Request["bSortable_5"]);
								var isFecEnvioSortable = Convert.ToBoolean(Request["bSortable_6"]);
								var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                Func<EnvioTable, string> orderingFunction = (c => sortColumnIndex == 1 && isEnvioSortable ? IdxOrderIntString(c.DescEnvio.ToString()) : 
																															 sortColumnIndex == 2 && isClienteSortable ? c.DescCLiente :
                                                               sortColumnIndex == 3 && isTransportistaSortable ? c.DescTransportista :
                                                               sortColumnIndex == 4 && isEstadoSortable ? c.DescEstado :
																															 sortColumnIndex == 5 && isFecCargaSortable ? String.Format("{0:yyyyMMdd}", c.FechaCarga) :
																															 sortColumnIndex == 6 && isFecEnvioSortable ? String.Format("{0:yyyyMMdd}", c.FechaEnvio) :
																															 "");

                var sortDirection = Request["sSortDir_0"]; // asc or desc
                if (sortDirection == "asc")
                    filteredEnvios = filteredEnvios.OrderBy(orderingFunction);
                else
										filteredEnvios = filteredEnvios.OrderByDescending(orderingFunction);

                var displayedEnvios = filteredEnvios.Skip(param.iDisplayStart).Take(param.iDisplayLength);
                var result = from c in displayedEnvios select new[] { c.IdEnvio.ToString(), c.DescEnvio.ToString(), c.DescCLiente, c.DescTransportista, c.DescEstado, String.Format(ConfigurationManager.AppSettings["DisplayFormatDate"].ToString(), c.FechaCarga), String.Format(ConfigurationManager.AppSettings["DisplayFormatDate"].ToString(), c.FechaEnvio) };
                return Json(new
                {
                    sEcho = param.sEcho,
                    iTotalRecords = allEnvios.Count(),
                    iTotalDisplayRecords = filteredEnvios.Count(),
                    aaData = result
                },
                JsonRequestBehavior.AllowGet);
            }

        public IList<EnvioTable> GetEnvios()
        {
            List<EnvioTable> _Envios = new List<EnvioTable>();;

            if (Session["EnviosListData"] != null)
            {
                _Envios = (List<EnvioTable>)Session["EnviosListData"];
            }
            else
            {
                DataTable Customers = new DataTable();


                if (Session["UsuarioSessionData"] != null)
                {
									ApiAccess Api = new ApiAccess();

									UsuarioSessionData Usd = (UsuarioSessionData)Session["UsuarioSessionData"];
									var AllEnvios = Api.GetEnvios(Usd.Token,1);

									_Envios = AllEnvios.AsEnumerable().Select(m => new EnvioTable()
									{
										IdEnvio = m.IdEnvio,
										DescEnvio = m.IdEnvio,
										IdCliente = m.IdCliente,
										DescCLiente = m.DescCLiente,
										IdTransportista = m.IdTransportista,
										DescTransportista = m.DescTransportista,
										IdEstado = m.IdEstado,
										DescEstado = m.DescEstado,
										FechaCarga = m.FechaCarga,
										FechaEnvio = m.FechaEnvio,
									}).ToList();

									Session["EnviosListData"] = _Envios;

				}
            }

            return _Envios;
        }

				private string IdxOrderIntString(string Id)
				{
					char[] ChrArray = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k' };
					string Out = "";
					foreach(char c in Id)
					{
						Out = Out + ChrArray[int.Parse(c.ToString())];
					}
					return Out.PadLeft(10,'a');
				}
    }
}