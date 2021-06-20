using SistemaLogistica.Common;
using SistemaLogistica.Dominios;
using com.Sistema.Logistica;
using com.Sistema.Logistica.Seguridad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Web.Http;
using static com.Sistema.Logistica.DataAccess;

namespace SistemaLogistica.Controllers
{
    public class TokenController : ApiController
    {
		[HttpPost]
		[ActionName("Get")]
		[LogAction]
		public Object Get([FromBody] TokenRequest request)
			{
				DataAccess dal = new DataAccess();
				Usuario res;

				try
				{
					res = dal.VerificarUsuarioEncrptado(request.NombreUsuario, request.Clave, request.IdOrganizacion);
				}
				catch(Exception ex)
				{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + ex.StackTrace);
				throw new HttpResponseException(HttpStatusCode.InternalServerError);
				}

				if (res!=null)
					{
						JWTManager seg = new JWTManager();
						object jwt = seg.GetToken(res._Usuario, res.IdTransportista, res.IdCliente, res.IdRol, res.UltimoLogin, res.IdOrganizacion, res.DescUsuario);
						return jwt;
					}
					else
					{
						CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + HttpStatusCode.Unauthorized.ToString());
						throw new HttpResponseException(HttpStatusCode.Unauthorized);
					}
			}

		[HttpGet]
		[ActionName("Renew")]
		[LogAction]
		public Object Renew()
		{
			char[] whitespace = new char[] { ' ', '\t' };
			if (Request.Headers.Contains("Authorization"))
			{
				string bearerToken = Request.Headers.GetValues("Authorization").FirstOrDefault();

				string[] TokenArray = bearerToken.Split(whitespace);

				JWTManager seg = new JWTManager();
				object jwt = seg.RefreshToken(TokenArray[1]);
				if (jwt != null)
				{
					return jwt;
				}
				else
				{
					throw new HttpResponseException(HttpStatusCode.BadRequest);
				}
			}
			else
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + HttpStatusCode.BadRequest.ToString());
				throw new HttpResponseException(HttpStatusCode.BadRequest);
			}
		}

		[HttpGet]
		[Authorize]
		[ActionName("Verify")]
		[LogAction]
		public object Verify()
		{
			return Json(new { status = "OK" });
		}
	}
}
