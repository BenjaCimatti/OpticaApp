using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using com.Sistema.Logistica;
using System.Collections.Generic;
using static com.Sistema.Logistica.DataAccess;

namespace TestDataAccess
{
	[TestClass]
	public class DataAccessTest
	{
		[TestMethod]
		public void VerificarConeccion()
		{
			DataAccess dal = new DataAccess();
			bool res = dal.VerificarConeccion();
			Assert.AreEqual(res, true);
		}

		[TestMethod]
		public void ObtenerEnviosAdmin()
		{
			DataAccess dal = new DataAccess();
			List<Envio> res = dal.ObtenerEnvios(null, null, 1, 1, 1);
			Assert.AreNotEqual(res.Count, 0);
		}

		[TestMethod]
		public void ObtenerEnviosTransportista()
		{
			DataAccess dal = new DataAccess();
			List<Envio> res = dal.ObtenerEnvios(2, null, 2, 1, 1);
			Assert.AreNotEqual(res.Count, 0);
		}

		[TestMethod]
		public void ObtenerEnviosClientes()
		{
			DataAccess dal = new DataAccess();
			List<Envio> res = dal.ObtenerEnvios(null, 571, 3, 1, 1);
			Assert.AreNotEqual(res.Count, 0);
		}

		[TestMethod]
		public void ObtenerClientes()
		{
			DataAccess dal = new DataAccess();
			List<Cliente> res = dal.ObtenerClientes();
			Assert.AreNotEqual(res.Count, 0);
		}

		[TestMethod]
		public void ObtenerTransportistas()
		{
			DataAccess dal = new DataAccess();
			List<Transportista> res = dal.ObtenerTransportistas();
			Assert.AreNotEqual(res.Count, 0);
		}

		[TestMethod]
		public void VerificarVersionComponente()
		{
			DataAccess dal = new DataAccess();
			string res = dal.VerificarVersionComponente("ApiLogistica");
			Assert.AreEqual(res, "1.0.0");
		}

		[TestMethod]
		public void SyncroTransportistase()
		{
			DataAccess dal = new DataAccess();
			bool res = dal.SyncroTransportistas();
			Assert.AreEqual(res, true);
		}

		[TestMethod]
		public void SyncroClientes()
		{
			DataAccess dal = new DataAccess();
			bool res = dal.SyncroClientes();
			Assert.AreEqual(res, true);
		}

		[TestMethod]
		public void SyncroRelTransportistaClientes()
		{
			DataAccess dal = new DataAccess();
			bool res = dal.SyncroRelTransportistaClientes();
			Assert.AreEqual(res, true);
		}
	}
}
