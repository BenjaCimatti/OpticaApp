using WebLogistica.Web.Domain;
using WebLogistica.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebLogistica.Web.Controllers
{
    public class NavbarController : Controller
    {
        // GET: Navbar
        public ActionResult Navbar(string controller, string action)
        {
					var navData = new NavbarData();

					int? idRol = null;


					if (Session["UsuarioSessionData"] != null)
					{
						UsuarioSessionData Usd = (UsuarioSessionData)Session["UsuarioSessionData"];
						idRol = Usd.IdRol;
					}

					var nav = navData.itemsPerUser(controller, action, idRol);

					return PartialView("_navbar", nav);
			}
    }
}