using System;
using System.Data.SQLite;
using com.Sistema.Logistica.Seguridad;
using System.Collections.Generic;
using SistemaLogistica.Common;
using System.Reflection;
using System.Data.OleDb;
using System.Data;
using System.IO;
using System.Text;
using System.Configuration;

namespace com.Sistema.Logistica
{
	public class DataAccess
	{

		public DataAccess()
		{
			CustomLogging.Initialize();
		}

		private string dbConnectionStringRO = System.Configuration.ConfigurationManager.ConnectionStrings["SistemaLogisticaRO"].ConnectionString;

		private string dbConnectionStringNoRO = System.Configuration.ConfigurationManager.ConnectionStrings["SistemaLogisticaNoRO"].ConnectionString;

		private string SQLiteDateTimeFormat = System.Configuration.ConfigurationManager.AppSettings["SQLiteDateTimeFormat"];

		public class Transportista
		{
			public int IdTransportista { get; set; }
			public string DescTransportista { get; set; }
		}

		public class Cliente
		{
			public int IdCliente { get; set; }
			public string DescCliente { get; set; }
			public int IdTransportista { get; set; }
		}

		public class Usuario
		{
			public string _Usuario { get; set; }
			public int? IdTransportista { get; set; }
			public int? IdCliente { get; set; }
			public string DescUsuario { get; set; }
			public int? IdRol { get; set; }
			public DateTime? UltimoLogin { get; set; }
			public int? IdOrganizacion { get; set; }
		}

		public class Envio
		{
			public int IdEnvio { get; set; }
			public int IdCliente { get; set; }
			public string DescCliente { get; set; }
			public int IdTransportista { get; set; }
			public string DescTransportista { get; set; }
			public DateTime? FechaCarga { get; set; }
			public DateTime? FechaEnvio { get; set; }
			public int IdEstado { get; set; }
			public string DescEstado { get; set; }
			public double? GeoLatitud { get; set; }
			public double? GeoLongitud { get; set; }
		}

		public bool VerificarConeccion()
		{
			try
			{
				SQLiteConnection sqlite_con = new SQLiteConnection(dbConnectionStringRO);
				sqlite_con.Open();
				string query = "SELECT 'Hello world';";
				SQLiteCommand sqlite_cmd = new SQLiteCommand(query, sqlite_con);
				SQLiteDataReader dr = sqlite_cmd.ExecuteReader();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, sqlite_cmd.CommandText + " - " + dr.HasRows + " Registros");
				sqlite_con.Close();
				return true;
			}
			catch (Exception ex)
			{
				CustomLogging.LogError(MethodBase.GetCurrentMethod(), ex);
				return false;
			}
		}

		private string Parameters(SQLiteParameterCollection Parameters)
		{
			string StrParameters = "";
			foreach (SQLiteParameter Parameter in Parameters)
			{
				StrParameters = StrParameters + Parameter.ParameterName + ":" + Parameter.Value.ToString() + "|";
			}

			return StrParameters;
		}

