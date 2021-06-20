using WebLogistica.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebLogistica.Web.Domain
{
	public class NavbarData
	{
		public IEnumerable<Navbar> NavbarItems()
		{
			var menu = new List<Navbar>();
			menu.Add(new Navbar { Id = 1, nameOption = "Nuevo Envio", controller = "Envios", action = "Nuevo", imageClass = "fa fa-fw fa-paper-plane-o", isParent = false, parentId = -1 });
			menu.Add(new Navbar { Id = 2, nameOption = "Planilla Envios", controller = "Envios", action = "Planilla", imageClass = "fa fa-fw fa-arrow-right", isParent = false, parentId = -1 });
			menu.Add(new Navbar { Id = 3, nameOption = "Consulta Clientes", controller = "Clientes", action = "Listado", imageClass = "fa fa-fw fa-users", isParent = false, parentId = -1 });
			menu.Add(new Navbar { Id = 4, nameOption = "Seguridad Acceso", controller = "Seguridad", action = "Acceso", imageClass = "fa fa-fw fa-lock", isParent = false, parentId = -1 });

			return menu.ToList();
		}

		public IEnumerable<Rol> Roles()
		{
			var roles = new List<Rol>();
			roles.Add(new Rol { Id = 1, rol = "Admin" });
			roles.Add(new Rol { Id = 2, rol = "Transportista" });
			roles.Add(new Rol { Id = 3, rol = "Cliente" });
			return roles.ToList();
		}

		public IEnumerable<Grants> Grants()
		{
			var grants = new List<Grants>();
			grants.Add(new Grants { rowid = 1, idRol = 1, idMenu = 1, status = true });
			grants.Add(new Grants { rowid = 2, idRol = 1, idMenu = 2, status = true });
			grants.Add(new Grants { rowid = 3, idRol = 1, idMenu = 3, status = true });
			grants.Add(new Grants { rowid = 4, idRol = 1, idMenu = 4, status = true });

			return grants.ToList();
		}


		public IEnumerable<Navbar> itemsPerUser(string controller, string action, int? idRol)
		{

			IEnumerable<Navbar> items = NavbarItems();
			IEnumerable<Grants> grantsNav = Grants();
			IEnumerable<Rol> rolesNav = Roles();

			var navbar = items.Where(p => p.controller == controller && p.action == action).Select(c => { c.activeli = "active"; return c; }).ToList();

			navbar = (from nav in items
								join grants in grantsNav on nav.Id equals grants.idMenu
								join roles in rolesNav on grants.idRol equals roles.Id
								where roles.Id == idRol
								select new Navbar
								{
									Id = nav.Id,
									nameOption = nav.nameOption,
									controller = nav.controller,
									action = nav.action,
									area = nav.area,
									havingImageClass = nav.havingImageClass,
									imageClass = nav.imageClass,
									activeli = nav.activeli,
									parentId = nav.parentId,
									isParent = nav.isParent
								}).ToList();

			return navbar.ToList();
		}
	}
}