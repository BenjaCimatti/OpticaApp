using SistemaLogistica.Common;
using com.Sistema.Logistica;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Web.Http;

namespace SistemaLogistica.Controllers
{
    public class VersionController : ApiController
    {
			[HttpGet]
			[ActionName("Get")]
			[LogAction]
			public Object Get(string Componente)
			{
				try
				{
					DataAccess dal = new DataAccess();
					string ver = dal.VerificarVersionComponente(Componente);
					return new { Version = ver };
				}
				catch(Exception ex)
				{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + ex.StackTrace);
				throw new HttpResponseException(HttpStatusCode.InternalServerError);
				}
			}
		}
}
