using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using com.Sistema.Logistica.Seguridad;
using com.Sistema.Logistica;
using static com.Sistema.Logistica.DataAccess;

namespace TestDataAccess
{
	[TestClass]
	public class TestSeguridad
	{
		[TestMethod]
		public void VerificarAdmin()
		{
			DataAccess dal = new DataAccess();
			Usuario res = dal.VerificarUsuarioEncrptado("Admin", "3b612c75a7b5048a435fb6ec81e52ff92d6d795a8b5a9c17070f6a63c97a53b2", 1);
			Assert.IsTrue(res._Usuario.Equals("Admin"));
		}

		[TestMethod]
		public void VerificarTransportista()
		{
			DataAccess dal = new DataAccess();
			Usuario res = dal.VerificarUsuarioEncrptado("jperez", "3b612c75a7b5048a435fb6ec81e52ff92d6d795a8b5a9c17070f6a63c97a53b2", 1);
			Assert.IsTrue(res._Usuario.Equals("jperez"));
		}

		[TestMethod]
		public void VerificarCliente()
		{
			DataAccess dal = new DataAccess();
			Usuario res = dal.VerificarUsuarioEncrptado("jgomez", "3b612c75a7b5048a435fb6ec81e52ff92d6d795a8b5a9c17070f6a63c97a53b2", 1);
			Assert.IsTrue(res._Usuario.Equals("jgomez"));
		}

		[TestMethod]
		public void GetTokenAdmin()
		{
			JWTManager seg = new JWTManager();
			object res = seg.GetToken("Admin", null, null, 1, DateTime.Today, 1, "Admin");
			Assert.IsTrue(res.ToString().Contains("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"));
		}

		[TestMethod]
		public void GetTokenTransportista()
		{
			JWTManager seg = new JWTManager();
			object res = seg.GetToken("jperez", 1, null, 2, DateTime.Today, 1, "jperez");
			Assert.IsTrue(res.ToString().Contains("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"));
		}

		[TestMethod]
		public void GetTokenCliente()
		{
			JWTManager seg = new JWTManager();
			object res = seg.GetToken("jgomez", null, 491, 3, DateTime.Today, 1, "jgomez");
			Assert.IsTrue(res.ToString().Contains("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"));
		}

		[TestMethod]
		public void RefreshToken()
		{
			JWTManager seg = new JWTManager();
			object res = seg.RefreshToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiZmY2NTUyNC0wMzM5LTQ1NWMtOTliMC1lNDdiNjA4NjY5MTMiLCJVc3VhcmlvIjoiamdvbWV6IiwiSWRDbGllbnRlIjoiNDkxIiwiSWRSb2wiOiIzIiwiSWRPcmdhbml6YWNpb24iOiIxIiwiZXhwIjoxNjIyNzQyMzM2LCJpc3MiOiJodHRwOi8vaHR0cDovL29wdGljYWVsZW5hLmNvbS5hci8iLCJhdWQiOiJodHRwOi8vaHR0cDovL29wdGljYWVsZW5hLmNvbS5hci8ifQ.fgr7brUi_FHW0EosMyEOiCiDnnkZaAol9OFGcnpJB7Y");
			Assert.IsTrue(res.ToString().Contains("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"));
		}
	}
}
