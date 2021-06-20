using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebLogistica.Web.Models
{
    public class Grants
    {
        public int rowid { get; set; }
        public int idRol { get; set; }
        public int idMenu { get; set; }
        public bool status { get; set; }
    }
}