		public Usuario VerificarUsuarioEncrptado(string UsuarioLogin, string ClaveEncriptadaLogin, int IdOrganizacion)
		{
			SQLiteCommand sqlite_cmd = null;
			try
			{
				string Usuario = "";
				string ClaveEncriptada = "";
				string _DescUsuario = "";
				int? IdTransportista = null;
				int? IdCliente = null;
				DateTime? UltimoLogin = null;
				int? _IdOrganizacion = null;
				int? IdRol = null;

				SQLiteConnection sqlite_con = new SQLiteConnection(dbConnectionStringRO);
				sqlite_con.Open();
				string query = "SELECT usr.usuario, usr.claveEncriptada, usr.idTransportista, usr.idCliente, usr.idRol, date(usr.ultimologin) as dateUltimoLogin, time(usr.ultimologin) as timeUltimoLogin, usr.idOrganization , tra.descTransportista, cli.descCliente FROM usuarios usr LEFT JOIN transportistas tra ON (tra.idTransportista = usr.idTransportista AND tra.idOrganization = usr.idOrganization) LEFT JOIN clientes cli ON (cli.idCliente = usr.idCliente AND cli.idOrganization = usr.idOrganization) WHERE usr.usuario = @USUARIO AND usr.claveEncriptada = @CLAVEENCRIPTADA AND  usr.idOrganization = @ORGANIZACION;";
				sqlite_cmd = new SQLiteCommand(query, sqlite_con);
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@USUARIO", UsuarioLogin));
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@ORGANIZACION", IdOrganizacion));
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@CLAVEENCRIPTADA", ClaveEncriptadaLogin));
				SQLiteDataReader dr = sqlite_cmd.ExecuteReader();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters) + " - " + dr.HasRows + " Registros");
				while (dr.Read())
				{
					Usuario = dr.GetString(0);
					ClaveEncriptada = dr.GetString(1);
					_IdOrganizacion = dr.GetInt32(7);
					IdRol = dr.GetInt32(4);

					switch (IdRol)
					{
						case 1: //Admin
							IdTransportista = null;
							IdCliente= null;
							break;
						case 2: //Transportista
							IdTransportista = dr.GetInt32(2);
							_DescUsuario = dr.GetString(8);
							IdCliente = null;
							break;
						default: //Cliente
							IdTransportista = null;
							_DescUsuario = dr.GetString(9);
							IdCliente = dr.GetInt32(3);
							break;
					}

					if (dr[5] == System.DBNull.Value)
					{ UltimoLogin = null; }
					else
					{
						UltimoLogin = DateTime.ParseExact(dr.GetString(5) + " " + dr.GetString(6), SQLiteDateTimeFormat, System.Globalization.CultureInfo.InvariantCulture);
					}
				}
				sqlite_con.Close();

