using Microsoft.Owin.Security.Jwt;
using Microsoft.Owin.Security;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(SistemaLogistica.Startup))]

namespace SistemaLogistica
{
	public class Startup
	{
		public void Configuration(IAppBuilder app)
		{
			app.UseJwtBearerAuthentication(
					new JwtBearerAuthenticationOptions
					{
						AuthenticationMode = AuthenticationMode.Active,
						TokenValidationParameters = new TokenValidationParameters()
						{
							ValidateIssuer = true,
							ValidateAudience = true,
							ValidateIssuerSigningKey = true,
							ValidIssuer = System.Configuration.ConfigurationManager.AppSettings["JWTIssuer"], //some string, normally web url,  
										ValidAudience = System.Configuration.ConfigurationManager.AppSettings["JWTIssuer"],
							IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(System.Configuration.ConfigurationManager.AppSettings["JWTSecretKey"]))
						}
					});
		}
	}
}
