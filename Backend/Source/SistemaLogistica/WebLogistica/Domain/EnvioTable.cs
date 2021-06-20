using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebLogistica.Domain
{
	public class EnvioTable
	{
		public int IdEnvio { get; set; }
		public int DescEnvio { get; set; }
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
}