				if ((dr != null) && (ClaveEncriptada.Equals(ClaveEncriptadaLogin)))
				{ return new DataAccess.Usuario { _Usuario = Usuario, IdTransportista = IdTransportista, IdCliente = IdCliente, IdRol= IdRol, UltimoLogin = UltimoLogin, IdOrganizacion = _IdOrganizacion, DescUsuario = _DescUsuario }; }
				else
				{ return null; }
			}
			catch (Exception ex)
			{
				CustomLogging.LogError(MethodBase.GetCurrentMethod(), ex, UsuarioLogin, ClaveEncriptadaLogin, IdOrganizacion);
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters));
				return null;
			}
		}

		public string VerificarVersionComponente(string Componente)
		{
			SQLiteCommand sqlite_cmd = null;
			try
			{
				string Version = "";

				SQLiteConnection sqlite_con = new SQLiteConnection(dbConnectionStringRO);
				sqlite_con.Open();
				string query = "SELECT version FROM versiones WHERE componente = @COMPONENTE;";
				sqlite_cmd = new SQLiteCommand(query, sqlite_con);
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@COMPONENTE", Componente));
				SQLiteDataReader dr = sqlite_cmd.ExecuteReader();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters) + " - " + dr.HasRows + " Registros");
				while (dr.Read())
				{
					if (dr[0] != System.DBNull.Value)
					{ Version = dr.GetString(0); }
					else
					{
						Version = "";
					}
				}
				sqlite_con.Close();

				return Version;
			}
			catch (Exception ex)
			{
				CustomLogging.LogError(MethodBase.GetCurrentMethod(), ex, Componente);
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters));
				return "";
			}
		}

		public List<Envio> ObtenerEnvios(int? idTransportista, int? IdCliente, int? IdRol,int idOrganization, int Estado)
		{
			SQLiteCommand sqlite_cmd = null;
			List<Envio> Result = new List<Envio>();
			try
			{
				SQLiteConnection sqlite_con = new SQLiteConnection(dbConnectionStringRO);
				sqlite_con.Open();

				string query = "";

				switch (IdRol)
				{
					case 1: //Admin
						query = "SELECT env.idEnvio,env.idCliente,env.idEstado,date(env.fechaCarga) as dateFechaCarga,time(env.fechaCarga) as timeFechaCarga,date(env.fechaEnvio) as dateFechaEnvio, time(env.fechaEnvio) as timeFechaEnvio,env.geoLatitud, env.geoLongitud,env.idTransportista,cli.descCliente,tra.descTransportista,cli.descCliente,est.descEstado FROM envios env, transportistas tra, clientes cli, estados est WHERE tra.idTransportista = env.idTransportista AND cli.idCliente = env.idCliente AND est.idEstado = env.idEstado AND env.idOrganization = @ORGANIZACION AND env.idEstado = @ESTADO ORDER BY env.fechaCarga DESC;";
						sqlite_cmd = new SQLiteCommand(query, sqlite_con);
						sqlite_cmd.Parameters.Add(new SQLiteParameter("@ORGANIZACION", idOrganization));
						sqlite_cmd.Parameters.Add(new SQLiteParameter("@ESTADO", Estado));
						break;
					case 2: //Transportista
						query = "SELECT env.idEnvio,env.idCliente,env.idEstado,date(env.fechaCarga) as dateFechaCarga,time(env.fechaCarga) as timeFechaCarga,date(env.fechaEnvio) as dateFechaEnvio, time(env.fechaEnvio) as timeFechaEnvio,env.geoLatitud, env.geoLongitud,env.idTransportista,cli.descCliente,tra.descTransportista,cli.descCliente,est.descEstado FROM envios env, transportistas tra, clientes cli, estados est WHERE tra.idTransportista = env.idTransportista AND cli.idCliente = env.idCliente AND est.idEstado = env.idEstado AND env.idOrganization = @ORGANIZACION AND env.idEstado = @ESTADO AND env.idTransportista = @TRANSPORTISTA ORDER BY env.fechaCarga DESC;";
						sqlite_cmd = new SQLiteCommand(query, sqlite_con);
						sqlite_cmd.Parameters.Add(new SQLiteParameter("@TRANSPORTISTA", idTransportista));
						sqlite_cmd.Parameters.Add(new SQLiteParameter("@ORGANIZACION", idOrganization));
						sqlite_cmd.Parameters.Add(new SQLiteParameter("@ESTADO", Estado));
						break;
					default: //Cliente
						query = "SELECT env.idEnvio,env.idCliente,env.idEstado,date(env.fechaCarga) as dateFechaCarga,time(env.fechaCarga) as timeFechaCarga,date(env.fechaEnvio) as dateFechaEnvio, time(env.fechaEnvio) as timeFechaEnvio,env.geoLatitud, env.geoLongitud,env.idTransportista,cli.descCliente,tra.descTransportista,cli.descCliente,est.descEstado FROM envios env, transportistas tra, clientes cli, estados est WHERE tra.idTransportista = env.idTransportista AND cli.idCliente = env.idCliente AND est.idEstado = env.idEstado AND env.idOrganization = @ORGANIZACION AND env.idEstado = @ESTADO AND env.idCliente = @CLIENTE ORDER BY env.fechaCarga DESC;";
						sqlite_cmd = new SQLiteCommand(query, sqlite_con);
						sqlite_cmd.Parameters.Add(new SQLiteParameter("@CLIENTE", IdCliente));
						sqlite_cmd.Parameters.Add(new SQLiteParameter("@ORGANIZACION", idOrganization));
						sqlite_cmd.Parameters.Add(new SQLiteParameter("@ESTADO", Estado));
						break;
				}

				SQLiteDataReader dr = sqlite_cmd.ExecuteReader();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters) + " - " + dr.HasRows + " Registros");

				while (dr.Read())
				{
					DateTime? tempFechaEnvio;
					double? tempGeoLatitud;
					double? tempGeoLongitud;

					if (dr["dateFechaEnvio"] == System.DBNull.Value)
					{ tempFechaEnvio = null; }
					else
					{
						tempFechaEnvio = DateTime.ParseExact(dr["dateFechaEnvio"].ToString() + " " + dr["timeFechaEnvio"].ToString(), SQLiteDateTimeFormat, System.Globalization.CultureInfo.InvariantCulture);
					}

					if (dr["geoLatitud"] == System.DBNull.Value)
					{ tempGeoLatitud = null; }
					else
					{
						tempGeoLatitud = Convert.ToDouble(dr["geoLatitud"]);
					}

					if (dr["geoLongitud"] == System.DBNull.Value)
					{ tempGeoLongitud = null; }
					else
					{
						tempGeoLongitud = Convert.ToDouble(dr["geoLongitud"]);
					}

					Result.Add(new Envio
					{
						IdEnvio = Convert.ToInt32(dr["idEnvio"]),
						IdCliente = Convert.ToInt32(dr["idCliente"]),
						IdTransportista = Convert.ToInt32(dr["idTransportista"]),
						FechaCarga = DateTime.ParseExact(dr["dateFechaCarga"].ToString() + " " + dr["timeFechaCarga"].ToString(), SQLiteDateTimeFormat, System.Globalization.CultureInfo.InvariantCulture),
						FechaEnvio = tempFechaEnvio,
						IdEstado = Convert.ToInt32(dr["idEstado"].ToString()),
						GeoLatitud = tempGeoLatitud,
						GeoLongitud = tempGeoLongitud,
						DescCliente = dr["descCliente"].ToString(),
						DescTransportista = dr["descTransportista"].ToString(),
						DescEstado = dr["descEstado"].ToString(),
					});
				}
				return Result;
			}
			catch (Exception ex)
			{
				CustomLogging.LogError(MethodBase.GetCurrentMethod(), ex, idTransportista, idOrganization, Estado);
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters));
				return Result;
			}
		}

		public List<Cliente> ObtenerClientes()
		{
			List<Cliente> Result = new List<Cliente>();
			try
			{
				string constr = string.Format(ConfigurationManager.AppSettings["StrConnDBF"], Path.GetDirectoryName(ConfigurationManager.AppSettings["ClientesDBFPath"]));
				using (OleDbConnection dbf_con = new OleDbConnection(constr))
				{
					var dbf_sql = "select * from " + Path.GetFileName(ConfigurationManager.AppSettings["ClientesDBFPath"]);
					OleDbCommand dbf_cmd = new OleDbCommand(dbf_sql, dbf_con);
					dbf_con.Open();
					DataSet dbf_ds = new DataSet();
					OleDbDataAdapter dbf_da = new OleDbDataAdapter(dbf_cmd);
					dbf_da.Fill(dbf_ds);
					dbf_con.Close();
					CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, dbf_sql + " - " + dbf_ds.Tables[0].Rows.Count + " Registros");

					foreach (DataRow dbf_dr in dbf_ds.Tables[0].Rows)
					{
						if (dbf_dr["ACTIVO"].ToString().Trim() == "S" && !dbf_dr["TRANSPORTE"].ToString().Trim().Equals(""))
						{
							Result.Add(new Cliente { IdCliente = Convert.ToInt32(dbf_dr["CODIGO"]), DescCliente = dbf_dr["NOMBRE"].ToString().ToUpper(), IdTransportista = Convert.ToInt32(dbf_dr["TRANSPORTE"]) });
						}
					}
				}

				return Result;

			}
			catch (Exception ex)
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, ex.StackTrace);
				return Result;
			}
		}

		public List<Transportista> ObtenerTransportistas()
		{
			List<Transportista> Result = new List<Transportista>();
			try
			{
				string constr = string.Format(ConfigurationManager.AppSettings["StrConnDBF"], Path.GetDirectoryName(ConfigurationManager.AppSettings["TransportDBFPath"]));
				using (OleDbConnection dbf_con = new OleDbConnection(constr))
				{
					var dbf_sql = "select * from " + Path.GetFileName(ConfigurationManager.AppSettings["TransportDBFPath"]);
					OleDbCommand dbf_cmd = new OleDbCommand(dbf_sql, dbf_con);
					dbf_con.Open();
					DataSet dbf_ds = new DataSet();
					OleDbDataAdapter dbf_da = new OleDbDataAdapter(dbf_cmd);
					dbf_da.Fill(dbf_ds);
					dbf_con.Close();
					CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, dbf_sql + " - " + dbf_ds.Tables[0].Rows.Count + " Registros");

					foreach (DataRow dbf_dr in dbf_ds.Tables[0].Rows)
					{
						Result.Add(new Transportista { IdTransportista = Convert.ToInt32(dbf_dr["CODIGO"]),DescTransportista = dbf_dr["NOMBRE"].ToString().ToUpper() });
					}
				}

				return Result;

			}
			catch (Exception ex)
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, ex.StackTrace);
				return Result;
			}
		}

		public bool SyncroTransportistas()
		{
			try
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, "Inicio Syncro Transportistas");
				List<Transportista> Transportistas = ObtenerTransportistas();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, "ObtenerTransportistas - " + Transportistas.Count + " Objetos");

				foreach (Transportista Tr in Transportistas)
				{
					SyncroAnalizarTransportista(Tr);
				}

				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, "Fin Syncro Transportistas");
				return true;
			}
			catch
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, "Syncro Transportistas");
				return false;
			}
		}

		public bool InsertarTransportista(Transportista Tr)
		{
			SQLiteConnection sqlite_con = new SQLiteConnection(dbConnectionStringNoRO);
			sqlite_con.Open();
			string query = "";
			SQLiteCommand sqlite_cmd = new SQLiteCommand();
			try
			{
				query = "INSERT INTO transportistas (idTransportista,descTransportista,idOrganization) VALUES (@IDTRANSPORTISTA,@DESCTRANSPORTISTA,@IDORGANIZACION);";
			  sqlite_cmd = new SQLiteCommand(query, sqlite_con);
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@IDTRANSPORTISTA", Tr.IdTransportista));
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@DESCTRANSPORTISTA", Tr.DescTransportista));
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@IDORGANIZACION", System.Configuration.ConfigurationManager.AppSettings["IdOrganizacion"]));
				int Insertados = sqlite_cmd.ExecuteNonQuery();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters) + " - " + Insertados + " Registros");
				if (Insertados  > 0)
				{ return true; }
				else
				{ return false; }
			}
			catch (SQLiteException ex)
			{

				if (ex.ErrorCode == 19) //Constraint
				{ return false; }
				else
				{
					CustomLogging.LogError(MethodBase.GetCurrentMethod(), ex);
					CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters));
					throw ex;
				}
			}
		}

		public bool InsertarCliente(Cliente Cl)
		{
			SQLiteConnection sqlite_con = new SQLiteConnection(dbConnectionStringNoRO);
			sqlite_con.Open();
			string query = "";
			SQLiteCommand sqlite_cmd = new SQLiteCommand();
			try
			{
				query = "INSERT INTO Clientes (idCliente,descCliente,idOrganization) VALUES (@IDCLIENTE,@DESCCLIENTE,@IDORGANIZACION);";
				sqlite_cmd = new SQLiteCommand(query, sqlite_con);
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@IDCLIENTE", Cl.IdCliente));
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@DESCCLIENTE", Cl.DescCliente));
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@IDORGANIZACION", System.Configuration.ConfigurationManager.AppSettings["IdOrganizacion"]));
				int Insertados = sqlite_cmd.ExecuteNonQuery();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters) + " - " + Insertados + " Registros");
				if (Insertados > 0)
				{ return true; }
				else
				{ return false; }
			}
			catch (SQLiteException ex)
			{

				if (ex.ErrorCode == 19) //Constraint
				{ return false; }
				else
				{
					CustomLogging.LogError(MethodBase.GetCurrentMethod(), ex);
					CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters));
					throw ex;
				}
			}
		}

		private void SyncroAnalizarTransportista(Transportista _Transportista)
		{
			try
			{
				bool Insertado = InsertarTransportista(_Transportista);
				if (Insertado)
				{
					CustomLogging.LogMessage(CustomLogging.TracingLevel.INFO, "Insertado Transportista " + _Transportista.IdTransportista + " - " + _Transportista.DescTransportista);
				}
				else
				{
					CustomLogging.LogMessage(CustomLogging.TracingLevel.INFO, "Esistente Transportista " + _Transportista.IdTransportista + " - " + _Transportista.DescTransportista);
				}
			}
			catch(Exception ex)
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, "Analizando Transportista " + _Transportista.IdTransportista + " - " + _Transportista.DescTransportista + " - " + ex.StackTrace);
			}
		}

		public bool SyncroClientes()
		{
			try
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, "Inicio Syncro Clientes");
				List<Cliente> Clientes = ObtenerClientes();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, "ObtenerClientes - " + Clientes.Count + " Objetos");

				foreach (Cliente Cl in Clientes)
				{
					SyncroAnalizarCliente(Cl);
				}

				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, "Fin Syncro Clientes");
				return true;
			}
			catch (Exception ex)
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, "Syncro Transportistas" + " - " + ex.StackTrace);
				return false;
			}
		}

		private void SyncroAnalizarCliente(Cliente _Cliente)
		{
			try
			{
				bool Insertado = InsertarCliente(_Cliente);
				if (Insertado)
				{
					CustomLogging.LogMessage(CustomLogging.TracingLevel.INFO, "Insertado Cliente " + _Cliente.IdCliente + " - " + _Cliente.DescCliente);
				}
				else
				{
					CustomLogging.LogMessage(CustomLogging.TracingLevel.INFO, "Esistente Cliente " + _Cliente.IdCliente + " - " + _Cliente.DescCliente);
				}
			}
			catch (Exception ex)
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, "Analizando Cliente " + _Cliente.IdCliente + " - " + _Cliente.DescCliente + " - " + ex.StackTrace);
			}
		}

		public bool SyncroRelTransportistaClientes()
		{
			try
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, "Inicio Syncro Relacion Tranportista Clientes");
				List<Cliente> Clientes = ObtenerClientes();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, "ObtenerClientes - " + Clientes.Count + " Objetos");

				foreach (Cliente Cl in Clientes)
				{
					SyncroAnalizarRelTransportistaClientes(Cl);
				}

				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, "Fin Syncro Relacion Tranportista Clientes");
				return true;
			}
			catch
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, "Syncro Syncro Relacion Tranportista Clientes");
				return false;
			}
		}

		private void SyncroAnalizarRelTransportistaClientes(Cliente _Cliente)
		{
			try
			{
				bool Insertado = InsertarRelTransportistaClientes(_Cliente);
				if (Insertado)
				{
					CustomLogging.LogMessage(CustomLogging.TracingLevel.INFO, "Insertado Relacion Tranportista Clientes " + _Cliente.IdCliente + " - " + _Cliente.DescCliente);
				}
				else
				{
					CustomLogging.LogMessage(CustomLogging.TracingLevel.INFO, "Esistente Relacion Tranportista Clientes " + _Cliente.IdCliente + " - " + _Cliente.DescCliente);
				}
			}
			catch
			{
				CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, "Analizando Relacion Tranportista Clientes " + _Cliente.IdCliente + " - " + _Cliente.DescCliente);
			}
		}

		private bool InsertarRelTransportistaClientes(Cliente Cl)
		{
			SQLiteConnection sqlite_con = new SQLiteConnection(dbConnectionStringNoRO);
			sqlite_con.Open();
			string query = "";
			SQLiteCommand sqlite_cmd = new SQLiteCommand();
			try
			{
				query = "INSERT INTO rel_clientes_transportistas (idCliente,idTransportista) VALUES (@IDCLIENTE,@IDTRANSPORTISTA);";
				sqlite_cmd = new SQLiteCommand(query, sqlite_con);
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@IDCLIENTE", Cl.IdCliente));
				sqlite_cmd.Parameters.Add(new SQLiteParameter("@IDTRANSPORTISTA",Cl.IdTransportista));
				int Insertados = sqlite_cmd.ExecuteNonQuery();
				CustomLogging.LogMessage(CustomLogging.TracingLevel.DEBUG, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters) + " - " + Insertados + " Registros");
				if (Insertados > 0)
				{ return true; }
				else
				{ return false; }
			}
			catch (SQLiteException ex)
			{

				if (ex.ErrorCode == 19) //Constraint
				{ return false; }
				else
				{
					CustomLogging.LogError(MethodBase.GetCurrentMethod(), ex);
					CustomLogging.LogMessage(CustomLogging.TracingLevel.ERROR, sqlite_cmd.CommandText + " - " + Parameters(sqlite_cmd.Parameters));
					throw ex;
				}
			}
		}
	}
}
