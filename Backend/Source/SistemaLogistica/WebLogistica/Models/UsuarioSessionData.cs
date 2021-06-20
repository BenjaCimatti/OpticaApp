using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebLogistica.Web.Models
{
	public class UsuarioSessionData
	{
		public UsuarioSessionData()
			{ LoginSuccess = false;	}
		public string Usuario { get; set; }
		public int? IdTransportista { get; set; }
		public int? IdCliente { get; set; }
		public int? IdRol { get; set; }
		public DateTime? UltimoLogin { get; set; }
		public int? IdOrganizacion { get; set; }
		public string Token { get; set; }
		public bool LoginSuccess { get; set; }
		public string FailMessage { get; set; }
	}
}