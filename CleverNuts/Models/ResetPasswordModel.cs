using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CleverNuts.Models
{
        public class ResetPasswordModel
        {
            [Required]
            public string Token { get; set; }
            [Required]
            public string UserName { get; set; }
            [Required]
            [DataType(DataType.Password)]
            [Display(Name = "New password")]
            public string NewPassword { get; set; }
            [Required]
            [DataType(DataType.Password)]
            [Display(Name = "Confirm password")]
            public string ConfirmNewPassword { get; set; }
        }
}