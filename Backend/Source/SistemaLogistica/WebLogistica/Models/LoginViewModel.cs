using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Collections.Specialized;
using System.Web.Mvc;
using System.Collections.Generic;

namespace WebLogistica.Web.Models
{
    public class LoginViewModel
    {
        [Required (ErrorMessage = "El usuario es obligatorio")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "La Clave es obligatoria")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        public string LogoImg { get; set; }
        
        public LoginViewModel()
        {
            LogoImg = ConfigurationManager.AppSettings["ImagenLogin"];
        }
    }
}