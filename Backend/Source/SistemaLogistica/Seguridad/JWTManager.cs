using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.ServiceModel.Security.Tokens;

namespace com.Sistema.Logistica.Seguridad
{
	public class JWTManager
	{
		private string JWTSecretKey = System.Configuration.ConfigurationManager.AppSettings["JWTSecretKey"];
		private string JWTIssuer = System.Configuration.ConfigurationManager.AppSettings["JWTIssuer"];
		private int JWTMinutesTTL = int.Parse(System.Configuration.ConfigurationManager.AppSettings["JWTMinutesTTL"]);

		public Object GetToken(string Usuario, int? IdTransportista, int? IdCliente, int? IdRol, DateTime? UltimoLogin, int? IdOrganizacion, string DescUsuario = null)
		{
			var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(JWTSecretKey));
			var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

			//Create a List of Claims, Keep claims name short    
			var permClaims = new List<Claim>();
			permClaims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
			permClaims.Add(new Claim("Usuario", Usuario));
			if (IdTransportista != null) { permClaims.Add(new Claim("IdTransportista", IdTransportista.ToString())); }
			if (IdCliente != null) { permClaims.Add(new Claim("IdCliente", IdCliente.ToString())); }
			permClaims.Add(new Claim("IdRol", IdRol.ToString()));
			permClaims.Add(new Claim("UltimoLogin", UltimoLogin.ToString()));
			permClaims.Add(new Claim("IdOrganizacion", IdOrganizacion.ToString()));
			permClaims.Add(new Claim("DescUsuario", DescUsuario.ToString()));

			//Create Security Token object by giving required parameters    
			var token = new JwtSecurityToken(JWTIssuer, //Issure    
											JWTIssuer,  //Audience    
											permClaims,
											expires: DateTime.Now.AddMinutes(JWTMinutesTTL),
											signingCredentials: credentials);
			var jwt_token = new JwtSecurityTokenHandler().WriteToken(token);
			return new { data = jwt_token, Usuario = Usuario, IdTransportista = IdTransportista, idCliente = IdCliente, IdRol = IdRol, UltimoLogin = UltimoLogin, IdOrganizacion = IdOrganizacion, DescUsuario = DescUsuario};
		}

		public Object RefreshToken(string Token)
		{
			var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(JWTSecretKey));
			var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

			var tokenHandler = new JwtSecurityTokenHandler();
			var jwtToken = tokenHandler.ReadToken(Token) as JwtSecurityToken;

			TokenValidationParameters TokenValidationParameters = new TokenValidationParameters()
			{
				ValidateLifetime = false,
				ValidateIssuer = true,
				ValidateAudience = true,
				ValidateIssuerSigningKey = true,
				ValidIssuer = System.Configuration.ConfigurationManager.AppSettings["JWTIssuer"], //some string, normally web url,  
				ValidAudience = System.Configuration.ConfigurationManager.AppSettings["JWTIssuer"],
				IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(System.Configuration.ConfigurationManager.AppSettings["JWTSecretKey"]))
			};

			try
			{
				SecurityToken securityToken;
				var principal = tokenHandler.ValidateToken(Token, TokenValidationParameters, out securityToken);

				var token = new JwtSecurityToken(JWTIssuer, //Issure    
								JWTIssuer,  //Audience    
								principal.Claims,
								expires: DateTime.Now.AddMinutes(JWTMinutesTTL),
								signingCredentials: credentials);
				var jwt_token = new JwtSecurityTokenHandler().WriteToken(token);
				return new { data = jwt_token };
			}
			catch
			{
				return null;
			}			
		}
	}
}
