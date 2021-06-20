using com.Sistema.Logistica;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Security.Claims;
using static com.Sistema.Logistica.DataAccess;
using SistemaLogistica.Common;
using System.Reflection;
using System.Configuration;

namespace SistemaLogistica.Controllers
{
    public class EnviosController : ApiController
    {
		[HttpGet]
		[Authorize]
		[ActionName("Get")]
		[LogAction]
		public Object Get(int? Estado = null)
		{
				var identity = User.Identity as ClaimsIdentity;
				List<Envio> res;

				if (identity != null)
				{
					int? IdTransportista = null;
				  int? IdCliente = null;
					int? IdRol = null;
					int _Estado;
					string Usuario;

					IEnumerable<Claim> claims = identity.Claims;
					Usuario = claims.Where(p => p.Type == "Usuario").FirstOrDefault()?.Value;
					IdRol = int.Parse(claims.Where(p => p.Type == "IdRol").FirstOrDefault()?.Value);
					
					if (claims.Where(p => p.Type == "IdTransportista").Count() > 0)
					{
						IdTransportista = int.Parse(claims.Where(p => p.Type == "IdTransportista").FirstOrDefault()?.Value);
					}

				  if (claims.Where(p => p.Type == "IdCliente").Count() > 0)
					{
						IdCliente = int.Parse(claims.Where(p => p.Type == "IdCliente").FirstOrDefault()?.Value);
					}

					int IdOrganizacion = int.Parse(claims.Where(p => p.Type == "IdOrganizacion").FirstOrDefault()?.Value);

					if(Estado == null)
					{ _Estado = int.Parse(ConfigurationManager.AppSettings["IdEstadoIngresado"]); }
					else
					{ _Estado = (int)Estado; }

					DataAccess dal = new DataAccess();
					try
					{
						res = dal.ObtenerEnvios(IdTransportista, IdCliente, IdRol, IdOrganizacion, _Estado);
					}
					catch(Exception ex)
					{
						CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + ex.StackTrace);
						throw new HttpResponseException(HttpStatusCode.InternalServerError);
					}

					if (res.Count > 0)
					{
						return res;
					}
					else
					{
					CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + HttpStatusCode.NoContent.ToString());
					throw new HttpResponseException(HttpStatusCode.NoContent);
					}
				}
				else
				{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + HttpStatusCode.Unauthorized.ToString());
				throw new HttpResponseException(HttpStatusCode.Unauthorized);
				}
		}
	}
}
