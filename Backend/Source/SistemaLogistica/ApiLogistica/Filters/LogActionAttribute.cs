using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace SistemaLogistica.Common
{
	public class LogActionAttribute : ActionFilterAttribute

	{
		protected static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		public override void OnActionExecuting(HttpActionContext actionContext)
		{
			Log("OnActionExecuting", actionContext);
		}

		public override void OnActionExecuted(HttpActionExecutedContext actionContext)
		{
			Log("OnActionExecuted", actionContext);
		}

		private void Log(string methodName, HttpActionContext actionContext)
		{
			var actionName = actionContext.ActionDescriptor.ActionName;
			var controllerName = actionContext.ActionDescriptor.ControllerDescriptor.ControllerName;
			string message = string.Empty;
			message = string.Format("Start method {0}.{1}", controllerName, actionName) + Environment.NewLine;
			string parameters = string.Empty;
			message = message + "Parameters : ";
			foreach (var parameter in actionContext.ActionArguments)
			{
				message = message + Environment.NewLine + "Param Name : " + parameter.Key + Environment.NewLine + "Value : " + parameter.Value;
			}
			logger.Info(message);
		}
		private void Log(string methodName, HttpActionExecutedContext actionContext)
		{
			var actionName = actionContext.ActionContext.ActionDescriptor.ActionName;
			var controllerName = actionContext.ActionContext.ActionDescriptor.ControllerDescriptor.ControllerName;
			string message = string.Empty;
			message = string.Format("End method {0}.{1}", controllerName, actionName) + Environment.NewLine;
			message = message + "response Status Code : " + actionContext.ActionContext.Response.StatusCode.ToString() + Environment.NewLine;
			message = message + Environment.NewLine;
			logger.Info(message);
		}
	}
}