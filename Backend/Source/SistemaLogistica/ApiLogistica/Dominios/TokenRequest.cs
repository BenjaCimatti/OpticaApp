using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SistemaLogistica.Dominios
{
	public class TokenRequest
	{
		public string NombreUsuario { get; set; }
		public string Clave { get; set; }
		public int IdOrganizacion { get; set; }
	}
}