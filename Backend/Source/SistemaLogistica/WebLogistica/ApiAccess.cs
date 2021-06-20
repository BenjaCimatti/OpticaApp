using Newtonsoft.Json;
using RestSharp;
using SistemaLogistica.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Web;
using WebLogistica.Web.Models;

namespace WebLogistica.Data
{
	public class ApiAccess
	{
		public class Token
		{
			public string Usuario { get; set; }
			public int? IdTransportista { get; set; }
			public int? IdCliente { get; set; }
			public int? IdRol { get; set; }
			public DateTime? UltimoLogin { get; set; }
			public int? IdOrganizacion { get; set; }
			public string Data { get; set; }
		}

		public class Envio
		{
			public int IdEnvio { get; set; }
			public int IdCliente { get; set; }
			public string DescCLiente { get; set; }
			public int IdTransportista { get; set; }
			public string DescTransportista { get; set; }
			public DateTime? FechaCarga { get; set; }
			public DateTime? FechaEnvio { get; set; }
			public int IdEstado { get; set; }
			public string DescEstado { get; set; }
			public double? GeoLatitud { get; set; }
			public double? GeoLongitud { get; set; }
		}

		public IList<Envio> GetEnvios(string Token, int Estado)
		{
			Token = SyncroToken(Token);

			var client = new RestClient(ConfigurationManager.AppSettings["ApiBase"]);

			var request = new RestRequest("/api/Envios/Get", Method.GET);
			request.AddHeader("Authorization", "Bearer " + Token);
			request.AddParameter("Estado", Estado);

			try
			{
				var response = client.Get(request);
				{
					if (response.StatusCode == HttpStatusCode.OK)
					{
						List<Envio> Envios = JsonConvert.DeserializeObject<List<Envio>>(response.Content.ToString());
						return Envios;
					}
					else
					{
						return null;
					}
				}
			}
			catch (Exception ex)
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + ex.StackTrace);
				return null;
			}
		}

		public string Renew(string Token)
		{
			var client = new RestClient(ConfigurationManager.AppSettings["ApiBase"]);

			var request = new RestRequest("/api/Token/Renew", Method.GET);
			request.AddHeader("Authorization", "Bearer " + Token);

			try
			{
				var response = client.Post(request);
				{
					if (response.StatusCode == HttpStatusCode.OK)
					{
						Token _Token = JsonConvert.DeserializeObject<Token>(response.Content.ToString());
						return _Token.Data;
							;
					}
					else
					{
						return null;
					}
				}
			}
			catch (Exception ex)
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + ex.StackTrace);
				return null;
			}
		}

		public Token LogIn(string UserName, string Password)
		{
			var client = new RestClient(ConfigurationManager.AppSettings["ApiBase"]);

			var request = new RestRequest("/api/Token/Get", Method.POST);

			// Json to post.
			string jsonToSend = JsonConvert.SerializeObject(new { NombreUsuario = UserName, Clave  = Password, IdOrganizacion = ConfigurationManager.AppSettings["IdOrganizacion"] });

			request.AddParameter("application/json; charset=utf-8", jsonToSend, ParameterType.RequestBody);
			request.RequestFormat = DataFormat.Json;

			try
			{
				var response = client.Post(request);
				{
					if (response.StatusCode == HttpStatusCode.OK)
					{
						Token _Token = JsonConvert.DeserializeObject<Token>(response.Content.ToString());
						return _Token;
					}
					else
					{
						return null;
					}
				}
			}
			catch (Exception ex)
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + ex.StackTrace);
				return null;
			}
		}

		private string SyncroToken(string Token)
		{
			if (!VerifyToken(Token))
			{
				string NewToken = Renew(Token);
				Token = NewToken;
				UsuarioSessionData Usd = (UsuarioSessionData)System.Web.HttpContext.Current.Session["UsuarioSessionData"];
				Usd.Token = NewToken;
				System.Web.HttpContext.Current.Session["UsuarioSessionData"] = Usd;
				return NewToken;
			}
			else
			{
				return Token;
			}
		}

		private bool VerifyToken(string Token)
		{
			var client = new RestClient(ConfigurationManager.AppSettings["ApiBase"]);

			var request = new RestRequest("/api/Token/Verify", Method.GET);
			request.AddHeader("Authorization", "Bearer " + Token);

			try
			{
				var response = client.Get(request);
				{
					if (response.StatusCode == HttpStatusCode.OK)
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}
			catch (Exception ex)
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, MethodBase.GetCurrentMethod().Name + " - " + ex.StackTrace);
				return false;
			}
		}
	}
}