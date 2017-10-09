using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Globalization;
using System.Web.Security;

namespace CleverNuts.Models
{
    public class AWLFacturesContext : DbContext
    {
        public AWLFacturesContext()
            : base("DefaultConnection")
        {
        }

        public DbSet<AWLFacture> FacturesTable { get; set; }
    }

    [Table("AWLFactures")]
    public class AWLFacture
    {
        [Key]
        public string IdPaiement { get; set; }
        public string Buyer { get; set; }
        public string Article { get; set; }
        public decimal Montant { get; set; }
        public string Plateforme { get; set; }
    }
}
