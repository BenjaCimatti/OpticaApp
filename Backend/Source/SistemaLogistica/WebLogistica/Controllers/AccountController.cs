using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using WebLogistica.Web.Domain;
using WebLogistica.Web.Models;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using WebLogistica.Data;

namespace SistemaLogistica.Web.Controllers
{
    public class AccountController : Controller
    {        
        // GET: Account
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
						ViewBag.ReturnUrl = returnUrl;
            return View(new LoginViewModel());
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginViewModel model, string returnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }
            var data = new NavbarData();

            UsuarioSessionData _UsuarioSessionData = LogIn(model, model.UserName, Utiles.ComputeSha256Hash(model.Password));

            if (_UsuarioSessionData.LoginSuccess)
            {
							if (ConfigurationManager.AppSettings["RolesPermitidos"].ToString().Contains(_UsuarioSessionData.IdRol.ToString()))
							{
								FormsAuthentication.SetAuthCookie(_UsuarioSessionData.Usuario, false);

								Session["UsuarioSessionData"] = _UsuarioSessionData;
								return RedirectToAction("Index", "Home");
							}
							else
							{
								ModelState.AddModelError("", "Rol de acceso no permitido");
								return View(model);
							}
            }
            else
            {
                ModelState.AddModelError("", _UsuarioSessionData.FailMessage);
                return View(model);
            }
        }

        private UsuarioSessionData LogIn(LoginViewModel model, string UserName, string Password)
        {
						UsuarioSessionData Usd = new UsuarioSessionData();

						ApiAccess Api = new ApiAccess();

						ApiAccess.Token _Token = Api.LogIn(UserName, Password);

						if (_Token != null)
						{
							Usd.LoginSuccess = true;
							Usd.IdCliente = _Token.IdCliente;
							Usd.IdOrganizacion = _Token.IdOrganizacion;
							Usd.IdRol = _Token.IdRol;
							Usd.IdTransportista = _Token.IdTransportista;
							Usd.Token = _Token.Data;
							Usd.UltimoLogin = _Token.UltimoLogin;
							Usd.Usuario = _Token.Usuario;
						}
						else
						{
							Usd.FailMessage = "Error de Acceso";
						}

            return Usd;
        }

        // POST: /Account/LogOff
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
						Session.Clear();  // This may not be needed -- but can't hurt
						Session.Abandon();
						FormsAuthentication.SignOut();
            return RedirectToAction("Login", "Account");
        }
    
    }
}