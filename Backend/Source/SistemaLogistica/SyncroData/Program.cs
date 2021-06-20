using com.Sistema.Logistica;
using SistemaLogistica.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SyncroData
{
	class Program
	{
		static void Main(string[] args)
		{
			CustomLogging.Initialize();
			DataAccess dal = new DataAccess();
			bool res = dal.SyncroTransportistas();
			res = dal.SyncroClientes();
			res = dal.SyncroRelTransportistaClientes();
		}
	}
}
