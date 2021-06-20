using log4net;
using System;
using System.IO;
using System.Reflection;

namespace SistemaLogistica.Common
{
	public static class CustomLogging
	{
		private static ILog _log = null;
		private static string _logFile = null;
		public enum TracingLevel
		{
			ALL, DEBUG, INFO, WARN, ERROR, FATAL, OFF
		}

		public static void Initialize()
		{
			_logFile = Path.Combine(System.Configuration.ConfigurationManager.AppSettings["Log4NetPath"], System.Configuration.ConfigurationManager.AppSettings["Log4NetFileName"]);
			GlobalContext.Properties["LogFileName"] = _logFile;

			log4net.Config.XmlConfigurator.Configure(new FileInfo(System.Configuration.ConfigurationManager.AppSettings["Log4NetConfigFile"]));

			_log = LogManager.GetLogger("ApiLogistica");
		}

		public static string LogFile
		{
			get { return _logFile; }
		}

		public static void LogError(MethodBase method, Exception ex, params object[] values)
		{
			ParameterInfo[] parms = method.GetParameters();
			object[] namevalues = new object[2 * parms.Length];

			string msg = "Error en " + method.Name + "(";
			for (int i = 0, j = 0; i < parms.Length; i++, j += 2)
			{
				msg += "{" + j + "}={" + (j + 1) + "}, ";
				namevalues[j] = parms[i].Name;
				if (i < values.Length) namevalues[j + 1] = values[i];
			}
			msg += "exception=" + ex.Message + ")";
			LogMessage(TracingLevel.ERROR, string.Format(msg, namevalues));
		}

		public static void LogMessage(TracingLevel Level, string Message)
		{
			switch (Level)
			{
				case TracingLevel.DEBUG:
					_log.Debug(Message);
					break;

				case TracingLevel.INFO:
					_log.Info(Message);
					break;

				case TracingLevel.WARN:
					_log.Warn(Message);
					break;

				case TracingLevel.ERROR:
					_log.Error(Message);
					break;

				case TracingLevel.FATAL:
					_log.Fatal(Message);
					break;
			}
		}
	}
}