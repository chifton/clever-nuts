using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Globalization;
using System.Web.Security;

namespace CleverNuts.Models
{
    public class AWLFacebookContext : DbContext
    {
        public AWLFacebookContext()
            : base("DefaultConnection")
        {
        }

        public DbSet<AWLFacebookProfile> FacebookNuttersTable { get; set; }
    }

    [Table("FacebookNuttersProfile")]
    public class AWLFacebookProfile
    {
        [Key]
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public int UserNuts1 { get; set; }
        public int UserNuts2 { get; set; }
        public int UserNuts3 { get; set; }
        public int UserBonus { get; set; }
        public int UserLevel { get; set; }
    }
}
